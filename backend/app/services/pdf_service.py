from io import BytesIO
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import cm
from reportlab.lib.utils import ImageReader
from app.services.qr_service import gerar_qr_code

<<<<<<< HEAD

=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
def gerar_pdf_prova(prova, questoes_objetivas, questoes_dissertativas=None, logo_bytes=None):
    buffer = BytesIO()
    c = canvas.Canvas(buffer, pagesize=A4)
    width, height = A4
    margin = 2 * cm
    y = height - margin

    # === Cabeçalho institucional ===
    if logo_bytes:
        img = ImageReader(BytesIO(logo_bytes))
<<<<<<< HEAD
        c.drawImage(img, x=margin, y=y - 60, width=60, height=60, mask='auto')

    c.setFont("Helvetica-Bold", 16)
    c.drawString(margin + 70, y - 20, prova.titulo or "Prova sem título")

    c.setFont("Helvetica", 10)

    # valores seguros (evita AttributeError)
    curso_nome = getattr(getattr(prova.turma, "curso", None), "nome", "—")
    materia_nome = getattr(getattr(prova, "materia", None), "nome", "—")
    professor_nome = getattr(getattr(prova, "professor", None), "nome", "—")

    c.drawString(margin + 70, y - 40,
                 f"Curso: {curso_nome}  |  Matéria: {materia_nome}")
    c.drawString(margin + 70, y - 55,
                 f"Professor: {professor_nome}")

    # === Gera QR Code da prova ===
    qr_bytes = gerar_qr_code(f"prova:{prova.idProva}")
    qr_reader = ImageReader(BytesIO(qr_bytes))
    c.drawImage(qr_reader, width - 4 * cm, y - 60,
                width=2.5 * cm, height=2.5 * cm, mask='auto')
=======
        c.drawImage(img, x=margin, y=y-60, width=60, height=60, mask='auto')

    c.setFont("Helvetica-Bold", 16)
    c.drawString(margin + 70, y - 20, prova.titulo or "Prova sem título")
    c.setFont("Helvetica", 10)
    c.drawString(margin + 70, y - 40, f"Curso: {prova.turma.curso.nome}  |  Matéria: {prova.materia.nome}")
    c.drawString(margin + 70, y - 55, f"Professor: {prova.professor.nome}")

    # Gera QR Code da prova
    qr_bytes = gerar_qr_code(f"prova:{prova.idProva}")
    qr_reader = ImageReader(BytesIO(qr_bytes))
    c.drawImage(qr_reader, width - 4*cm, y - 60, width=2.5*cm, height=2.5*cm, mask='auto')
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
    prova.qrCode = qr_bytes

    # === Corpo das questões ===
    y = y - 100
    numero = 1
    c.setFont("Helvetica", 11)

    for q in questoes_objetivas:
        c.drawString(margin, y, f"{numero}) {q.titulo}")
        y -= 14
<<<<<<< HEAD
        for idx, alt in enumerate(q.alternativas):
            letra = chr(65 + idx)  # A, B, C, D, E
            texto = f"({letra}) {alt.texto}" if alt.texto else ""
=======
        for alt in q.alternativas:
            texto = f"({chr(64 + alt.afirmativa)}) {alt.texto}" \
                if alt.texto else ""
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
            c.drawString(margin + 20, y, texto)
            y -= 12
        numero += 1
        y -= 8
        if y < 80:
            c.showPage()
            y = height - 80

    # === Questões Dissertativas ===
    if questoes_dissertativas:
        for q in questoes_dissertativas:
            c.drawString(margin, y, f"{numero}) {q.titulo}")
            y -= 60  # espaço para resposta
            numero += 1
            if y < 80:
                c.showPage()
                y = height - 80

    # === Observações ===
    if prova.observacoes:
        c.setFont("Helvetica-Oblique", 10)
        c.drawString(margin, y - 10, "OBSERVAÇÕES:")
        text_obj = c.beginText(margin, y - 28)
        text_obj.textLines(prova.observacoes)
        c.drawText(text_obj)
        y -= 40

    c.showPage()
    c.save()
    buffer.seek(0)
    return buffer.read()