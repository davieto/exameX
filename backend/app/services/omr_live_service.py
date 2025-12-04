import cv2 as cv
import numpy as np
from pyzbar.pyzbar import decode
from app.db import SessionLocal
from app.models.prova_model import Prova
from app.models.questao_objetiva_model import QuestaoObjetiva
import os

# =========================
# CONFIGURAÇÕES
# =========================
LARGURA = 1280
ALTURA = 720
QUESTOES = 10
ALTERNATIVAS = 5
DEBUG = True
DEBUG_DIR = "omr_debug"

if DEBUG and not os.path.exists(DEBUG_DIR):
    os.makedirs(DEBUG_DIR)

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

def corrigePerspectiva(img, contorno, target_w=LARGURA, target_h=ALTURA):
    perimetro = cv.arcLength(contorno, True)
    approx = cv.approxPolyDP(contorno, 0.02 * perimetro, True)
    if len(approx) != 4:
        # caso não tenha 4 pontos, redimensiona para target (evita erros)
        return cv.resize(img, (target_w, target_h))
    pts1 = reordenarPontos(approx)
    pts2 = np.float32([[0, 0], [target_w, 0], [0, target_h], [target_w, target_h]])
    matriz = cv.getPerspectiveTransform(pts1, pts2)
    return cv.warpPerspective(img, matriz, (target_w, target_h))

# =========================
# LACUNAS E MARCAÇÕES (NOVAS VERSÕES)
# =========================
def identificar_lacunas(contornos, img):
    """
    Filtra contornos plausíveis de lacunas (quadradinhos).
    Retorna lista de contornos válidos e imagem de debug.
    """
    img_lacunas = img.copy()
    contornos_filtrados = []

    for c in contornos:
        x, y, w, h = cv.boundingRect(c)
        prop = w / float(h) if h > 0 else 0
        area = cv.contourArea(c)

        # parâmetros calibrados para quadradinhos da sua prova:
        if (
            15 <= w <= 60  # largura entre 15 e 60 px
            and 15 <= h <= 60  # altura entre 15 e 60 px
            and 0.6 <= prop <= 1.4  # quase quadrado
            and 150 <= area <= 5000  # área mínima e máxima
        ):
            contornos_filtrados.append(c)
            cv.rectangle(img_lacunas, (x, y), (x + w, y + h), (0, 255, 63), 2)

    if DEBUG:
        cv.drawContours(img_lacunas, contornos_filtrados, -1, (0, 255, 0), 2)
        cv.imwrite(os.path.join(DEBUG_DIR, "omr_debug_lacunas_final.jpg"), img_lacunas)

    print(f"[DEBUG] {len(contornos_filtrados)} lacunas detectadas")
    return contornos_filtrados, img_lacunas

def ordenarLacunas(contornos, metodo="esq-dir"):
    """
    Ordena contornos por posição. Retorna contornos ordenados e caixas.
    Essa função não assume agrupamento por linha — use ordenar_por_linhas para isso.
    """
    indice = 0 if metodo == "esq-dir" else 1
    caixas = [cv.boundingRect(c) for c in contornos]
    if not caixas:
        return [], []
    (contornos, caixas) = zip(
        *sorted(zip(contornos, caixas), key=lambda b: b[1][indice])
    )
    return list(contornos), list(caixas)

def ordenar_por_linhas(contornos, rows=QUESTOES, cols=ALTERNATIVAS):
    """
    Agrupa contornos por linhas usando tolerância vertical e ordena cada linha por x.
    Retorna (flat_list, linhas_list).
    linhas_list é lista de listas (cada linha contém contornos ordenados por x).
    """
    if not contornos:
        return [], []

    boxes = [cv.boundingRect(c) for c in contornos]
    ordenado_y = sorted(zip(contornos, boxes), key=lambda b: b[1][1])

    # agrupar por y com tolerância
    linhas = []
    tol = 18  # tolerância em px para considerar mesma linha
    current = []
    current_y = None
    for c, (x, y, w, h) in ordenado_y:
        if current_y is None:
            current_y = y
            current.append((c, (x, y, w, h)))
            continue
        if abs(y - current_y) <= tol:
            current.append((c, (x, y, w, h)))
        else:
            linhas.append(current)
            current = [(c, (x, y, w, h))]
            current_y = y
    if current:
        linhas.append(current)

    # ordenar cada linha por X e extrair contornos
    linhas_ord = []
    for linha in linhas:
        linha_sorted = sorted(linha, key=lambda b: b[1][0])
        linhas_ord.append([c for c, _ in linha_sorted])

    # se houver mais linhas detectadas do que QUESTOES, tenta escolher as mais prováveis (centrais)
    if len(linhas_ord) > rows:
        # escolhe as rows linhas com maior soma de larguras (heurística de importância)
        linhas_ord = sorted(linhas_ord, key=lambda ln: -sum(cv.boundingRect(c)[2] for c in ln))[:rows]
        linhas_ord = sorted(linhas_ord, key=lambda ln: cv.boundingRect(ln[0])[1])  # reordenar por y

    flat = [c for linha in linhas_ord for c in linha]
    return flat, linhas_ord

def identificaMarcacoes(contornosLacunas, imgArea, imgBin):
    """
    Usa as lacunas detectadas para identificar a alternativa preenchida em cada questão.
    Retorna (respostas, imgMarcacoes).
    """
    imgMarcacoes = imgArea.copy()
    respostas = []

    # agrupar por linhas (Q1..Qn)
    _, linhas = ordenar_por_linhas(contornosLacunas, rows=QUESTOES, cols=ALTERNATIVAS)

    for i in range(QUESTOES):
        if i >= len(linhas):
            respostas.append(None)
            continue

        linha = linhas[i]
        # garantir ALTERNATIVAS elementos: se tiver mais, pega os ALTERNATIVAS mais centrais
        linha_sorted = sorted(linha, key=lambda c: cv.boundingRect(c)[0])
        if len(linha_sorted) < ALTERNATIVAS:
            # não conseguiu detectar todas alternativas na linha
            respostas.append(None)
            continue
        bloco = linha_sorted[:ALTERNATIVAS]

        # conta pixels preenchidos em cada lacuna
        valores = []
        for lac in bloco:
            mask = np.zeros(imgBin.shape, dtype="uint8")
            cv.drawContours(mask, [lac], -1, 255, -1)
            total = cv.countNonZero(cv.bitwise_and(imgBin, imgBin, mask=mask))
            valores.append(total)

        idx = int(np.argmax(valores))
        # se o maior for muito pequeno, considera sem resposta (threshold mínimo)
        if valores[idx] < 50:  # ajuste se necessário
            respostas.append(None)
        else:
            respostas.append(chr(65 + idx))
            cv.drawContours(imgMarcacoes, [bloco[idx]], -1, (0, 0, 255), 3)

    if DEBUG:
        cv.imwrite(os.path.join(DEBUG_DIR, "omr_debug_marcacoes.jpg"), imgMarcacoes)

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

    print("\n🎥 OMR ao vivo com modo debug — 'Q' para sair.")
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
                try:
                    detected_id = int(data.split(":")[1])
                except Exception:
                    detected_id = None
                cv.putText(frame, f"QR: Prova {detected_id}", (40, 50),
                           cv.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 0), 3)

        if detected_id:
            # 1) pré-processamento
            gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
            blur = cv.GaussianBlur(gray, (5, 5), 1)

            # 2) localizar contorno externo mais proeminente (borda preta do formulário)
            # usamos threshold invertido para realçar formas escuras
            th = cv.adaptiveThreshold(blur, 255, cv.ADAPTIVE_THRESH_GAUSSIAN_C,
                                      cv.THRESH_BINARY, 31, 10)
            th_inv = cv.bitwise_not(th)
            conts, _ = cv.findContours(th_inv, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
            if not conts:
                print("[ERRO] nenhum contorno externo encontrado")
                detected_id = None
                continue

            maior = max(conts, key=cv.contourArea)
            img_persp = corrigePerspectiva(frame, maior)
            if DEBUG:
                cv.imwrite(os.path.join(DEBUG_DIR, "omr_debug_planificada.jpg"), img_persp)

            # 3) localizar área do gabarito dentro da planificada
            gray_persp = cv.cvtColor(img_persp, cv.COLOR_BGR2GRAY)

            # binarização da área com parâmetros robustos para o layout
            binaria_area = cv.adaptiveThreshold(
                gray_persp, 255, cv.ADAPTIVE_THRESH_MEAN_C, cv.THRESH_BINARY_INV, 21, 7
            )
            # fechamento suave para unir pequenas falhas nas bordas dos quadradinhos
            kernel = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
            fechado = cv.morphologyEx(binaria_area, cv.MORPH_CLOSE, kernel, iterations=2)
            if DEBUG:
                cv.imwrite(os.path.join(DEBUG_DIR, "omr_debug_binaria_area.jpg"), fechado)

            conts_area, _ = cv.findContours(fechado, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
            conts_area = sorted(conts_area, key=cv.contourArea, reverse=True)

            img_area = None
            for c in conts_area:
                x, y, w, h = cv.boundingRect(c)
                ratio = w / float(h) if h > 0 else 0
                # heurística para detectar a caixa do gabarito (ajustada para seu layout)
                if 0.4 < ratio < 1.8 and h > 200 and w > 200:
                    # seleção: se a caixa cobre as lacunas, ok
                    img_area = img_persp[y:y + h, x:x + w]
                    if DEBUG:
                        dbg = img_persp.copy()
                        cv.rectangle(dbg, (x, y), (x + w, y + h), (0, 255, 0), 2)
                        cv.imwrite(os.path.join(DEBUG_DIR, "omr_debug_area_detectada.jpg"), dbg)
                    break

            if img_area is None:
                # fallback seguro: recorta por porcentagem (garante que está dentro dos limites)
                H, W = img_persp.shape[:2]
                top = int(H * 0.10)
                bottom = int(H * 0.90)
                left = int(W * 0.30)
                right = int(W * 0.80)
                img_area = img_persp[top:bottom, left:right]
                if DEBUG:
                    dbg = img_persp.copy()
                    cv.rectangle(dbg, (left, top), (right, bottom), (0, 0, 255), 2)
                    cv.imwrite(os.path.join(DEBUG_DIR, "omr_debug_area_fallback.jpg"), dbg)

            # 4) processar área para encontrar lacunas
            gray_area = cv.cvtColor(img_area, cv.COLOR_BGR2GRAY)
            bin_area = cv.adaptiveThreshold(gray_area, 255, cv.ADAPTIVE_THRESH_MEAN_C,
                                            cv.THRESH_BINARY_INV, 21, 7)
            kernel2 = cv.getStructuringElement(cv.MORPH_RECT, (3, 3))
            bin_area = cv.morphologyEx(bin_area, cv.MORPH_CLOSE, kernel2, iterations=1)
            if DEBUG:
                cv.imwrite(os.path.join(DEBUG_DIR, "omr_debug_bin_area.jpg"), bin_area)

            conts_lac, _ = cv.findContours(bin_area, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
            if DEBUG:
                dbg = img_area.copy()
                cv.drawContours(dbg, conts_lac, -1, (0, 255, 0), 1)
                cv.imwrite(os.path.join(DEBUG_DIR, "omr_debug_conts_area.jpg"), dbg)

            # 5) filtrar lacunas
            lacunas, img_lacunas = identificar_lacunas(conts_lac, img_area)
            if DEBUG:
                cv.imwrite(os.path.join(DEBUG_DIR, "omr_debug_lacunas_filtradas.jpg"), img_lacunas)

            # 6) identificar marcações (usa imagem binária 'bin_area')
            respostas, img_marc = identificaMarcacoes(lacunas, img_area, bin_area)
            if DEBUG:
                cv.imwrite(os.path.join(DEBUG_DIR, "omr_debug_marcacoes_final.jpg"), img_marc)

            # 7) buscar gabarito e calcular nota
            try:
                gabarito = buscar_gabarito_banco(detected_id, db)
            except Exception as e:
                print("[ERRO] buscando gabarito:", e)
                gabarito = None

            if gabarito:
                acertos = sum(1 for r, g in zip(respostas, gabarito) if r == g)
                nota = round(acertos / len(gabarito) * 10, 2) if gabarito else 0.0
            else:
                acertos = 0
                nota = 0.0

            cv.putText(img_marc, f"Nota {nota}", (40, 60),
                       cv.FONT_HERSHEY_SIMPLEX, 1.2, (0, 0, 255), 3)
            cv.imshow("6 - Resultado Final", img_marc)
            cv.waitKey(0)

            detected_id = None  # volta a procurar outro QR

        cv.imshow("OMR – Câmera ao vivo", frame)
        if cv.waitKey(1) & 0xFF == ord("q"):
            break

    cap.release()
    cv.destroyAllWindows()
    try:
        db.close()
    except Exception:
        pass
    print("🛑 OMR encerrado.")
