from pydantic import BaseModel

class ProfessorBase(BaseModel):
    nome: str
    email: str

class ProfessorResponse(ProfessorBase):
    idProfessor: int
    class Config:
        orm_mode = True