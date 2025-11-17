from sqlalchemy import Column, Integer, String, ForeignKey, LargeBinary
from app.db import Base

class QuestaoDissertativa(Base):
    __tablename__ = "QuestaoDissertativa"
    
    idQuestaoDissertativa = Column(Integer, primary_key=True, index=True)
    idDificuldade = Column(Integer, ForeignKey("Dificuldade.idDificuldade"))
    titulo = Column(String(500))
    imagem = Column(LargeBinary)
    idProfessor = Column(Integer, ForeignKey("Professor.idProfessor"))