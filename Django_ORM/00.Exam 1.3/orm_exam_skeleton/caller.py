import os
import django
from django.db.models import Q, Count, Sum, Avg, Max, F

# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()

# Import your models here
# Create and run your queries within functions
from datetime import date
from django.utils import timezone
from main_app.models import Director, Actor, Movie
# Create Movies with Starring Actors

def get_directors(search_name=None, search_nationality=None):
    if search_name is None and search_nationality is None:
        return ''
    query = Q()
    if search_name and search_nationality:
        query &= Q(full_name__icontains=search_name) & Q(nationality__icontains=search_nationality)
    elif search_name:
        query &= Q(full_name__icontains=search_name)

    elif search_nationality:
        query &= Q(nationality__icontains=search_nationality)

    res = Director.objects.filter(query).order_by('full_name')



    return '\n'.join(f"Director: {d.full_name}, "
                f"nationality: { d.nationality}, "
                f"experience: {d.years_of_experience}"
                for d in res
                )
def get_top_director():
    top_g = Director.objects.get_directors_by_movies_count().first()
    if not top_g or top_g.movie_count == 0:
        return ''
    return f"Top Director: {top_g.full_name}, movies: {top_g.movie_count}."

def get_top_actor():
    top_actor = Actor.objects.annotate(
        num_movies=Count('starred_movies')
    ).annotate(
        avg_movies=Avg('starred_movies__rating')
    ).order_by('-num_movies','full_name').first()

    if top_actor is None or top_actor.num_movies == 0 or top_actor.avg_movies is None:
        return ''
    movies = [m.title for m in top_actor.starred_movies.all()]

    return (f"Top Actor:"
            f" {top_actor.full_name}, "
            f"starring in movies: {', '.join(movies)},"
            f" movies average rating: {top_actor.avg_movies:.1f}")



from django.db.models import Count

def get_actors_by_movies_count():
    if not Movie.objects.exists():
        return ''  # No movies exist, return empty string

    top_actors = Actor.objects.annotate(
        movie_count=Count('acted_in_movies')
    ).filter(movie_count__gt=0).order_by('-movie_count', 'full_name')[:3]

    if not top_actors:
        return ''  # No participating actors found, return empty string

    actors_info = '\n'.join(
        f"{actor.full_name}, participated in {actor.movie_count} movies"
        for actor in top_actors
    )

    return actors_info



def get_top_rated_awarded_movie():
    movie = Movie.objects.prefetch_related('starring_actor', 'actors').filter(is_awarded=True).annotate(
        highest_rating=Max('rating')
    ).order_by('-highest_rating', 'title').first()

    if not movie:
        return ''

    star_act = movie.starring_actor.full_name if movie.starring_actor else 'N/A'

    actors_names = ', '.join(
        x.full_name for x in movie.actors.all().order_by('full_name'))

    return (
        f"Top rated awarded movie: {movie.title}, "
        f"rating: {movie.highest_rating:.1f}. "
        f"Starring actor: {star_act}. "
        f"Cast: {actors_names}."
    )




def increase_rating():
    updates = (Movie.objects.filter(
        is_classic=True,rating__lt=10.0)
               .update(rating=F('rating')+0.1))
    if updates>0:
        return f"Rating increased for {updates} movies."
    return f"No ratings increased."

