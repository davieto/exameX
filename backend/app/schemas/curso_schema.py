from pydantic import BaseModel

class CursoBase(BaseModel):
    nome: str

class CursoResponse(CursoBase):
    idCurso: int
    class Config:
        orm_mode = True