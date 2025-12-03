from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.db import Base

class Assunto(Base):
    __tablename__ = "Assunto"

    idAssunto = Column(Integer, primary_key=True, index=True)
    idQuestaoObjetiva = Column(Integer, ForeignKey("QuestaoObjetiva.idQuestaoObjetiva"))
    nome = Column(String(200))

    questao = relationship("QuestaoObjetiva", back_populates="assuntos")