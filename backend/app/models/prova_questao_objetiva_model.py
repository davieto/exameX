from sqlalchemy import Column, Integer, ForeignKey
from app.db import Base

class ProvaQuestaoObjetiva(Base):
    __tablename__ = "ProvaQuestaoObjetiva"
    idProva = Column(Integer, ForeignKey("Prova.idProva"), primary_key=True)
    idQuestaoObjetiva = Column(Integer, ForeignKey("QuestaoObjetiva.idQuestaoObjetiva"), primary_key=True)