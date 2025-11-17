from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.prova_model import Prova

router = APIRouter()

@router.get("/")
def listar_provas(db: Session = Depends(get_db)):
    provas = db.query(Prova).all()
    return provas

@router.post("/")
def criar_prova(db: Session = Depends(get_db)):
    nova = Prova(observacoes="Prova teste", idProfessor=1, idTurma=1, idMateria=1)
    db.add(nova)
    db.commit()
    db.refresh(nova)
    return {"mensagem": "Prova criada", "idProva": nova.idProva}