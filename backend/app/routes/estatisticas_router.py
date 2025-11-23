from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.dashboard_model import Dashboard
from app.models.prova_model import Prova

router = APIRouter(prefix="/estatisticas", tags=["Estatísticas"])

@router.get("/turma/{id_turma}")
def estatisticas_turma(id_turma: int, db: Session = Depends(get_db)):
    provas = db.query(Prova).filter(Prova.idTurma == id_turma).all()
    if not provas: return {"media": 0.0, "total_provas": 0}

    soma_media = 0
    qtd = 0
    for p in provas:
        dash = db.query(Dashboard).filter(Dashboard.idProva == p.idProva).first()
        if dash:
            soma_media += dash.media
            qtd += 1
    return {"media_geral": soma_media / qtd if qtd else 0, "total_provas": qtd}