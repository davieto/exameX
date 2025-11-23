from sqlalchemy import Column, Integer, String
from app.db import Base

class Administrador(Base):
    __tablename__ = "Administrador"

    idAdministrador = Column(Integer, primary_key=True, index=True)
    email = Column(String(45), unique=True)
    senha = Column(String(255))