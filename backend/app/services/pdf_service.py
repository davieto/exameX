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
      - Questões (com imagem, se houver)
    """
    buffer = BytesIO()
    c = canvas.Canvas(buffer, pagesize=A4)
    W, H = A4
    margem = 2 * cm

    # ========= CABEÇALHO =========
    y = H - 2 * cm
    c.setFont("Helvetica-Bold", 14)
    c.drawCentredString(W / 2, H - 1.5 * cm, prova.titulo or "Prova de __________")
    c.setFont("Helvetica", 9)
    y -= 15

    c.drawString(margem, y, "Nome: __________________________________________________________________________")
    y -= 15
    c.drawString(margem, y, "Disciplina: ____________________________")
    c.drawString(margem + 220, y, "Curso: ______________________________")
    y -= 15
    c.drawString(margem, y, "Professor: _________________________________________________________________")

    x_nota = W - 4.3 * cm
    c.rect(x_nota, H - 3.0 * cm, 2.5 * cm, 1.0 * cm)
    c.drawCentredString(x_nota + 1.25 * cm, H - 2.3 * cm, "Nota")
    c.drawString(x_nota - 35, H - 3.7 * cm, "Data: ____/____/______")

    y -= 15
    c.line(margem, y, W - margem, y)
    y -= 25

    # ========= BLOCO GABARITO + QR =========
    letras = ["a", "b", "c", "d", "e"]
    qtd_questoes = len(questoes_objetivas + (questoes_dissertativas or []))

    tam_caixa = 10
    espaco_vertical = 14
    margem_sup_inf = 30
    margem_lat = 35

    altura_gabarito = margem_sup_inf * 2 + (qtd_questoes * espaco_vertical)
    largura_gabarito = (len(letras) * 18) + margem_lat * 2 + 40

    qr_size = 90
    espaco_qr_gab = 45
    bloco_altura = max(altura_gabarito + 90, 170)
    bloco_largura = largura_gabarito + qr_size + espaco_qr_gab + 50

    y_top = y
    x_centro = (W - bloco_largura) / 2

    c.setLineWidth(1)
    c.rect(x_centro, y_top - bloco_altura, bloco_largura, bloco_altura)
    c.setFont("Helvetica", 8)
    c.drawCentredString(W / 2, y_top + 2,
                        "Marque o gabarito preenchendo completamente a região de cada alternativa.")

    qr_x = x_centro + 20
    qr_y = (y_top - bloco_altura) + (bloco_altura / 2) - (qr_size / 2)
    qr_bytes = gerar_qr_code(f"prova:{prova.idProva}")
    c.drawImage(ImageReader(BytesIO(qr_bytes)), qr_x, qr_y,
                width=qr_size, height=qr_size, mask='auto')

    # Gabarito interno
    x_gab_inicio = qr_x + qr_size + espaco_qr_gab
    margem_h_extra = 15
    margem_sup_extra = 35
    margem_inf_extra = 25
    altura_gab_box = (qtd_questoes * espaco_vertical) + margem_sup_extra + margem_inf_extra
    largura_gab_box = (len(letras) * 18) + margem_h_extra * 2 + 10

    y_centro_bloco = y_top - (bloco_altura / 2)
    y_box_sup = y_centro_bloco + (altura_gab_box / 2)
    x_box_esq = x_gab_inicio - margem_h_extra - 6

    c.setLineWidth(1.3)
    c.rect(x_box_esq, y_box_sup - altura_gab_box, largura_gab_box, altura_gab_box)

    # Marcadores pretos dos 4 cantos
    marcadores = [
        (x_box_esq - 5, y_box_sup + 5),
        (x_box_esq + largura_gab_box + 5, y_box_sup + 5),
        (x_box_esq - 5, y_box_sup - altura_gab_box - 5),
        (x_box_esq + largura_gab_box + 5, y_box_sup - altura_gab_box - 5),
    ]
    for (mx, my) in marcadores:
        c.rect(mx - 4, my - 4, 8, 8, fill=1)

    # Letras e quadradinhos
    y_centro_quadrado = y_box_sup - (altura_gab_box / 2)
    altura_conteudo = (qtd_questoes * espaco_vertical) + 20
    y_top_conteudo = y_centro_quadrado + (altura_conteudo / 2)

    for j, letra in enumerate(letras):
        c.drawCentredString(x_gab_inicio + j * 18 + 9, y_top_conteudo + 2, letra)

    y_linha = y_top_conteudo - 15
    for i in range(qtd_questoes):
        c.drawRightString(x_gab_inicio - 2, y_linha - 1, f"Q{i+1}:")
        for j in range(len(letras)):
            x_box = x_gab_inicio + j * 18 + 4
            c.rect(x_box, y_linha - tam_caixa, tam_caixa, tam_caixa)
        y_linha -= espaco_vertical

    c.drawCentredString(W / 2, y_top - bloco_altura + 8, f"Prova: {prova.idProva}")
    y = y_top - bloco_altura - 30

    # ========= QUESTÕES =========
    num = 1
    c.setFont("Helvetica", 11)
    largura_max_chars = 95

    for q in questoes_objetivas:
        enunciado = f"{num}) {q.texto or ''}"

        # --- Imagem da questão, se houver ---
        if q.imagem:
            img = ImageReader(BytesIO(q.imagem))
            w_img, h_img = img.getSize()
            proporcao = w_img / h_img
            largura = 180
            altura = largura / proporcao
            c.drawImage(
                img,
                margem,
                y - altura,
                width=largura,
                height=altura,
                preserveAspectRatio=True,
                mask='auto'
            )
            y -= altura + 10

        # --- Enunciado ---
        linhas = textwrap.wrap(enunciado, width=largura_max_chars)
        for linha in linhas:
            c.drawString(margem, y, linha)
            y -= 12

        # --- Alternativas ---
        for idx, alt in enumerate(q.alternativas):
            letra = chr(65 + idx)
            conteudo_alt = f"({letra}) {alt.texto or ''}"
            linhas_alt = textwrap.wrap(conteudo_alt, width=largura_max_chars - 5)
            for l in linhas_alt:
                c.drawString(margem + 20, y, l)
                y -= 12

        y -= 8
        num += 1

        # Se chegou ao final da página
        if y < 5 * cm:
            c.showPage()
            y = H - 3 * cm
            c.setFont("Helvetica", 11)

    # ========= QUESTÕES DISSERTATIVAS (OPCIONAIS) =========
    if questoes_dissertativas:
        for q in questoes_dissertativas:
            enunciado = f"{num}) {q.texto or ''}"
            linhas = textwrap.wrap(enunciado, width=largura_max_chars)
            for linha in linhas:
                c.drawString(margem, y, linha)
                y -= 12
            y -= 40
            num += 1

            if y < 5 * cm:
                c.showPage()
                y = H - 3 * cm
                c.setFont("Helvetica", 11)

    # ========= FINALIZA PDF =========
    c.showPage()
    c.save()
    buffer.seek(0)
    return buffer.read()