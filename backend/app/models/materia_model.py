from sqlalchemy import Column, Integer, String, ForeignKey
from app.db import Base

class Materia(Base):
    __tablename__ = "Materia"

    idMateria = Column(Integer, primary_key=True, index=True)
    nome = Column(String(45), nullable=False)
    