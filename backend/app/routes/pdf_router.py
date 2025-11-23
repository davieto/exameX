from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from io import BytesIO
from app.db import get_db
from app.models.prova_model import Prova
from app.models.prova_questao_objetiva_model import ProvaQuestaoObjetiva
from app.models.questao_objetiva_model import QuestaoObjetiva
from app.services.pdf_service import gerar_pdf_prova

router = APIRouter(prefix="/pdf", tags=["PDF"])

@router.get("/{id_prova}")
def exportar_pdf(id_prova: int, db: Session = Depends(get_db)):
    prova = db.query(Prova).filter(Prova.idProva == id_prova).first()
    if not prova:
        return {"erro": "Prova não encontrada"}

    vinculos = db.query(ProvaQuestaoObjetiva).filter_by(idProva=id_prova).all()
    ids_q = [v.idQuestaoObjetiva for v in vinculos]
    questoes = db.query(QuestaoObjetiva).filter(QuestaoObjetiva.idQuestaoObjetiva.in_(ids_q)).all()

    pdf_bytes = gerar_pdf_prova(prova, questoes)
    prova.pdf = pdf_bytes
    db.commit()

    return StreamingResponse(BytesIO(pdf_bytes),
                             media_type="application/pdf",
                             headers={"Content-Disposition": f"inline; filename=prova_{id_prova}.pdf"})