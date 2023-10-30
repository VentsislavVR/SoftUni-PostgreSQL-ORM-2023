import os
from typing import List

import django

# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()

# Import your models
from django.db.models import Case, When, Value, F, Q, QuerySet

from main_app.models import ArtworkGallery, ChessPlayer, Meal, Dungeon, Workout, Laptop


# First

def show_highest_rated_art() -> str:
    highest_rated_art = ArtworkGallery.objects.order_by('-rating', 'id').first()
    return f"{highest_rated_art.art_name} is the highest rated art with a {highest_rated_art.rating} rating!"


def bulk_create_arts(first_art, second_art) -> None:
    ArtworkGallery.objects.bulk_create([
        first_art,
        second_art
    ])


def delete_negative_rated_arts() -> None:
    ArtworkGallery.objects.filter(rating__lt=0).delete()


# Second

def show_most_expensive_laptop() -> str:
    most_expensive_laptop = Laptop.objects.order_by('-price', 'id').first()
    return f"{most_expensive_laptop.brand} is the most expensive laptop available for {most_expensive_laptop.price}$!"


# Todo fix none objects in list
def bulk_create_laptops(*laptops: List[Laptop]) -> None:
    Laptop.objects.bulk_create(*laptops)


def update_to_512_GB_storage():
    Laptop.objects.filter(Q(brand='Asus') | Q(brand='Lenovo')).update(storage=512)

    # Laptop.objects.filter(brand__in=['Asus', 'Lenovo']).update(storage=512)


def update_to_16_GB_memory():
    Laptop.objects.filter(brand__in=['Apple', 'Dell', 'Acer']).update(memory=16)


def update_operation_systems():
    Laptop.objects.update(
        operation_system=Case(
            When(brand='Asus', then=Value('Windows')),
            When(brand='Apple', then=Value('MacOS')),
            When(brand__in=['Dell', 'Acer'], then=Value('Linux')),
            When(brand='Lenovo', then=Value('Chrome OS')),
            default=F('operation_system')
        )
    )

    # Laptop.objects.filter(brand='Asus').update(operation_system='Windows')
    # Laptop.objects.filter(brand='Apple').update(operation_system='MacOS')
    # Laptop.objects.filter(brand__in=['Dell','Acer']).update(operation_system='Linux')
    # Laptop.objects.filter(brand='Lenovo').update(operation_system='Chrome OS')

    # SLOWEST SOLUTION
    # brand_to_os = {
    #     'Asus': 'Windows',
    #     'Apple': 'MacOS',
    #     'Dell': 'Linux',
    #     'Lenovo': 'Chrome OS',
    # }
    #
    # laptops = Laptop.objects.all()
    # for laptop in laptops:
    #     brand = laptop.brand
    #     if brand in brand_to_os:
    #         laptop.operation_system = brand_to_os[brand]
    #         laptop.save()


def delete_inexpensive_laptops() -> None:
    Laptop.objects.filter(price__lt=1200).delete()


# todo
# Third
def bulk_create_chess_players(*args: List[ChessPlayer]) -> None:
    ChessPlayer.objects.bulk_create(*args)


def delete_chess_players() -> None:
    # Abstract
    default_title = ChessPlayer._meta.get_field('title').default
    ChessPlayer.objects.filter(title=default_title).delete()

    # not abstract
    # ChessPlayer.objects.filter(title='no title').delete()


def change_chess_games_won() -> None:
    ChessPlayer.objects.filter(title='GM').update(games_won=30)


def change_chess_games_lost() -> None:
    ChessPlayer.objects.filter(title='no title').update(games_lost=25)


def change_chess_games_drawn() -> None:
    ChessPlayer.objects.update(games_drawn=10)


def grand_chess_title_GM() -> None:
    ChessPlayer.objects.filter(rating__gte=2400).update(title='GM')


def grand_chess_title_IM() -> None:
    # alternative
    # ChessPlayer.objects.filter(Q(rating__gte=2300) & Q(rating__lt=2400)).update(title='IM')
    ChessPlayer.objects.filter(rating__range=[2300, 2399]).update(title='IM')


def grand_chess_title_FM() -> None:
    ChessPlayer.objects.filter(rating__range=[2200, 2299]).update(title='FM')


def grand_chess_title_regular_player():
    ChessPlayer.objects.filter(rating__range=[0, 2199]).update(title='regular player')


# Fourth
def set_new_chefs()->None:
    Meal.objects.update(
        Case(
            When(meal_type='Breakfast', then=Value('Gordon Ramsay')),
            When(meal_type='Lunch', then=Value('Julia Child')),
            When(meal_type='Dinner', then=Value('Jamie Oliver')),
            When(meal_type='Snack', then=Value('Thomas Keller'))
            ,)
    )


def set_new_preparation_times():
    Meal.objects.update(Case(
        When(meal_type='Breakfast', then=Value('10 minutes')),
        When(meal_type='Lunch', then=Value('12 minutes')),
        When(meal_type='Dinner', then=Value('15 minutes')),
        When(meal_type='Snack', then=Value('5 minutes'))
        , )
    )



def update_low_calorie_meals():
    # Meal.objects.filter(meal_type__in=['Breakfast', 'Dinner']).update(calories=400)
    Meal.objects.filter(Q(meal_type='Breakfast') | Q(meal_type='Dinner')).update(calories=400)


def update_high_calorie_meals():
    Meal.objects.filter(Q(meal_type='Lunch') | Q(meal_type='Snack')).update(calories=700)
    # Meal.objects.filter(meal_type__in=['Lunch', 'Snack']).update(calories=700)


def delete_lunch_and_snack_meals()->None:
    Meal.objects.filter(Q(meal_type='Lunch') | Q(meal_type='Snack')).delete()
    # Meal.objects.filter(meal_type__in=['Lunch', 'Snack']).delete()


# Todo
# Fifth
def show_hard_dungeons()-> str:
    dungeons = Dungeon.objects.filter(difficulty='Hard').order_by('-location')
    return '\n'.join(str(x) for x in dungeons)


    # return '\n'.join(
    #     [f"{dungeon.name} is guarded by {dungeon.boss_name} who has {dungeon.boss_health} health points!" for dungeon in
    #      dungeons])

def bulk_create_dungeons(*dungeons)->None:
    Dungeon.objects.bulk_create(*dungeons)

def update_dungeon_names()->None:

    Dungeon.objects.filter(difficulty='Easy').update(name='The Erased Thombs')
    Dungeon.objects.filter(difficulty='Medium').update(name='The Coral Labyrinth')
    Dungeon.objects.filter(difficulty='Hard').update(name='The Lost Haunt')
    # Dungeon.objects.update(
    #     Case(
    #         When(difficulty='Easy', then=Value('The Erased Thombs')),
    #         When(difficulty='Medium', then=Value('The Coral Labyrinth')),
    #         When(difficulty='Hard', then=Value('The Lost Haunt')),),)

def update_dungeon_bosses_health()->None:
    Dungeon.objects.exclude(difficulty='Easy').update(boss_health=500)


def update_dungeon_recommended_levels()->None:
    # Dungeon.objects.update(
    #     Case(
    #   When(difficulty='Easy', then=Value(25)),
    #         When(difficulty='Medium', then=Value(50)),
    #         When(difficulty='Hard', then=Value(75))
    #         ,)
    #     ,)
    Dungeon.objects.filter(difficulty="Easy").update(recommended_level=25)
    Dungeon.objects.filter(difficulty="Medium").update(recommended_level=50)
    Dungeon.objects.filter(difficulty="Hard").update(recommended_level=75)


def update_dungeon_rewards()->None:
    # Dungeon.objects.filter(Case(
    #     When(boss_health=500, then=Value("1000 Gold")),
    #     When(location__startswith="E", then=Value("New dungeon unlocked")),
    #     When(location__endswith="s", then=Value("Dragonheart Amulet"))
    #     ,)
    # )
    Dungeon.objects.filter(boss_health=500).update(reward="1000 Gold")
    Dungeon.objects.filter(location__startswith="E").update(reward="New dungeon unlocked")
    Dungeon.objects.filter(location__endswith="s").update(reward="Dragonheart Amulet")


def set_new_locations()->None:
    Dungeon.objects.filter(recommended_level=25).update(location="Enchanted Maze")
    Dungeon.objects.filter(recommended_level=50).update(location="Grimstone Mines")
    Dungeon.objects.filter(recommended_level=75).update(location="Shadowed Abyss")


def show_workouts()->str:
    workout = Workout.objects.filter(workout_type__in=['Calisthenics', 'CrossFit'])
    return '\n'.join(str(x) for x in workout)

    # return '\n'.join(f"{w.name} from {w.workout_type} type has "
    #                  f"{w.difficulty} difficulty"
    #                  for w in Workout.objects.filter(workout_type__in=['Calisthenics', 'CrossFit']))


def get_high_difficulty_cardio_workouts()->QuerySet[Workout]:
    return Workout.objects.filter(workout_type='Cardio',difficulty='High').order_by('instructor')


def set_new_instructors()->None:
    Workout.objects.filter(workout_type='Cardio').update(instructor='John Smith')
    Workout.objects.filter(workout_type='Strength').update(instructor='Michael Williams')
    Workout.objects.filter(workout_type='Yoga').update(instructor='Emily Johnson')
    Workout.objects.filter(workout_type='CrossFit').update(instructor='Sarah Davis')
    Workout.objects.filter(workout_type='Calisthenics').update(instructor='Chris Heria')


def set_new_duration_times():
    Workout.objects.filter(instructor='John Smith').update(duration='15 minutes')
    Workout.objects.filter(instructor='Sarah Davis').update(duration='30 minutes')
    Workout.objects.filter(instructor='Chris Heria').update(duration='45 minutes')
    Workout.objects.filter(instructor='Michael Williams').update(duration='1 hour')
    Workout.objects.filter(instructor='Emily Johnson').update(duration='1 hour and 30 minutes')


def delete_workouts():
    Workout.objects.exclude(workout_type__in=['Strength', 'Calisthenics']).delete()

# workout1 = Workout.objects.create(
#     name="Push-Ups",
#     workout_type="Calisthenics",
#     duration="10 minutes",
#     difficulty="Intermediate",
#     calories_burned=200,
#     instructor="Chris Heria" )
# workout2 = Workout.objects.create(
#     name="Running",
#     workout_type="Cardio",
#     duration="30 minutes",
#     difficulty="High",
#     calories_burned=400,
#     instructor="John Smith" )
# def create(*args):
#     Workout.objects.bulk_create(args)
#
# workout_instances = [workout1, workout2]
#
# Workout.objects.bulk_create(workout_instances)


# high_difficulty_cardio_workouts = get_high_difficulty_cardio_workouts()
#
# for workout in high_difficulty_cardio_workouts:
#     print(f"{workout.name} by {workout.instructor}")
#
# set_new_instructors()
# workouts_with_new_instructors = Workout.objects.all()
# for workout in workouts_with_new_instructors:
#     print(f"Instructor: {workout.instructor}")
#
# set_new_duration_times()
# workouts_with_new_durations = Workout.objects.all()
# for workout in workouts_with_new_durations:
#     print(f"Duration: {workout.duration}")
