from fastapi import APIRouter, Depends, UploadFile, File, Form
from sqlalchemy.orm import Session
from typing import List
import json
from app.db  import get_db
from app.models.questao_objetiva_model import QuestaoObjetiva
from app.models.alternativa_model import Alternativa
from app.schemas.questao_schema import QuestaoBase, QuestaoResponse

router = APIRouter(prefix="/questoes", tags=["Questões"])

# === LISTAR ===
@router.get("/objetivas/", response_model=List[QuestaoResponse])
def listar_questoes_objetivas(db: Session = Depends(get_db)):
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
    db: Session = Depends(get_db)
):
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

    alt_list = json.loads(alternativas)
    if len(alt_list) != 5:
        raise ValueError("Cada questão deve conter exatamente 5 alternativas.")

    corretas = [a for a in alt_list if a.get("afirmativa") == 1]
    if len(corretas) != 1:
        raise ValueError("Deve haver exatamente uma alternativa correta.")

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
    db: Session = Depends(get_db)
):
    questao = db.query(QuestaoObjetiva).filter_by(idQuestaoObjetiva=id).first()
    if not questao:
        return {"erro": "Questão não encontrada"}

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
        return {"erro": "Questão não encontrada"}
    db.delete(questao)
    db.commit()
    return {"msg": "Questão removida"}