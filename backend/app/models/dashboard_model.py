from sqlalchemy import Column, Integer, Float, ForeignKey
from app.db import Base

class Dashboard(Base):
    __tablename__ = "Dashboard"
    
    idDashboard = Column(Integer, primary_key=True, index=True)
    idProva = Column(Integer, ForeignKey("Prova.idProva"))
    media = Column(Float)