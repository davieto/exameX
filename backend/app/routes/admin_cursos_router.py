from fastapi import APIRouter, Depends, HTTPException, Form
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.curso_model import Curso
from app.services.auth_service import verificar_token
from app.schemas.curso_schema import CursoBase, CursoResponse

router = APIRouter(prefix="/admin/cursos", tags=["Admin - Cursos"])

@router.get("/", response_model=list[CursoResponse])
def listar_cursos(db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    return db.query(Curso).all()

@router.get("/{id_curso}", response_model=CursoResponse)
def obter_curso(id_curso: int, db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    curso = db.query(Curso).filter_by(idCurso=id_curso).first()
    if not curso:
        raise HTTPException(status_code=404, detail="Curso não encontrado")
    return curso

@router.post("/", response_model=CursoResponse)
def criar_curso(nome: str = Form(...), db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    curso = Curso(nome=nome)
    db.add(curso)
    db.commit()
    db.refresh(curso)
    return curso

@router.put("/{id_curso}")
def atualizar_curso(
    id_curso: int,
    nome: str = Form(...),
    db: Session = Depends(get_db),
    usuario=Depends(verificar_token)
):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    curso = db.query(Curso).filter_by(idCurso=id_curso).first()
    if not curso:
        raise HTTPException(status_code=404, detail="Curso não encontrado")
    curso.nome = nome
    db.commit()
    db.refresh(curso)
    return curso

@router.delete("/{id_curso}")
def deletar_curso(id_curso: int, db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    curso = db.query(Curso).filter_by(idCurso=id_curso).first()
    if not curso:
        raise HTTPException(status_code=404, detail="Curso não encontrado")
    db.delete(curso)
    db.commit()
    return {"msg": f"Curso {id_curso} excluído com sucesso"}