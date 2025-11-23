from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.mysql import LONGBLOB
from app.db import Base

class Prova(Base):
    __tablename__ = "Prova"

    idProva = Column(Integer, primary_key=True, index=True)
    titulo = Column(String(100))
    descricao = Column(String(255))
    observacoes = Column(String(500))
    pdf = Column(LONGBLOB)
    qrCode = Column(LONGBLOB)
    idProfessor = Column(Integer, ForeignKey("Professor.idProfessor"))
    idTurma = Column(Integer, ForeignKey("Turma.idTurma"))
    idMateria = Column(Integer, ForeignKey("Materia.idMateria"))

    professor = relationship("Professor")
    turma = relationship("Turma")
    materia = relationship("Materia")

    questoes_objetivas = relationship("ProvaQuestaoObjetiva", cascade="all, delete-orphan")
    questoes_dissertativas = relationship("ProvaQuestaoDissertativa", cascade="all, delete-orphan")