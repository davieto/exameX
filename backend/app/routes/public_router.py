from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.curso_model import Curso
from app.models.materia_model import Materia

router = APIRouter(prefix="/public", tags=["Público"])

@router.get("/cursos")
def listar_cursos_publicos(db: Session = Depends(get_db)):
    """Lista todos os cursos cadastrados (acesso público)."""
    return db.query(Curso).all()

@router.get("/materias")
def listar_materias_publicas(db: Session = Depends(get_db)):
    """Lista todas as matérias cadastradas (acesso público)."""
    return db.query(Materia).all()