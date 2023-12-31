from django.core.validators import MinLengthValidator, MinValueValidator, MaxValueValidator
from django.db import models

from main_app.managers import DirectorCustomManager


# Create your models here.
class Director(models.Model):
    full_name = models.CharField(
        max_length=120,
        validators=[MinLengthValidator(2)]
    )
    birth_date = models.DateField(
        default='1900-01-01'
    )
    nationality = models.CharField(
        max_length=50,
        default='Unknown'
    )
    years_of_experience = models.SmallIntegerField(
        validators=[MinValueValidator(0)],
        default=0
    )
    objects = DirectorCustomManager()

    def __str__(self):
        return f"{self.full_name} ({self.nationality})"


class Actor(models.Model):
    full_name = models.CharField(
        max_length=120,
        validators=[MinLengthValidator(2)]
    )

    birth_date = models.DateField(
        default='1900-01-01',
    )
    nationality = models.CharField(
        max_length=50,
        default='Unknown'
    )
    is_awarded = models.BooleanField(
        default=False
    )
    last_updated = models.DateTimeField(
        auto_now=True,
    )

    def __str__(self):
        return self.full_name


class Movie(models.Model):
    GENRE_CHOICES = {
        ('Action', 'Action'),
        ('Comedy', 'Comedy'),
        ('Drama', 'Drama'),
        ('Other', 'Other')
    }
    title = models.CharField(
        max_length=150,
        validators=[MinLengthValidator(5)]
    )
    release_date = models.DateField()
    storyline = models.TextField(
        null=True,
        blank=True
    )
    genre = models.CharField(
        max_length=6,
        choices=GENRE_CHOICES,
        default='Other',
    )
    rating = models.DecimalField(
        max_digits=3,
        decimal_places=1,
        validators=[
            MinValueValidator(0.0),
            MaxValueValidator(10.0)],
        default=0.0,
    )
    is_classic = models.BooleanField(
        default=False,
    )
    is_awarded = models.BooleanField(
        default=False,
    )
    last_updated = models.DateTimeField(
        auto_now=True
    )
    director = models.ForeignKey(
        Director,
        on_delete=models.CASCADE,
        related_name='directed_movies'  # Movies directed by this director
    )

    starring_actor = models.ForeignKey(
        Actor,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='starred_movies'  # Movies where this actor is the main star
    )

    actors = models.ManyToManyField(
        Actor,
        related_name='acted_in_movies'  # Movies where any actor appears
    )

    def __str__(self):
        return f"{self.title} - {self.release_date}"




