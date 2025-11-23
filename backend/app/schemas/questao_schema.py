from pydantic import BaseModel
from typing import List, Optional

class AlternativaBase(BaseModel):
    texto: str
    afirmativa: int

class QuestaoBase(BaseModel):
    titulo: str
    idDificuldade: int
    idProfessor: int
    alternativas: List[AlternativaBase]

class QuestaoResponse(BaseModel):
    idQuestaoObjetiva: int
    titulo: str
    idDificuldade: int
    idProfessor: int
    alternativas: List[AlternativaBase]

    class Config:
        orm_mode = True