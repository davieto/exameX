<<<<<<< HEAD
=======
# prova_questao_dissertativa_model.py
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
from sqlalchemy import Column, Integer, ForeignKey
from app.db import Base

class ProvaQuestaoDissertativa(Base):
    __tablename__ = "ProvaQuestaoDissertativa"
    idProva = Column(Integer, ForeignKey("Prova.idProva"), primary_key=True)
    idQuestaoDissertativa = Column(Integer, ForeignKey("QuestaoDissertativa.idQuestaoDissertativa"), primary_key=True)