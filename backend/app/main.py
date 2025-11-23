from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.db import Base, engine
from app.routes import (
    questoes_router,
    provas_router,
    pdf_router,
    qr_router,
    export_router,
    estatisticas_router,
    auth_router,
    admin_professores_router,
    admin_cursos_router,
    admin_materias_router,
    admin_turmas_router
)

# === Cria as tabelas no banco ao iniciar ===
Base.metadata.create_all(bind=engine)

app = FastAPI(title="ExameX API - FastAPI + MySQL")

# === Importa Models (para garantir que todos os metadados são carregados) ===
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
    dashboard_model,
)

# === Configuração de CORS ===
origins = [
    "*",  # em produção, restrinja aos domínios do app
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_methods=["*"],
    allow_headers=["*"],
)

# === Registro de todas as rotas ===
app.include_router(auth_router.router)
app.include_router(questoes_router.router)
app.include_router(provas_router.router)
app.include_router(pdf_router.router)
app.include_router(qr_router.router)
app.include_router(export_router.router)
app.include_router(estatisticas_router.router)

# === Rotas Administrativas (somente type = admin) ===
app.include_router(admin_professores_router.router)
app.include_router(admin_cursos_router.router)
app.include_router(admin_materias_router.router)
app.include_router(admin_turmas_router.router)


@app.get("/")
def home():
    return {"status": "ok", "mensagem": "🚀 Backend ExameX funcionando"}