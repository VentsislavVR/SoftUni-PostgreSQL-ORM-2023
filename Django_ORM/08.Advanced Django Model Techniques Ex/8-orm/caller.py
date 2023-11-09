import os
import django
from django.contrib.postgres.search import SearchVector
from django.core.exceptions import ValidationError

# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()

# Import your models here
from main_app.models import Customer, Book, Document

# Create queries within functions
# customer = Customer(name="Svetlin Nakov1"
#                     ,age=1,email="nakov@example",
#                     phone_number="+35912345678"
#                     ,website_url="htsatps://nakov.com/")
#
# try:
#     customer.full_clean()
#     customer.save()
# except ValidationError as e:
#
#     print('\n'.join(e.messages))
# book = Book(title="Short Title",
#             description="A book with a short title.",
#             genre="Fiction",author="A",isbn="1234"
# )
#
# try:
#
#     book.full_clean()
#
#     book.save()
# except ValidationError as e:
#
#     print("Validation Error for Book:")
#
#     for field, errors in e.message_dict.items():
#
#         print(f"{field}: {', '.join(errors)}")


document1 = Document.objects.create(
    title="Django Framework 1",
    content="Django is a high-level Python web framework for building webapplications.",)


document2 = Document.objects.create(
    title="Django Framework 2",
    content="Django framework provides tools for creating web pages, handling URL"
            "routing, and more.",)

Document.objects.update(search_vector=SearchVector('title', 'content'))

results = Document.objects.filter(search_vector='django web framework')

for result in results:
    print(f"Title: {result.title}")