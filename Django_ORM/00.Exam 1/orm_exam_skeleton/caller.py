import os
import django
from django.db.models import Q, Count, Avg, Max, F

# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()
from main_app.models import Director, Actor, Movie
from main_app.managers import DirectorManager

# Import your models here
# Create and run your queries within functions
# print(Director.objects.get_directors_by_movies_count())



from django.db.models import Q

from django.db.models import Q

def get_directors(search_name=None, search_nationality=None):
    query = Q()

    if search_name:
        query &= Q(full_name__icontains=search_name)
    if search_nationality:
        query &= Q(nationality__icontains=search_nationality)

    directors = Director.objects.filter(query).order_by('full_name')

    if not directors.exists():
        return ''

    director_info = [
        f"Director: {d.full_name}, nationality: {d.nationality}, experience: {d.years_of_experience}"
        for d in directors
    ]
    return '\n'.join(director_info)

def get_top_director():
    top_director = DirectorManager.get_directors_by_movies_count(Director.objects).first()
    # top_director = Director.objects.annotate(movie_count=Count('movie')).order_by('-movie_count', 'full_name').first()

    if top_director:
        return f"Top Director: {top_director.full_name}, movies: {top_director.movie_count}."

    return ''




def get_top_actor():
    top_actor = Actor.objects.annotate(movie_count=Count('movies')).order_by('-movie_count', 'full_name').first()


    if top_actor is None or top_actor.movie_count == 0:
        return ''

    movies = top_actor.movies.all()
    average_rating = movies.aggregate(Avg('rating'))['rating__avg']

    movie_titles = ', '.join(movie.title for movie in movies)
    formatted_result = f"Top Actor: {top_actor.full_name}, starring in movies: {movie_titles}, movies average rating: {average_rating:.1f}"

    return formatted_result

def get_actors_by_movies_count():
    top_actors = Actor.objects.prefetch_related('movies__starring_actor').annotate(movie_count=Count('movies')).order_by('-movie_count', 'full_name')[:3]

    res = []
    for r in top_actors:
        count = r.movies.count()
        res.append(f"{r.full_name}, participated in {count} movies")
    return '\n'.join(res)

def get_top_rated_awarded_movie():

    the_movie = Movie.objects.filter(is_awarded=True).order_by('-rating','title').first()

    if the_movie:

        starring_actor = the_movie.starring_actor.full_name if the_movie.starring_actor else 'N/A'
        other_actors = ', '.join(actor.full_name for actor in the_movie.actors.all()) if the_movie.actors.exists() else 'N/A'

        result = (
            f"Top-rated awarded movie: {the_movie.title}, "
            f"rating: {the_movie.rating}. Starring actor: {starring_actor}. Cast: {other_actors}."
        )
    else:
        result = ''

    return result

def increase_rating():
    value = F('rating')+0.1
    movies = Movie.objects.filter(Q(rating__lt=10.0)& Q(is_classic=True)).update(rating=value)
    if not movies:
        return "No ratings increased."

    return f"Rating increased for {movies} movies."
print(increase_rating())
print(get_top_rated_awarded_movie())

