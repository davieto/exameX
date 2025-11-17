from sqlalchemy import Column, Integer, String
from app.db import Base

class Professor(Base):
    __tablename__ = "Professor"

    idProfessor = Column(Integer, primary_key=True, index=True)
    nome = Column(String(45))
    email = Column(String(45))
    senha = Column(String(45))