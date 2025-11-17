from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

usuario = "root"
senha = "root"
host = "localhost"
banco = "examex"

SQLALCHEMY_DATABASE_URL = f"mysql+mysqlconnector://{usuario}:{senha}@{host}/{banco}"

engine = create_engine(SQLALCHEMY_DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()