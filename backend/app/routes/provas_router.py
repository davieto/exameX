from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.prova_model import Prova
from app.schemas.prova_schema import ProvaCreate, ProvaUpdate, ProvaResponse
from app.models.prova_questao_objetiva_model import ProvaQuestaoObjetiva
from app.models.questao_objetiva_model import QuestaoObjetiva

router = APIRouter(prefix="/provas", tags=["Provas"])

@router.get("/", response_model=list[ProvaResponse])
def listar_provas(db: Session = Depends(get_db)):
    return db.query(Prova).all()

@router.get("/{id_prova}", response_model=ProvaResponse)
def obter_prova(id_prova: int, db: Session = Depends(get_db)):
    prova = db.query(Prova).filter(Prova.idProva == id_prova).first()
    if not prova:
        return {"erro": "Prova não encontrada"}
    return prova

@router.post("/", response_model=ProvaResponse)
def criar_prova(prova_in: ProvaCreate, db: Session = Depends(get_db)):
    prova = Prova(**prova_in.dict())
    db.add(prova)
    db.commit()
    db.refresh(prova)
    return prova

@router.put("/{id_prova}")
def atualizar_prova(id_prova: int, dados: ProvaUpdate, db: Session = Depends(get_db)):
    prova = db.query(Prova).filter(Prova.idProva == id_prova).first()
    if not prova:
        return {"erro": "Prova não encontrada"}
    for campo, valor in dados.dict(exclude_unset=True).items():
        setattr(prova, campo, valor)
    db.commit()
    return {"msg": "Prova atualizada com sucesso"}

@router.delete("/{id_prova}")
def deletar_prova(id_prova: int, db: Session = Depends(get_db)):
    prova = db.query(Prova).filter(Prova.idProva == id_prova).first()
    if not prova:
        return {"erro": "Prova não encontrada"}
    db.delete(prova)
    db.commit()
    return {"msg": "Prova excluída com sucesso"}

@router.post("/{id_prova}/add-questoes")
def adicionar_questoes(id_prova: int, ids_questoes: list[int], db: Session = Depends(get_db)):
    prova = db.query(Prova).filter(Prova.idProva == id_prova).first()
    if not prova:
        return {"erro": "Prova não encontrada"}

    for id_q in ids_questoes:
        existe = db.query(ProvaQuestaoObjetiva).filter_by(
            idProva=id_prova, idQuestaoObjetiva=id_q).first()
        if not existe:
            vinculo = ProvaQuestaoObjetiva(idProva=id_prova, idQuestaoObjetiva=id_q)
            db.add(vinculo)
    db.commit()
    return {"msg": "Questões adicionadas à prova"}

@router.get("/{id_prova}/questoes")
def listar_questoes_da_prova(id_prova: int, db: Session = Depends(get_db)):
    ids = db.query(ProvaQuestaoObjetiva.idQuestaoObjetiva).filter_by(idProva=id_prova)
    questoes = db.query(QuestaoObjetiva).filter(QuestaoObjetiva.idQuestaoObjetiva.in_(ids)).all()
    resultado = []
    for q in questoes:
        resultado.append({
            "id": q.idQuestaoObjetiva,
            "titulo": q.titulo,
            "alternativas": [{"texto": a.texto, "afirmativa": a.afirmativa} for a in q.alternativas]
        })
    return resultado