from sqlalchemy import Column, Integer, String, ForeignKey, LargeBinary
from sqlalchemy.orm import relationship
from app.db import Base

class Alternativa(Base):
    __tablename__ = "Alternativa"

    idAlternativa = Column(Integer, primary_key=True, index=True)
    idQuestaoObjetiva = Column(Integer, ForeignKey("QuestaoObjetiva.idQuestaoObjetiva"))
    texto = Column(String(200))
    imagem = Column(LargeBinary, nullable=True)
    afirmativa = Column(Integer, nullable=False, default=0)

    questao = relationship("QuestaoObjetiva", back_populates="alternativas")