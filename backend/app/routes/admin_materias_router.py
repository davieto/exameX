from fastapi import APIRouter, Depends, HTTPException, Form
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.materia_model import Materia
from app.services.auth_service import verificar_token
from app.schemas.materia_schema import MateriaBase, MateriaResponse

router = APIRouter(prefix="/admin/materias", tags=["Admin - Matérias"])

@router.get("/", response_model=list[MateriaResponse])
def listar_materias(db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    return db.query(Materia).all()

@router.post("/", response_model=MateriaResponse)
def criar_materia(nome: str = Form(...), db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    materia = Materia(nome=nome)
    db.add(materia)
    db.commit()
    db.refresh(materia)
    return materia

@router.put("/{id_materia}")
def atualizar_materia(id_materia: int, nome: str = Form(...), db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    materia = db.query(Materia).filter_by(idMateria=id_materia).first()
    if not materia:
        raise HTTPException(status_code=404, detail="Matéria não encontrada")
    materia.nome = nome
    db.commit()
    db.refresh(materia)
    return materia

@router.delete("/{id_materia}")
def deletar_materia(id_materia: int, db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    materia = db.query(Materia).filter_by(idMateria=id_materia).first()
    if not materia:
        raise HTTPException(status_code=404, detail="Matéria não encontrada")
    db.delete(materia)
    db.commit()
    return {"msg": f"Matéria {id_materia} removida"}