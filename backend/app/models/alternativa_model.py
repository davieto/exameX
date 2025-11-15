from sqlalchemy import Column, Integer, String, ForeignKey, LargeBinary
from app.db import Base

class Alternativa(Base):
    __tablename__ = "Alternativa"
    
    idAlternativa = Column(Integer, primary_key=True, index=True)
    idQuestaoObjetiva = Column(Integer, ForeignKey("QuestaoObjetiva.idQuestaoObjetiva"))
    texto = Column(String(100))
    imagem = Column(LargeBinary)
    afirmativa = Column(Integer)