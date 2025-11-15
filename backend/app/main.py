from fastapi import FastAPI
from app.db import Base, engine

# importe de todos os modelos para criaçao das tabelas
from app.models import (
    administrador_model,
    curso_model,
    turma_model,
    materia_model,
    professor_model,
    professor_materia_model,
    dificuldade_model,
    questao_dissertativa_model,
    questao_objetiva_model,
    alternativa_model,
    prova_model,
    prova_questao_dissertativa_model,
    prova_questao_objetiva_model,
    turma_materia_model,
    dashboard_model
)

app = FastAPI(title="Sistema de Provas - Banco Completo")

# criaçao das tabelas
Base.metadata.create_all(bind=engine)

@app.get("/")
def home():
    return {"mensagem": "Banco MySQL conectado e tabelas criadas!"}