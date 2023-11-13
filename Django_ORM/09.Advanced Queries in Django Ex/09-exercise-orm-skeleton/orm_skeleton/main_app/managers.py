from decimal import Decimal

from django.db import models
from django.db.models import Q, Count, Max, Min, Avg, F


class CustomManager(models.Manager):
    def by_property_type(self, property_type: str):
        return self.filter(property_type=property_type)

    def in_price_range(self, min_price: Decimal, max_price: Decimal):
        return self.filter(Q(price__gte=min_price) & Q(price__lte=max_price))

    def with_bedrooms(self, bedrooms_count: int):
        return self.filter(bedrooms=bedrooms_count)

    def popular_locations(self):
        return self.values('location').annotate(Count('id')).order_by('id')[:2]


# TODO
class VideoGameManager(models.Manager):
    def games_by_genre(self, genre: str):
        return self.filter(genre=genre)

    def recently_released_games(self, year: int):
        return self.filter(release_year__gte=year)

    def highest_rated_game(self):
        max_rating = self.aggregate(max_rating=models.Max('rating'))['max_rating']
        highest_rated_game = self.filter(rating=max_rating).first()
        return highest_rated_game

    def lowest_rated_game(self):
        max_rating = self.aggregate(max_rating=models.Min('rating'))['max_rating']
        highest_rated_game = self.filter(rating=max_rating).first()
        return highest_rated_game

    def average_rating(self):
        # return self.annotate(avg=Avg('rating')).order_by('-avg')
        res = self.aggregate(avg=Avg('rating'))['avg']
        return round(res, 1)


class InvoiceManager(models.Manager):
    def get_invoices_with_prefix(self, prefix):
        return self.filter(invoice_number__contains=prefix)
