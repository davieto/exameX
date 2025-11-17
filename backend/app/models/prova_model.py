from sqlalchemy import Column, Integer, String, ForeignKey, LargeBinary
from app.db import Base

class Prova(Base):
    __tablename__ = "Prova"

    idProva = Column(Integer, primary_key=True, index=True)
    observacoes = Column(String(500))
    pdf = Column(LargeBinary)
    qrCode = Column(LargeBinary)
    idProfessor = Column(Integer, ForeignKey("Professor.idProfessor"))
    idTurma = Column(Integer, ForeignKey("Turma.idTurma"))
    idMateria = Column(Integer, ForeignKey("Materia.idMateria"))