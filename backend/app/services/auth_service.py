# app/services/auth_service.py
import os
import hashlib
from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import HTTPException, status, Depends
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.professor_model import Professor
from app.models.administrador_model import Administrador

# === Configurações ===
SECRET_KEY = os.getenv("JWT_SECRET", "examex_secret")  # Trocar em produção
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 3  # 3 horas

# Criptografia
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


# === Funções de HASH de senha ===
def _prehash(senha: str) -> str:
    """
    Converte qualquer senha em hash SHA256 antes de aplicar bcrypt.
    Garante compatibilidade mesmo para senhas longas.
    """
    if senha is None:
        raise ValueError("Senha não pode ser nula")
    senha = str(senha)
    return hashlib.sha256(senha.encode("utf-8")).hexdigest()


def hash_senha(senha: str) -> str:
    """Retorna o hash final armazenado no banco (SHA256 + bcrypt)."""
    prehashed = _prehash(senha)
    return pwd_context.hash(prehashed)


def verificar_senha(senha: str, senha_hash: str) -> bool:
    """Verifica se a senha informada corresponde ao hash armazenado."""
    prehashed = _prehash(senha)
    return pwd_context.verify(prehashed, senha_hash)


# === JWT ===
def criar_token_jwt(dados: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = dados.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


# === Autenticação e Autorizações ===
def verificar_token(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    cred_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Credenciais inválidas ou token expirado",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        tipo: str = payload.get("tipo")
        if email is None or tipo is None:
            raise cred_exception
    except JWTError:
        raise cred_exception

    usuario = None
    if tipo == "professor":
        usuario = db.query(Professor).filter_by(email=email).first()
    elif tipo == "admin":
        usuario = db.query(Administrador).filter_by(email=email).first()

    if usuario is None:
        raise cred_exception

    # Adiciona metadados úteis
    usuario.tipo = tipo
    usuario.nivel_acesso = "total" if tipo == "admin" else "restrito"

    return usuario