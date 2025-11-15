from sqlalchemy import Column, Integer, ForeignKey
from app.db import Base

class ProfessorMateria(Base):
    __tablename__ = "ProfessorMateria"
    
    idProfessor = Column(Integer, ForeignKey("Professor.idProfessor"), primary_key=True)
    idMateria = Column(Integer, ForeignKey("Materia.idMateria"), primary_key=True)