from decimal import Decimal

from django.db import models
from django.db.models import Q, Count, Avg, QuerySet, Max, Min


class RealEstateListingManager(models.Manager):
    def by_property_type(self, property_type: str) -> QuerySet:
        return self.filter(property_type=property_type)

    def in_price_range(self, min_price: Decimal, max_price: Decimal) -> QuerySet:
        return self.filter(price__range=(min_price, max_price))
        # return self.filter(price__gte=min_price, price__lte=max_price)
        # return self.filter(Q(price__gte=min_price) & Q(price__lte=max_price))

    def with_bedrooms(self, bedrooms_count: int) -> QuerySet:
        return self.filter(bedrooms=bedrooms_count)

    def popular_locations(self) -> QuerySet:
        return self.values('location').annotate(
            location_count=Count('location')
        ).order_by('-location_count', 'id')[0:2]


# TODO
class VideoGameManager(models.Manager):
    def games_by_genre(self, genre: str) -> QuerySet:
        return self.filter(genre=genre)

    def recently_released_games(self, year: int) -> QuerySet:
        return self.filter(release_year__gte=year)

    def highest_rated_game(self):
        return self.annotate(max_rating=Max('rating')).order_by('-max_rating').first()
        # max_rating = self.aggregate(max_rating=models.Max('rating'))['max_rating']
        # highest_rated_game = self.filter(rating=max_rating).first()
        # return highest_rated_game

    def lowest_rated_game(self):
        # slower
        # min_rating = self.aggregate(min_rating=Min('rating'))['min_rating']
        # self.filter(rating=min_rating).first()

        # faster less queries
        return self.annotate(min_rating=Min('rating')).order_by('min_rating').first()


    def average_rating(self):
        # return self.annotate(avg=Avg('rating')).order_by('-avg')
        res = self.aggregate(average_rating=Avg('rating'))['average_rating']
        return round(res, 1)


