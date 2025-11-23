from pydantic import BaseModel

class TurmaBase(BaseModel):
    turma: str
    periodo: int
    idCurso: int

class TurmaResponse(TurmaBase):
    idTurma: int
    class Config:
        orm_mode = True