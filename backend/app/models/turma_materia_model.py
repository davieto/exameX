from sqlalchemy import Column, Integer, ForeignKey
from app.db import Base

class TurmaMateria(Base):
    __tablename__ = "TurmaMateria"
    
    idTurma = Column(Integer, ForeignKey("Turma.idTurma"), primary_key=True)
    idMateria = Column(Integer, ForeignKey("Materia.idMateria"), primary_key=True)