from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from settings import DATABASE_URL
from models import User

engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
# CREATE
# with Session() as session:
#     new_user = User(username='john doe',
#                     email='john@example.com',)
#     session.add(new_user)
#     session.commit()
# SEARCH
# with Session() as session:
#     users =session.query(User).all()
#     for user in users:
#         print(user.username,user.email)

#UPDATE
# with Session() as session:
#     user_to_update = session.query(User).filter_by(username='john doe').first()
#
#     if user_to_update:
#         user_to_update.email = 'new@example.com'
#         session.commit()
#         print('Successfully updated')
#     else:
#         print('Failed to update/user not found')

# DELETE
# with Session() as session:
#     user_to_delete = session.query(User).filter_by(username='john doe').first()
#
#     if user_to_delete:
#         session.delete(user_to_delete)
#         session.commit()
#         print('Successfully deleted')
#     else:
#         print('Failed to delete user ')