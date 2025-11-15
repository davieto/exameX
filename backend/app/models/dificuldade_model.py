from sqlalchemy import Column, Integer, String, Float
from app.db import Base

class Dificuldade(Base):
    __tablename__ = "Dificuldade"

    idDificuldade = Column(Integer, primary_key=True, index=True)
    nota = Column(Float)
    dificuldade = Column(String(45))