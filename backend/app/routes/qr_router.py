from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from io import BytesIO
from app.db import get_db
from app.models.prova_model import Prova
from app.services.qr_service import gerar_qr_code

router = APIRouter(prefix="/qr", tags=["QR Code"])

@router.get("/{id_prova}")
def gerar_qr(id_prova: int, db: Session = Depends(get_db)):
    prova = db.query(Prova).filter(Prova.idProva == id_prova).first()
    if not prova:
        return {"erro": "Prova não encontrada"}
    qr_bytes = gerar_qr_code(f"prova:{id_prova}")
    prova.qrCode = qr_bytes
    db.commit()
    return StreamingResponse(BytesIO(qr_bytes), media_type="image/png")