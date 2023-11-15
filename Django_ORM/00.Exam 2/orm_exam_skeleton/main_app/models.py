from django.db import models
from django.core.validators import MinLengthValidator, MinValueValidator

from main_app.managers import CustomProfileManager
from main_app.mixins import TimeStamp


class Profile(TimeStamp, models.Model):
    full_name = models.CharField(max_length=100,
     validators=[MinLengthValidator(2),])
    email = models.EmailField()
    phone_number = models.CharField(max_length=15)
    address = models.TextField()
    is_active = models.BooleanField(default=True)

    objects = CustomProfileManager()
    def __str__(self):
        return self.full_name


class Product(TimeStamp, models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0.01)])
    in_stock = models.PositiveIntegerField(
    validators=[MinValueValidator(0.01)])
    is_available = models.BooleanField(default=True)

    def __str__(self):
        return self.name


class Order(TimeStamp, models.Model):
    profile = models.ForeignKey(Profile, on_delete=models.CASCADE,related_name='orders') # related name orrders
    products = models.ManyToManyField(Product,related_name='orders')
    total_price = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0.01)])

    is_completed = models.BooleanField(default=False)


    def __str__(self):
        return f"Order #{self.id} - Total Price: {self.total_price} - Completed: {self.is_completed}"
