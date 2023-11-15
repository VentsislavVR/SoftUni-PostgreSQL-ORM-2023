from main import Session
from models import User

session = Session()

try:
    session.begin()

    session.query(User).delete()

    session.commit()

except Exception as e:
    session.rollback()
    print("Error" + str(e))
finally:
    print("Finally ")
    session.close()
