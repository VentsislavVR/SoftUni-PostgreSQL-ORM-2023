from django.core.validators import MinLengthValidator, MinValueValidator, MaxValueValidator, MaxLengthValidator
from django.db import models

from main_app.managers import DirectorManager
from main_app.mixins import Person, TimestampModel, Awarded


class Director(Person):
    years_of_experience = models.SmallIntegerField(
        default=0,
        validators=[MinValueValidator(0)]
    )
    objects = DirectorManager()

    def __str__(self):
        return f'Director: {self.full_name}'


class Actor(Person, Awarded, TimestampModel):

    def __str__(self):
        return f'Actor: {self.full_name}'


class Movie(Awarded, TimestampModel):
    class GenreChoices(models.TextChoices):
        ACTION = 'Action'
        COMEDY = 'Comedy'
        DRAMA = 'Drama'
        OTHER = 'Other'

    title = models.CharField(
        max_length=150,
        validators=[
            MinLengthValidator(5),
            MaxLengthValidator(150)
        ]
    )
    release_date = models.DateField(
    )
    storyline = models.TextField(
        null=True,
        blank=True,
    )
    genre = models.CharField(
        max_length=6,
        choices=GenreChoices.choices, default=GenreChoices.OTHER
    )
    rating = models.DecimalField(
        max_digits=3,
        decimal_places=1,
        default=0,
        validators=[MinValueValidator(0.0),
                    MaxValueValidator(10.0), ]
    )
    is_classic = models.BooleanField(default=False)

    director = models.ForeignKey(
        Director,
        on_delete=models.CASCADE,
        related_name='movies'
    )
    starring_actor = models.ForeignKey(
        Actor, blank=True, null=True,
        on_delete=models.SET_NULL,
        related_name='movies'
    )
    actors = models.ManyToManyField(
        Actor,
    )

    def __str__(self):
        return f'Movie: {self.title}'
