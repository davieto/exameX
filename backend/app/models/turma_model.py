from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.db import Base

class Turma(Base):
    __tablename__ = "Turma"

    idTurma = Column(Integer, primary_key=True, index=True)
    idCurso = Column(Integer, ForeignKey("Curso.idCurso"))
    turma = Column(String(45))
    periodo = Column(Integer)

    curso = relationship("Curso")