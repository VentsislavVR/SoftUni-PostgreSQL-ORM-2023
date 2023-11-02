import os
from datetime import date, timedelta
from typing import List

import django
from django.db.models import Sum, Count, QuerySet

# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()

from main_app.models import Author, Book, Artist, Song, Product, Review, Driver, DrivingLicense, Car, Registration, \
    Owner


def show_all_authors_with_their_books():
    authors_with_books = []

    authors = Author.objects.all().order_by('id')  # not the fastest way

    for author in authors:
        books = Book.objects.filter(author=author)
        # books = author.book_set.all()
        if not books:
            continue
        titles = ', '.join(book.title for book in books)
        authors_with_books.append(f"{author.name} has written - {titles}!")

    return '\n'.join(authors_with_books)


def delete_all_authors_without_books() -> None:
    Author.objects.filter(book__isnull=True).delete()


# author1 = Author.objects.create(name="J.K. Rowling")
# author2 = Author.objects.create(name="George Orwell")
# author3 = Author.objects.create(name="Harper Lee")
# author4 = Author.objects.create(name="Mark Twain")
#
# book1 = Book.objects.create(
#     title="Harry Potter and the Philosopher's Stone",
#     price=19.99,
#     author=author1
# )
# book2 = Book.objects.create(
#     title="1984",
#     price=14.99,
#     author=author2
# )
#
# book3 = Book.objects.create(
#     title="To Kill a Mockingbird",
#     price=12.99,
#     author=author3
# )
# Display authors and their books
# authors_with_books = show_all_authors_with_their_books()
# print(authors_with_books)
#
# # Delete authors without books
# delete_all_authors_without_books()
# print(Author.objects.count())
def add_song_to_artist(artist_name: str, song_title: str) -> None:
    arist = Artist.objects.get(name=artist_name)
    song = Song.objects.get(title=song_title)

    arist.songs.add(song)


def get_songs_by_artist(artist_name: str):
    artist = Artist.objects.get(name=artist_name)

    return artist.songs.all().order_by('-id')


def remove_song_from_artist(artist_name: str, song_title: str):
    artist = Artist.objects.get(name=artist_name)
    song = Song.objects.get(title=song_title)

    artist.songs.remove(song)


def calculate_average_rating_for_product_by_name(product_name: str) -> float:
    # SLOW WAY ACHIEVED WITH 2 QUERIES
    product = Product.objects.get(name=product_name)
    reviews = product.reviews.all()

    total_ratings = sum(r.rating for r in reviews)
    average_rating = total_ratings / len(reviews)

    return average_rating

    # OPTIMIZED WAY ACHIEVED WITH 1 QUERY
    # product = Product.objects.annotate(
    #     total_rating=Sum('review__rating'),
    #     num_reviews=Count('review')
    # ).get(name=product_name)
    #
    # average_rating = product.total_rating / product.num_reviews
    # return average_rating


def get_reviews_with_high_ratings(threshold: int) -> QuerySet[Review]:
    return Review.objects.filter(rating__gte=threshold)


def get_products_with_no_reviews() -> QuerySet[Product]:
    return Product.objects.filter(reviews__isnull=True).order_by('-name')


def delete_products_without_reviews() -> None:
    Product.objects.filter(reviews__isnull=True).delete()


def calculate_licenses_expiration_dates() -> str:
    licences = DrivingLicense.objects.order_by('-license_number')

    return '\n'.join(str(l) for l in licences)


def get_drivers_with_expired_licenses(due_date: date) -> List[Driver]:
    expiration_cut_off_date = due_date - timedelta(days=365)
    expired_drivers = Driver.objects.filter(drivinglicense__issue_date__gte=expiration_cut_off_date)
    return list(expired_drivers)


def register_car_by_owner(owner: Owner):
    registration = Registration.objects.filter(car__isnull=True).first()
    car = Car.objects.filter(registration__isnull=True).first()

    car.owner = owner
    car.registration = registration
    car.save()

    registration.registration_date = date.today()
    registration.car = car

    registration.save()

    return f"Successfully registered {car.model} to {owner.name} with registration number {registration.registration_number}."
