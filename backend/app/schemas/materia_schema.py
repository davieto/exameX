from pydantic import BaseModel

class MateriaBase(BaseModel):
    nome: str

class MateriaResponse(MateriaBase):
    idMateria: int
    class Config:
        orm_mode = True