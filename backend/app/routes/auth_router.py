from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, Form
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app.db import get_db
from app.models.professor_model import Professor
from app.models.administrador_model import Administrador
from app.services.auth_service import (
    hash_senha,
    verificar_senha,
    criar_token_jwt,
)
from app.schemas.auth_schema import RegisterProfessorSchema

router = APIRouter(prefix="/auth", tags=["Auth"])


# === Teste rápido ===
@router.get("/ping")
def ping():
    return {"message": "auth router working!"}


# === Registrar Professor ===
@router.post("/register/professor")
def registrar_professor(dados: RegisterProfessorSchema, db: Session = Depends(get_db)):
    if db.query(Professor).filter_by(email=dados.email).first():
        raise HTTPException(status_code=400, detail="Email já cadastrado")

    novo = Professor(
        nome=dados.nome,
        email=dados.email,
        senha=hash_senha(dados.senha),
    )
    db.add(novo)
    db.commit()
    db.refresh(novo)
    return {"msg": f"Professor {novo.nome} cadastrado com sucesso"}


# === Registrar Administrador ===
@router.post("/register/admin")
def registrar_admin(email: str = Form(...), senha: str = Form(...), db: Session = Depends(get_db)):
    if db.query(Administrador).filter_by(email=email).first():
        raise HTTPException(status_code=400, detail="Email já cadastrado")
    novo = Administrador(email=email, senha=hash_senha(senha))
    db.add(novo)
    db.commit()
    return {"msg": "Administrador cadastrado"}


# === Login (compatível com o Swagger OAuth2, username/password) ===
@router.post("/login")
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db),
):
    """
    Endpoint compatível com o fluxo OAuth2PasswordBearer.
    O Swagger enviará automaticamente 'username' e 'password'.
    """

    email = form_data.username  # Swagger envia 'username'
    senha = form_data.password

    # Aqui você pode assumir o tipo automaticamente:
    # tenta encontrar primeiro como Professor, depois como Admin
    usuario = db.query(Professor).filter_by(email=email).first()
    tipo = "professor"

    if not usuario:
        usuario = db.query(Administrador).filter_by(email=email).first()
        tipo = "admin"

    if not usuario or not verificar_senha(senha, usuario.senha):
        raise HTTPException(status_code=401, detail="Credenciais inválidas")

    token = criar_token_jwt({"sub": email, "tipo": tipo}, timedelta(hours=3))
    return {
        "access_token": token,
        "token_type": "bearer",
        "user": tipo,
        "email": email,
    }