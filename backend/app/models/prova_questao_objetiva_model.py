from sqlalchemy import Column, Integer, ForeignKey
from app.db import Base

class ProvaQuestaoObjetiva(Base):
    __tablename__ = "ProvaQuestaoObjetiva"
<<<<<<< HEAD

    idProva = Column(Integer, ForeignKey("Prova.idProva"), primary_key=True)
    idQuestaoObjetiva = Column(Integer, ForeignKey("QuestaoObjetiva.idQuestaoObjetiva"), primary_key=True)
    ordem = Column(Integer, nullable=False, default=0)
=======
    idProva = Column(Integer, ForeignKey("Prova.idProva"), primary_key=True)
    idQuestaoObjetiva = Column(Integer, ForeignKey("QuestaoObjetiva.idQuestaoObjetiva"), primary_key=True)
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
