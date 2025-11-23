from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException
from sqlalchemy.orm import Session
from typing import List
import json
from io import BytesIO

from app.db import get_db
from app.models.questao_objetiva_model import QuestaoObjetiva
from app.models.alternativa_model import Alternativa
from app.schemas.questao_schema import QuestaoBase, QuestaoResponse
from app.services.auth_service import verificar_token
from app.services.import_service import importar_questoes_excel

router = APIRouter(prefix="/questoes", tags=["Questões"])


# === LISTAR ===
@router.get("/objetivas/", response_model=List[QuestaoResponse])
def listar_questoes_objetivas(
    db: Session = Depends(get_db),
):
    """Lista todas as questões objetivas cadastradas."""
    questoes = db.query(QuestaoObjetiva).all()
    return questoes


# === CRIAR ===
@router.post("/objetivas/", response_model=QuestaoResponse)
async def criar_questao_objetiva(
    titulo: str = Form(...),
    idDificuldade: int = Form(...),
    idProfessor: int = Form(...),
    alternativas: str = Form(...),
    imagem: UploadFile | None = File(default=None),
    db: Session = Depends(get_db),
    usuario=Depends(verificar_token)
):
    """Cria uma nova questão objetiva manualmente."""
    img_bytes = None
    if imagem:
        img_bytes = await imagem.read()

    # Professor pode criar apenas em seu próprio nome, admin livre
    if usuario.tipo == "professor" and usuario.idProfessor != idProfessor:
        raise HTTPException(status_code=403, detail="Você só pode criar questões no seu próprio nome.")

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
        a = Alternativa(
            idQuestaoObjetiva=q.idQuestaoObjetiva,
            texto=alt["texto"],
            afirmativa=alt["afirmativa"]
        )
        db.add(a)

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
    usuario=Depends(verificar_token)
):
    """Atualiza os dados de uma questão existente."""
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
def deletar_questao_objetiva(
    id: int,
    db: Session = Depends(get_db),
    usuario=Depends(verificar_token)
):
    """Remove uma questão e suas alternativas."""
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
    usuario=Depends(verificar_token)
):
    """
    Importa questões a partir de uma planilha (XLSX ou CSV).

    Colunas mínimas: Questão | A | B | C | D | E | Resposta  
    Colunas opcionais: idDificuldade | idProfessor

    - Se não houver idProfessor e idDificuldade, usa o professor logado e o valor padrão.
    """
    if usuario.tipo not in ["professor", "admin"]:
        raise HTTPException(status_code=403, detail="Acesso restrito")

    conteudo = BytesIO(await arquivo.read())
    conteudo.filename = arquivo.filename

    total = importar_questoes_excel(
        conteudo,
        db,
        id_professor=getattr(usuario, "idProfessor", None),
        id_dificuldade_padrao=idDificuldade
    )

    return {"msg": f"{total} questões importadas com sucesso."}