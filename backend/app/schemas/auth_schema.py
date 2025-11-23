from pydantic import BaseModel

class RegisterProfessorSchema(BaseModel):
    nome: str
    email: str
    senha: str