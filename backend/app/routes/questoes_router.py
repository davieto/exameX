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
from app.models.assunto_model import Assunto
from sqlalchemy.orm import joinedload

router = APIRouter(prefix="/questoes", tags=["Questões"])

# === LISTAR ===

@router.get("/objetivas/", response_model=List[QuestaoResponse])
def listar_questoes_objetivas(db: Session = Depends(get_db)):
    """Lista todas as questões objetivas com curso, matéria, alternativas e assuntos."""
    questoes = (
        db.query(QuestaoObjetiva)
        .options(
            joinedload(QuestaoObjetiva.curso),
            joinedload(QuestaoObjetiva.materia),
            joinedload(QuestaoObjetiva.alternativas),
            joinedload(QuestaoObjetiva.assuntos),
        )
        .all()
    )
    return questoes

# === CRIAR ===
@router.post("/objetivas/", response_model=QuestaoResponse)
async def criar_questao_objetiva(
    titulo: str = Form(...),
    idDificuldade: int = Form(...),
    idProfessor: int = Form(...),
    alternativas: str = Form(...),
    descricao: str | None = Form(None),
    texto: str | None = Form(None),
    tipo: str | None = Form('multipla'),
    acesso: str | None = Form('privada'),
    linhas_texto: int | None = Form(0),
    linhas_desenho: int | None = Form(0),
    idCurso: int | None = Form(None),
    idMateria: int | None = Form(None),
    assuntos: str | None = Form(None),
    imagem: UploadFile | None = File(default=None),
    db: Session = Depends(get_db),
):
    """Cria uma nova questão objetiva completa (com alternativas e assuntos)."""

    img_bytes = None
    if imagem:
        img_bytes = await imagem.read()

    # === Cria a questão principal ===
    nova_questao = QuestaoObjetiva(
        titulo=titulo,
        descricao=descricao,
        texto=texto,
        tipo=tipo,
        acesso=acesso,
        linhas_texto=linhas_texto,
        linhas_desenho=linhas_desenho,
        idCurso=idCurso,
        idMateria=idMateria,
        idDificuldade=idDificuldade,
        idProfessor=idProfessor,
        imagem=img_bytes,
    )

    db.add(nova_questao)
    db.flush()  # gera idQuestaoObjetiva antes de criar alternativas

    # === Validação e criação das alternativas ===
    try:
        alt_list = json.loads(alternativas)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Erro ao decodificar alternativas: {e}")

    if len(alt_list) != 5:
        raise HTTPException(status_code=400, detail="Cada questão deve conter exatamente 5 alternativas.")
    corretas = [a for a in alt_list if a.get("afirmativa") == 1]
    if len(corretas) != 1:
        raise HTTPException(status_code=400, detail="Deve haver exatamente uma alternativa correta.")

    for alt in alt_list:
        db.add(Alternativa(
            idQuestaoObjetiva=nova_questao.idQuestaoObjetiva,
            texto=alt["texto"],
            afirmativa=alt["afirmativa"]
        ))

    # === Criação dos assuntos (tags) ===
    if assuntos:
        try:
            lista_assuntos = json.loads(assuntos)
            for nome in lista_assuntos:
                db.add(Assunto(
                    idQuestaoObjetiva=nova_questao.idQuestaoObjetiva,
                    nome=nome if isinstance(nome, str) else str(nome)
                ))
        except Exception as e:
            print(f"Erro ao processar assuntos: {e}")

    db.commit()
    db.refresh(nova_questao)
    return nova_questao
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