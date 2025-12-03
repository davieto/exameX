<<<<<<< HEAD
from fastapi import APIRouter, Depends, HTTPException
=======
from fastapi import APIRouter, Depends
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.prova_model import Prova
from app.schemas.prova_schema import ProvaCreate, ProvaUpdate, ProvaResponse
from app.models.prova_questao_objetiva_model import ProvaQuestaoObjetiva
from app.models.questao_objetiva_model import QuestaoObjetiva

router = APIRouter(prefix="/provas", tags=["Provas"])

<<<<<<< HEAD
# === LISTAR TODAS ===
=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
@router.get("/", response_model=list[ProvaResponse])
def listar_provas(db: Session = Depends(get_db)):
    return db.query(Prova).all()

<<<<<<< HEAD
# === OBTER ESPECÍFICA ===
=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
@router.get("/{id_prova}", response_model=ProvaResponse)
def obter_prova(id_prova: int, db: Session = Depends(get_db)):
    prova = db.query(Prova).filter(Prova.idProva == id_prova).first()
    if not prova:
<<<<<<< HEAD
        raise HTTPException(status_code=404, detail="Prova não encontrada")
    return prova

# === CRIAR NOVA PROVA ===
=======
        return {"erro": "Prova não encontrada"}
    return prova

>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
@router.post("/", response_model=ProvaResponse)
def criar_prova(prova_in: ProvaCreate, db: Session = Depends(get_db)):
    prova = Prova(**prova_in.dict())
    db.add(prova)
    db.commit()
    db.refresh(prova)
    return prova

<<<<<<< HEAD
# === ATUALIZAR PROVA ===
=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
@router.put("/{id_prova}")
def atualizar_prova(id_prova: int, dados: ProvaUpdate, db: Session = Depends(get_db)):
    prova = db.query(Prova).filter(Prova.idProva == id_prova).first()
    if not prova:
<<<<<<< HEAD
        raise HTTPException(status_code=404, detail="Prova não encontrada")
    for campo, valor in dados.dict(exclude_unset=True).items():
        setattr(prova, campo, valor)
    db.commit()
    db.refresh(prova)
    return {"msg": "Prova atualizada com sucesso"}

# === DELETAR PROVA ===
=======
        return {"erro": "Prova não encontrada"}
    for campo, valor in dados.dict(exclude_unset=True).items():
        setattr(prova, campo, valor)
    db.commit()
    return {"msg": "Prova atualizada com sucesso"}

>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
@router.delete("/{id_prova}")
def deletar_prova(id_prova: int, db: Session = Depends(get_db)):
    prova = db.query(Prova).filter(Prova.idProva == id_prova).first()
    if not prova:
<<<<<<< HEAD
        raise HTTPException(status_code=404, detail="Prova não encontrada")
=======
        return {"erro": "Prova não encontrada"}
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
    db.delete(prova)
    db.commit()
    return {"msg": "Prova excluída com sucesso"}

<<<<<<< HEAD
# === ADICIONAR QUESTÕES À PROVA ===
=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
@router.post("/{id_prova}/add-questoes")
def adicionar_questoes(id_prova: int, ids_questoes: list[int], db: Session = Depends(get_db)):
    prova = db.query(Prova).filter(Prova.idProva == id_prova).first()
    if not prova:
<<<<<<< HEAD
        raise HTTPException(status_code=404, detail="Prova não encontrada")
    for ordem, id_q in enumerate(ids_questoes):
        existe = db.query(ProvaQuestaoObjetiva).filter_by(
            idProva=id_prova, idQuestaoObjetiva=id_q
        ).first()
        if not existe:
            db.add(ProvaQuestaoObjetiva(idProva=id_prova, idQuestaoObjetiva=id_q, ordem=ordem))
    db.commit()
    return {"msg": "Questões adicionadas à prova"}

# === LISTAR QUESTÕES DE UMA PROVA ===
@router.get("/{id_prova}/questoes")
def listar_questoes_da_prova(id_prova: int, db: Session = Depends(get_db)):
    ids = db.query(ProvaQuestaoObjetiva.idQuestaoObjetiva).filter_by(idProva=id_prova)
    questoes = db.query(QuestaoObjetiva).filter(
        QuestaoObjetiva.idQuestaoObjetiva.in_(ids)
    ).all()
    return [
        {
            "idQuestaoObjetiva": q.idQuestaoObjetiva,
            "titulo": q.titulo,
            "alternativas": [
                {"texto": a.texto, "afirmativa": a.afirmativa} for a in q.alternativas
            ],
        }
        for q in questoes
    ]

# === REORDENAR QUESTÕES ===
@router.put("/{id_prova}/ordenar")
def reordenar_questoes(id_prova: int, ids_ordenados: list[int], db: Session = Depends(get_db)):
    for ordem, questao_id in enumerate(ids_ordenados):
        vinculo = db.query(ProvaQuestaoObjetiva).filter_by(
            idProva=id_prova, idQuestaoObjetiva=questao_id
        ).first()
        if vinculo:
            vinculo.ordem = ordem
    db.commit()
    return {"msg": "Ordem das questões atualizada com sucesso"}

# === REMOVER QUESTÃO DA PROVA ===
@router.delete("/{id_prova}/remover-questao/{id_questao}")
def remover_questao_da_prova(id_prova: int, id_questao: int, db: Session = Depends(get_db)):
    vinculo = db.query(ProvaQuestaoObjetiva).filter_by(
        idProva=id_prova, idQuestaoObjetiva=id_questao
    ).first()
    if not vinculo:
        raise HTTPException(status_code=404, detail="Questão não vinculada à prova")
    db.delete(vinculo)
    db.commit()
    return {"msg": "Questão removida da prova"}
=======
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
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
