import os
import django
from django.db.models import Q, Count, Avg, F

# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()

# Import your models here
# Create and run your queries within functions

from main_app.models import Director, Actor, Movie


def get_directors(search_name=None, search_nationality=None):
    if search_name is None and search_nationality is None:
        return ''
    query = Q()
    query_name = Q(full_name__icontains=search_name)
    query_nationality = Q(nationality__icontains=search_nationality)
    if search_name is not None and search_nationality is not None:
        query = query_name & query_nationality
    elif search_name is not None:
        query = query_name
    else:
        query = query_nationality

    director = Director.objects.filter(query).order_by('full_name')
    if not director:
        return ''
    result = []
    for d in director:
        result.append(f"Director: {d.full_name}, nationality: "
                      f"{d.nationality}, "
                      f"experience: {d.years_of_experience}")

    return '\n'.join(result)


def get_top_director():
    top = Director.objects.get_directors_by_movies_count().first()

    if not top:
        return ''
    return f'Top Director: {top.full_name}, movies: {top.num_movies}.'


def get_top_actor():
    actor = Actor.objects.prefetch_related('movies').annotate(
        num_movies=Count('movies'),
        avrage_movies_rating=Avg('movies__rating'),
    ).order_by('-num_movies', 'full_name').first()

    if not actor or not actor.num_movies:
        return ''
    movies = ', '.join([movie.title for movie in actor.movies.all()])
    # return (f'Top Actor: {actor.full_name},'
    #         f' starring in movies: {movies},'
    #         f' movies average rating: {actor.avrage_movies_rating:.1f}')
    return (f'Top Actor: {actor.full_name},'
            f' starring in movies: {movies}, '
            f'movies average rating: {actor.avrage_movies_rating:.1f}')


def get_actors_by_movies_count():

    actors = Actor.objects.annotate(
        num_movies=Count('movie')
    ).order_by('-num_movies','full_name')[:3]

    if not actors or actors[0].num_movies == 0:
        return ''
    res = []
    for actor in actors:
        res.append(f"{actor.full_name}, participated in {actor.num_movies} movies")
    return "\n".join(res)

def get_top_rated_awarded_movie():
    movie = (Movie.objects.select_related(
        'starring_actor'
    ).prefetch_related('actors'
    ).filter(
        is_awarded=True
    ).order_by('-rating','title'))

    if not movie:
        return ''