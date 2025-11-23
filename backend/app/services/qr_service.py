import qrcode
from io import BytesIO

def gerar_qr_code(conteudo: str) -> bytes:
    qr = qrcode.QRCode(version=1, box_size=8, border=3)
    qr.add_data(conteudo)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")
    buffer = BytesIO()
    img.save(buffer, format="PNG")
    return buffer.getvalue()