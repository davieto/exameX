import cv2 as cv
import numpy as np
from pyzbar.pyzbar import decode
from app.db import SessionLocal
from app.models.prova_model import Prova
from app.models.questao_objetiva_model import QuestaoObjetiva

# =========================
# CONFIGURAÇÕES
# =========================
LARGURA = 1280
ALTURA = 720
QUESTOES = 10
ALTERNATIVAS = 5


# =========================
# BANCO DE DADOS
# =========================
def buscar_gabarito_banco(idProva, db):
    prova = db.query(Prova).filter(Prova.idProva == idProva).first()
    if not prova:
        raise ValueError(f"Prova {idProva} não encontrada.")

    questoes = [v.idQuestaoObjetiva for v in prova.questoes_objetivas]
    objs = (
        db.query(QuestaoObjetiva)
        .filter(QuestaoObjetiva.idQuestaoObjetiva.in_(questoes))
        .all()
    )

    gabarito = []
    for q in objs:
        correta = next((a for a in q.alternativas if a.afirmativa == 1), None)
        letra_correta = chr(65 + q.alternativas.index(correta)) if correta else "A"
        gabarito.append(letra_correta)
    return gabarito


# =========================
# GEOMETRIA E PERSPECTIVA
# =========================
def reordenarPontos(pontos):
    pontos = pontos.reshape((4, 2))
    soma = pontos.sum(1)
    diff = np.diff(pontos, axis=1)
    return np.array([
        pontos[np.argmin(soma)],   # canto sup. esquerdo
        pontos[np.argmin(diff)],   # sup. direito
        pontos[np.argmax(diff)],   # inf. esquerdo
        pontos[np.argmax(soma)]    # inf. direito
    ], dtype=np.float32)


def corrigePerspectiva(img, contorno):
    perimetro = cv.arcLength(contorno, True)
    approx = cv.approxPolyDP(contorno, 0.02 * perimetro, True)
    if len(approx) != 4:
        return img
    pts1 = reordenarPontos(approx)
    pts2 = np.float32([[0, 0], [LARGURA, 0], [0, ALTURA], [LARGURA, ALTURA]])
    matriz = cv.getPerspectiveTransform(pts1, pts2)
    return cv.warpPerspective(img, matriz, (LARGURA, ALTURA))


# =========================
# LACUNAS E MARCAÇÕES
# =========================
def identificar_lacunas(contornos, img):
    img_lacunas = img.copy()
    proporcao_min, proporcao_max = 0.9, 1.1
    tam_min, tam_max = 50, 70
    contornos_filtrados = []
    for c in contornos:
        x, y, w, h = cv.boundingRect(c)
        prop = w / float(h)
        if (
            tam_min <= w <= tam_max
            and tam_min <= h <= tam_max
            and proporcao_min <= prop <= proporcao_max
        ):
            contornos_filtrados.append(c)
            cv.rectangle(img_lacunas, (x, y), (x + w, y + h), (0, 255, 63), 2)
    return contornos_filtrados, img_lacunas


def ordenarLacunas(contornos, metodo="esq-dir"):
    indice = 0 if metodo == "esq-dir" else 1
    caixas = [cv.boundingRect(c) for c in contornos]
    (contornos, caixas) = zip(
        *sorted(zip(contornos, caixas), key=lambda b: b[1][indice])
    )
    return contornos, caixas


def identificaMarcacoes(contornosLacunas, imgArea, imgBin):
    """Retorna imagem com marcações desenhadas + lista de respostas"""
    imgMarcacoes = imgArea.copy()
    respostas = []

    valores = np.zeros((QUESTOES, ALTERNATIVAS), dtype=int)
    for (indice, linha) in enumerate(np.arange(0, len(contornosLacunas), ALTERNATIVAS)):
        lacunas_linha = ordenarLacunas(
            contornosLacunas[linha:linha + ALTERNATIVAS])[0]

        # conta pixels por alternativa
        for (j, lacuna) in enumerate(lacunas_linha):
            mask = np.zeros(imgBin.shape, dtype="uint8")
            cv.drawContours(mask, [lacuna], -1, 255, -1)
            mask = cv.bitwise_and(imgBin, imgBin, mask=mask)
            total = cv.countNonZero(mask)
            valores[indice][j] = total

        # define a alternativa mais escura (marcada)
        idx = np.argmax(valores[indice])
        if idx < ALTERNATIVAS:
            respostas.append(chr(65 + idx))
            cv.drawContours(imgMarcacoes, [lacunas_linha[idx]], -1, (0, 0, 255), 3)

    return respostas, imgMarcacoes


# =========================
# PIPELINE DE PROCESSAMENTO
# =========================
def processar_video():
    cap = cv.VideoCapture(1)
    cap.set(cv.CAP_PROP_FRAME_WIDTH, LARGURA)
    cap.set(cv.CAP_PROP_FRAME_HEIGHT, ALTURA)
    if not cap.isOpened():
        raise RuntimeError("Câmera não encontrada")

    print("\n🎥 OMR ao vivo com modo debug — 'Q' para sair.")
    db = SessionLocal()
    detected_id = None

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        decoded = decode(frame)
        for d in decoded:
            data = d.data.decode("utf-8")
            if data.startswith("prova:"):
                detected_id = int(data.split(":")[1])
                cv.putText(frame, f"QR: Prova {detected_id}", (40, 50),
                           cv.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 0), 3)

        # processamento por etapas
        if detected_id:
            gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
            blur = cv.GaussianBlur(gray, (11, 11), 1)
            _, binaria = cv.threshold(blur, 127, 255, 1)
            conts, _ = cv.findContours(binaria, cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)
            maior = max(conts, key=cv.contourArea)

            img_persp = corrigePerspectiva(frame, maior)
            cv.imshow("1 - Contorno Detectado", frame)
            cv.waitKey(0)

            cv.imshow("2 - Planificada", img_persp)
            cv.waitKey(0)

            img_area = img_persp[340:1300, 40:1040]
            cv.imshow("3 - Área das Lacunas", img_area)
            cv.waitKey(0)

            conts_area, bin_area = cv.findContours(
                cv.cvtColor(img_area, cv.COLOR_BGR2GRAY),
                cv.RETR_TREE,
                cv.CHAIN_APPROX_SIMPLE,
            )

            lacunas, img_lacunas = identificar_lacunas(conts_area, img_area)
            cv.imshow("4 - Lacunas Filtradas", img_lacunas)
            cv.waitKey(0)

            respostas, img_marc = identificaMarcacoes(lacunas, img_area, bin_area)
            cv.imshow("5 - Marcações", img_marc)
            cv.waitKey(0)

            gabarito = buscar_gabarito_banco(detected_id, db)
            acertos = sum(1 for r, g in zip(respostas, gabarito) if r == g)
            nota = round(acertos / len(gabarito) * 10, 2)

            cv.putText(img_marc, f"Nota {nota}", (40, 60),
                       cv.FONT_HERSHEY_SIMPLEX, 1.4, (0, 0, 255), 4)
            cv.imshow("6 - Resultado Final", img_marc)
            cv.waitKey(0)

            detected_id = None  # volta a procurar outro QR

        cv.imshow("OMR – Câmera ao vivo", frame)
        if cv.waitKey(1) & 0xFF == ord("q"):
            break

    cap.release()
    cv.destroyAllWindows()
    db.close()
    print("🛑 OMR encerrado.")