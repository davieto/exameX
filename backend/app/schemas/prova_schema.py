from pydantic import BaseModel
from typing import Optional

class ProvaBase(BaseModel):
    titulo: str
    descricao: Optional[str] = None
    observacoes: Optional[str] = None
    idProfessor: Optional[int] = None
    idTurma: Optional[int] = None
    idMateria: Optional[int] = None

class ProvaCreate(ProvaBase):
    pass

class ProvaUpdate(BaseModel):
    titulo: Optional[str] = None
    descricao: Optional[str] = None
    observacoes: Optional[str] = None

class ProvaResponse(ProvaBase):
    idProva: int
    class Config:
        orm_mode = True