import pandas as pd
from sqlalchemy.orm import Session
from app.models.questao_objetiva_model import QuestaoObjetiva
from app.models.alternativa_model import Alternativa


def importar_questoes_excel(
    arquivo,
    db: Session,
    id_professor: int,
    id_dificuldade_padrao: int = 1
):
    """
    Importa questões a partir de um arquivo Excel (.xlsx) ou CSV.

    Formatos aceitos:
        Questão | A | B | C | D | E | Resposta [| idDificuldade | idProfessor]

    - As colunas idDificuldade e idProfessor são opcionais.
    - Caso não existam, serão usados os valores padrão:
        * idDificuldade -> id_dificuldade_padrao ( parâmetro na rota )
        * idProfessor   -> id_professor (usuário logado pelo token)
    """

    # Detecta o tipo do arquivo (xlsx ou csv)
    df = pd.read_excel(arquivo) if arquivo.filename.endswith(".xlsx") else pd.read_csv(arquivo)

    criadas = 0

    # Colunas esperadas
    colunas_esperadas = ["Questão", "A", "B", "C", "D", "E", "Resposta"]
    for col in colunas_esperadas:
        if col not in df.columns:
            raise ValueError(f"Coluna obrigatória não encontrada: {col}")

    for _, linha in df.iterrows():
        enunciado = str(linha["Questão"]).strip() if pd.notna(linha["Questão"]) else ""
        if not enunciado:
            continue  # ignora linhas vazias

        # Extrai alternativas de A a E
        alternativas = [
            linha.get(col, "")
            if isinstance(linha.get(col), str)
            else str(linha.get(col) or "")
            for col in ["A", "B", "C", "D", "E"]
        ]

        resposta = str(linha.get("Resposta", "")).strip().upper()
        id_dif = int(linha.get("idDificuldade", id_dificuldade_padrao)) \
            if "idDificuldade" in df.columns and pd.notna(linha.get("idDificuldade")) \
            else id_dificuldade_padrao

        id_prof = int(linha.get("idProfessor", id_professor)) \
            if "idProfessor" in df.columns and pd.notna(linha.get("idProfessor")) \
            else id_professor

        # Cria questão
        questao = QuestaoObjetiva(
            titulo=enunciado,
            idDificuldade=id_dif,
            idProfessor=id_prof
        )
        db.add(questao)
        db.flush()  # gera o idQuestaoObjetiva

        # Cria as alternativas
        letras = ["A", "B", "C", "D", "E"]
        for letra, texto in zip(letras, alternativas):
            alt = Alternativa(
                idQuestaoObjetiva=questao.idQuestaoObjetiva,
                texto=texto.strip(),
                afirmativa=1 if letra == resposta else 0
            )
            db.add(alt)

        criadas += 1

    db.commit()
    return criadas