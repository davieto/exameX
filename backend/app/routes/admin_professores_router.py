from fastapi import APIRouter, Depends, HTTPException, Form
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.professor_model import Professor
from app.services.auth_service import verificar_token, hash_senha
from app.schemas.professor_schema import ProfessorBase, ProfessorResponse

router = APIRouter(prefix="/admin/professores", tags=["Admin - Professores"])

@router.get("/", response_model=list[ProfessorResponse])
def listar_professores(db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito a administradores")
    return db.query(Professor).all()

@router.get("/{id_professor}", response_model=ProfessorResponse)
def obter_professor(id_professor: int, db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    prof = db.query(Professor).filter_by(idProfessor=id_professor).first()
    if not prof:
        raise HTTPException(status_code=404, detail="Professor não encontrado")
    return prof

@router.post("/", response_model=ProfessorResponse)
def criar_professor(
    nome: str = Form(...),
    email: str = Form(...),
    senha: str = Form(...),
    db: Session = Depends(get_db),
    usuario=Depends(verificar_token)
):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    if db.query(Professor).filter_by(email=email).first():
        raise HTTPException(status_code=400, detail="Email já cadastrado")
    prof = Professor(nome=nome, email=email, senha=hash_senha(senha))
    db.add(prof)
    db.commit()
    db.refresh(prof)
    return prof

@router.put("/{id_professor}")
def atualizar_professor(
    id_professor: int,
    nome: str = Form(...),
    email: str = Form(...),
    db: Session = Depends(get_db),
    usuario=Depends(verificar_token)
):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    prof = db.query(Professor).filter_by(idProfessor=id_professor).first()
    if not prof:
        raise HTTPException(status_code=404, detail="Professor não encontrado")
    prof.nome = nome
    prof.email = email
    db.commit()
    db.refresh(prof)
    return prof

@router.delete("/{id_professor}")
def deletar_professor(id_professor: int, db: Session = Depends(get_db), usuario=Depends(verificar_token)):
    if usuario.tipo != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito")
    prof = db.query(Professor).filter_by(idProfessor=id_professor).first()
    if not prof:
        raise HTTPException(status_code=404, detail="Professor não encontrado")
    db.delete(prof)
    db.commit()
    return {"msg": f"Professor {id_professor} removido com sucesso"}