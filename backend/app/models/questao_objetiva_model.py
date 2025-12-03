from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.mysql import LONGBLOB
from app.db import Base

class QuestaoObjetiva(Base):
    __tablename__ = "QuestaoObjetiva"

    idQuestaoObjetiva = Column(Integer, primary_key=True, index=True)
    idDificuldade = Column(Integer, ForeignKey("Dificuldade.idDificuldade"))
    idProfessor = Column(Integer, ForeignKey("Professor.idProfessor"))
    idCurso = Column(Integer, ForeignKey("Curso.idCurso"), nullable=True)
    idMateria = Column(Integer, ForeignKey("Materia.idMateria"), nullable=True)

    titulo = Column(String(500))
    descricao = Column(String(500), nullable=True)
    texto = Column(String(2000), nullable=True)

    tipo = Column(String(45), default="multipla")
    acesso = Column(String(45), default="privada")

    linhas_texto = Column(Integer, default=0)
    linhas_desenho = Column(Integer, default=0)

    imagem = Column(LONGBLOB, nullable=True)

    curso = relationship("Curso")
    materia = relationship("Materia")
    alternativas = relationship("Alternativa", back_populates="questao", cascade="all, delete-orphan")
    assuntos = relationship("Assunto", back_populates="questao", cascade="all, delete-orphan")