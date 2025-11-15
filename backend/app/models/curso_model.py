from sqlalchemy import Column, Integer, String
from app.db import Base

class Curso(Base):
    __tablename__ = "Curso"

    idCurso = Column(Integer, primary_key=True, index=True)
    nome = Column(String(25), nullable=False)