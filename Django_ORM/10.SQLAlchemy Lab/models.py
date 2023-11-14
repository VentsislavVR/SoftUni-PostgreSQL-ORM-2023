from sqlalchemy import Column, Integer, String,create_engine
from sqlalchemy.orm import declarative_base

from settings import DATABASE_URL

engine = create_engine(DATABASE_URL)

Base = declarative_base()
class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    username = Column(String)
    email = Column(String)

Base.metadata.create_all(engine)