from io import BytesIO
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import cm
from reportlab.lib.utils import ImageReader
from app.services.qr_service import gerar_qr_code
import textwrap


def gerar_pdf_prova(prova, questoes_objetivas, questoes_dissertativas=None, logo_bytes=None):
    """
    Gera um PDF de prova no formato padrão ExameX:
      - Cabeçalho padrão
      - QR Code + Gabarito (centralizado)
      - Questões
    """
    buffer = BytesIO()
    c = canvas.Canvas(buffer, pagesize=A4)
    W, H = A4
    margem = 2 * cm

    # =============== CABEÇALHO ===============
    y = H - 2 * cm
    c.setFont("Helvetica-Bold", 14)
    c.drawCentredString(W / 2, H - 1.5 * cm, prova.titulo or "Prova de __________")

    c.setFont("Helvetica", 9)
    y -= 15

    # === Primeira linha: Nome (maior traço) ===
    c.drawString(margem, y, "Nome: __________________________________________________________________________")
    y -= 15

    # === Segunda linha: Disciplina e Curso (menor espaço, mesma linha) ===
    c.drawString(margem, y, "Disciplina: ____________________________")
    c.drawString(margem + 220, y, "Curso: ______________________________")
    y -= 15

    # === Terceira linha: Professor (mesmo tamanho de Nome) + Data ===
    c.drawString(margem, y, "Professor: _________________________________________________________________")
    # --- Quadro da nota ---
    x_nota = W - 4.3 * cm
    c.rect(x_nota, H - 3.0 * cm, 2.5 * cm, 1.0 * cm)
    c.drawCentredString(x_nota + 1.25 * cm, H - 2.3 * cm, "Nota")

    # Data abaixo da caixa
    c.drawString(x_nota - 35, H - 3.7 * cm, "Data: ____/____/______")

    # Linha de separação inferior do cabeçalho
    y -= 15
    c.line(margem, y, W - margem, y)
    y -= 25

            # =============== BLOCO GABARITO + QR ===============
    bloco_altura = 140
    bloco_largura = W - 2 * margem
    y_top = y
    x_centro = (W - bloco_largura) / 2

    # Moldura
    c.rect(x_centro, y_top - bloco_altura, bloco_largura, bloco_altura)
    c.setFont("Helvetica", 8)
    c.drawCentredString(W / 2, y_top + 2,
        "Marque o gabarito preenchendo completamente a região de cada alternativa.")

    # --- parâmetros internos ---
    letras = ["a", "b", "c", "d", "e"]
    qr_size = 85                             # levemente menor
    espaco_entre_qr_gabarito = 45
    altura_quadro_gab = 5 * 12               # 5 linhas de caixas (~60 pontos)
    altura_conteudo = max(qr_size, altura_quadro_gab + 25)

    # --- Centralização geral ---
    largura_gabarito = (len(letras) * 15) + 70
    largura_total_conteudo = qr_size + espaco_entre_qr_gabarito + largura_gabarito

    x_inicio = x_centro + (bloco_largura - largura_total_conteudo) / 2
    y_conteudo_top = y_top - ((bloco_altura - altura_conteudo) / 2)

    # --- desenha o QR centralizado verticalmente dentro do bloco ---
    qr_x = x_inicio
    qr_y = y_conteudo_top - qr_size          # QR totalmente dentro da caixa
    qr_bytes = gerar_qr_code(f"prova:{prova.idProva}")
    qr_img = ImageReader(BytesIO(qr_bytes))
    c.drawImage(qr_img, qr_x, qr_y, width=qr_size, height=qr_size, mask="auto")

       # --- área do gabarito à direita ---
    x_gab_inicio = qr_x + qr_size + espaco_entre_qr_gabarito
    y_gab_top = y_conteudo_top - 15
    c.setFont("Helvetica", 9)

    # letras a‑e no topo
    for j, letra in enumerate(letras):
        c.drawCentredString(x_gab_inicio + j * 18 + 10, y_gab_top + 10, letra)

    # === tamanho maior dos quadrados ===
    tam_caixa = 10 
    espacamento_caixa = 18

    # itera sobre as questões
    y_gab = y_gab_top
    for i, q in enumerate(questoes_objetivas + (questoes_dissertativas or [])):
        c.drawString(x_gab_inicio - 28, y_gab - 2, f"Q{i + 1}:")
        if hasattr(q, "alternativas") and q.alternativas:
            for j in range(len(letras)):
                x_box = x_gab_inicio + j * espacamento_caixa + 4
                c.rect(x_box, y_gab - 11, tam_caixa, tam_caixa)
        else:
            c.drawString(x_gab_inicio + 25, y_gab - 2, "Dissertativa")
        y_gab -= 14
        
    # legenda “Prova: X”
    c.setFont("Helvetica", 8)
    c.drawCentredString(W / 2, y_top - bloco_altura + 8, f"Prova: {prova.idProva}")

    y = y_top - bloco_altura - 30

    # =============== QUESTÕES ===============
    num = 1
    c.setFont("Helvetica", 11)
    largura_max_chars = 95

    for q in questoes_objetivas:
        enunciado = f"{num}) {q.texto or ''}"
        linhas = textwrap.wrap(enunciado, width=largura_max_chars)
        for linha in linhas:
            c.drawString(margem, y, linha)
            y -= 12

        for idx, alt in enumerate(q.alternativas):
            letra = chr(65 + idx)
            conteudo_alt = f"({letra}) {alt.texto or ''}"
            linhas_alt = textwrap.wrap(conteudo_alt, width=largura_max_chars - 5)
            for l in linhas_alt:
                c.drawString(margem + 20, y, l)
                y -= 12

        y -= 8
        num += 1

        if y < 5 * cm:
            c.showPage()
            y = H - 3 * cm
            c.setFont("Helvetica", 11)

    if questoes_dissertativas:
        for q in questoes_dissertativas:
            enunciado = f"{num}) {q.texto or ''}"
            linhas = textwrap.wrap(enunciado, width=largura_max_chars)
            for linha in linhas:
                c.drawString(margem, y, linha)
                y -= 12

            # espaço para resposta
            y -= 40
            num += 1

            if y < 5 * cm:
                c.showPage()
                y = H - 3 * cm
                c.setFont("Helvetica", 11)

    # finalize
    c.showPage()
    c.save()
    buffer.seek(0)
    return buffer.read()