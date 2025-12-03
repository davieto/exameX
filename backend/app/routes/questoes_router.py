from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException
from sqlalchemy.orm import Session
from typing import List
import json
from io import BytesIO

from app.db import get_db
from app.models.questao_objetiva_model import QuestaoObjetiva
from app.models.alternativa_model import Alternativa
from app.schemas.questao_schema import QuestaoResponse
from app.services.import_service import importar_questoes_excel

router = APIRouter(prefix="/questoes", tags=["Questões"])

# === LISTAR ===
@router.get("/objetivas/", response_model=List[QuestaoResponse])
def listar_questoes_objetivas(db: Session = Depends(get_db)):
    """Lista todas as questões objetivas cadastradas."""
    return db.query(QuestaoObjetiva).all()

# === CRIAR ===
@router.post("/objetivas/", response_model=QuestaoResponse)
async def criar_questao_objetiva(
    titulo: str = Form(...),
    idDificuldade: int = Form(...),
    idProfessor: int = Form(...),
    alternativas: str = Form(...),
    imagem: UploadFile | None = File(default=None),
    db: Session = Depends(get_db),
):
    """Cria uma nova questão objetiva manualmente (rota pública)."""
    img_bytes = None
    if imagem:
        img_bytes = await imagem.read()

    q = QuestaoObjetiva(
        titulo=titulo,
        idDificuldade=idDificuldade,
        idProfessor=idProfessor,
        imagem=img_bytes
    )
    db.add(q)
    db.flush()

    # Valida as alternativas
    alt_list = json.loads(alternativas)
    if len(alt_list) != 5:
        raise HTTPException(status_code=400, detail="Cada questão deve conter exatamente 5 alternativas.")
    corretas = [a for a in alt_list if a.get("afirmativa") == 1]
    if len(corretas) != 1:
        raise HTTPException(status_code=400, detail="Deve haver exatamente uma alternativa correta.")

    for alt in alt_list:
        db.add(Alternativa(
            idQuestaoObjetiva=q.idQuestaoObjetiva,
            texto=alt["texto"],
            afirmativa=alt["afirmativa"]
        ))

    db.commit()
    db.refresh(q)
    return q

# === ATUALIZAR ===
@router.put("/objetivas/{id}")
async def atualizar_questao_objetiva(
    id: int,
    titulo: str = Form(...),
    idDificuldade: int = Form(...),
    imagem: UploadFile | None = File(default=None),
    db: Session = Depends(get_db),
):
    questao = db.query(QuestaoObjetiva).filter_by(idQuestaoObjetiva=id).first()
    if not questao:
        raise HTTPException(status_code=404, detail="Questão não encontrada")

    questao.titulo = titulo
    questao.idDificuldade = idDificuldade
    if imagem:
        questao.imagem = await imagem.read()

    db.commit()
    db.refresh(questao)
    return {"msg": "Questão atualizada com sucesso"}

# === DELETAR ===
@router.delete("/objetivas/{id}")
def deletar_questao_objetiva(id: int, db: Session = Depends(get_db)):
    questao = db.query(QuestaoObjetiva).filter_by(idQuestaoObjetiva=id).first()
    if not questao:
        raise HTTPException(status_code=404, detail="Questão não encontrada")

    db.delete(questao)
    db.commit()
    return {"msg": "Questão removida com sucesso"}

# === IMPORTAR PLANILHA DE QUESTÕES ===
@router.post("/importar")
async def importar_questoes(
    arquivo: UploadFile = File(...),
    idDificuldade: int = Form(1),
    db: Session = Depends(get_db),
):
    """
    Importa questões a partir de arquivo CSV/XLSX.
    Colunas mínimas: Questão | A | B | C | D | E | Resposta
    """
    conteudo = BytesIO(await arquivo.read())
    conteudo.filename = arquivo.filename

    total = importar_questoes_excel(
        conteudo,
        db,
        id_professor=None,
        id_dificuldade_padrao=idDificuldade
    )
    return {"msg": f"{total} questões importadas com sucesso."}