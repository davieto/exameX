from pydantic import BaseModel
from typing import List, Optional

class AlternativaBase(BaseModel):
    texto: str
    afirmativa: int

<<<<<<< HEAD
class AssuntoBase(BaseModel):
    nome: str
    
class CursoBase(BaseModel):
    idCurso: int
    nome: str

class MateriaBase(BaseModel):
    idMateria: int
    nome: str
=======
class QuestaoBase(BaseModel):
    titulo: str
    idDificuldade: int
    idProfessor: int
    alternativas: List[AlternativaBase]
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c

class QuestaoResponse(BaseModel):
    idQuestaoObjetiva: int
    titulo: str
<<<<<<< HEAD
    descricao: Optional[str]
    texto: Optional[str]
    tipo: Optional[str]
    acesso: Optional[str]
    linhas_texto: Optional[int]
    linhas_desenho: Optional[int]
    idCurso: Optional[int]
    idMateria: Optional[int]
    idDificuldade: int
    idProfessor: int
    curso: Optional[CursoBase] 
    materia: Optional[MateriaBase]
    alternativas: List[AlternativaBase]
    assuntos: Optional[List[AssuntoBase]]

    class Config:
        from_attributes = True
=======
    idDificuldade: int
    idProfessor: int
    alternativas: List[AlternativaBase]

    class Config:
        orm_mode = True
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
