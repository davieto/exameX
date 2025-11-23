# prova_questao_dissertativa_model.py
from sqlalchemy import Column, Integer, ForeignKey
from app.db import Base

class ProvaQuestaoDissertativa(Base):
    __tablename__ = "ProvaQuestaoDissertativa"
    idProva = Column(Integer, ForeignKey("Prova.idProva"), primary_key=True)
    idQuestaoDissertativa = Column(Integer, ForeignKey("QuestaoDissertativa.idQuestaoDissertativa"), primary_key=True)