from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from io import StringIO
from app.db import get_db
from app.models.prova_model import Prova
from app.services.export_service import provas_para_csv

router = APIRouter(prefix="/export", tags=["Exportação"])

@router.get("/")
def exportar_provas(db: Session = Depends(get_db)):
    provas = db.query(Prova).all()
    csv_data = provas_para_csv(provas)

    buffer = StringIO(csv_data)
    return StreamingResponse(
        iter([buffer.getvalue()]),
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=provas.csv"},
    )