from sqlalchemy import Column, Integer, String, ForeignKey
from app.db import Base

class Materia(Base):
    __tablename__ = "Materia"

    idMateria = Column(Integer, primary_key=True, index=True)
<<<<<<< HEAD
    nome = Column(String(45), nullable=False)
    
=======
    nome = Column(String(45), nullable=False)
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
