from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.mysql import LONGBLOB 
from app.db import Base

class QuestaoObjetiva(Base):
    __tablename__ = "QuestaoObjetiva"

    idQuestaoObjetiva = Column(Integer, primary_key=True, index=True)
    idDificuldade = Column(Integer, ForeignKey("Dificuldade.idDificuldade"))
    idProfessor = Column(Integer, ForeignKey("Professor.idProfessor"))
    titulo = Column(String(500))
    imagem = Column(LONGBLOB, nullable=True)

    alternativas = relationship(
        "Alternativa",
        back_populates="questao",
        cascade="all, delete-orphan"
    )