from fastapi import APIRouter, Depends, HTTPException, Form
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.turma_model import Turma
from app.models.curso_model import Curso
from app.services.auth_service import verificar_token
from app.schemas.turma_schema import TurmaBase, TurmaResponse

router = APIRouter(prefix="/admin/turmas", tags=["Admin - Turmas"])

@router.get("/", response_model=list[TurmaResponse])
def listar_turmas(db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    return db.query(Turma).all()

@router.post("/", response_model=TurmaResponse)
def criar_turma(
    turma: str = Form(...),
    periodo: int = Form(...),
    idCurso: int = Form(...),
    db: Session = Depends(get_db),
    usuario=Depends(verificar_token)
):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    curso = db.query(Curso).filter_by(idCurso=idCurso).first()
    if not curso:
        raise HTTPException(status_code=404, detail="Curso não encontrado")
    nova = Turma(turma=turma, periodo=periodo, idCurso=idCurso)
    db.add(nova)
    db.commit()
    db.refresh(nova)
    return nova

@router.put("/{id_turma}")
def atualizar_turma(
    id_turma: int,
    turma: str = Form(...),
    periodo: int = Form(...),
    idCurso: int = Form(...),
    db: Session = Depends(get_db),
    usuario=Depends(verificar_token)
):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    t = db.query(Turma).filter_by(idTurma=id_turma).first()
    if not t:
        raise HTTPException(status_code=404, detail="Turma não encontrada")
    t.turma = turma
    t.periodo = periodo
    t.idCurso = idCurso
    db.commit()
    db.refresh(t)
    return t

@router.delete("/{id_turma}")
def deletar_turma(id_turma: int, db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    t = db.query(Turma).filter_by(idTurma=id_turma).first()
    if not t:
        raise HTTPException(status_code=404, detail="Turma não encontrada")
    db.delete(t)
    db.commit()
    return {"msg": f"Turma {id_turma} excluída"}