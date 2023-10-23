import os
import django

# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()

# Import your models
from main_app.models import Shoe, UniqueBrands,Person

print(Shoe.objects.values_list('brand', flat=True).distinct())

print(Person.objects.all())


