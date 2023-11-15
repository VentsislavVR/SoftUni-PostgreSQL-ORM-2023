from sqlalchemy import Column, Integer, String, create_engine, Boolean, ForeignKey
from sqlalchemy.orm import declarative_base, relationship

from settings import DATABASE_URL

engine = create_engine(DATABASE_URL)

Base = declarative_base()
class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    username = Column(String)
    email = Column(String)

# Base.metadata.create_all(engine)

class Order(Base):
    __tablename__ = 'orders'
    id = Column(Integer, primary_key=True)
    is_completed = Column(Boolean, default=False)
    user_id = Column(Integer, ForeignKey('users.id'))
    user = relationship('User')
