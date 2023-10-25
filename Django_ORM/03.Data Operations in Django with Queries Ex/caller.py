import os
import django



# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()

# Import your models here
from main_app.models import Pet, Artifact, Location, Car, Task, HotelRoom


# Create queries within functions
def create_pet(name:str,species:str):
    pet = Pet.objects.create(
        name=name,
        species=species,
    )
    pet.save()
    return f"{pet.name} is a very cute {pet.species}!"

# print(create_pet('Buddy', 'Dog'))
# print(create_pet('Whiskers', 'Cat'))
# print(create_pet('Rocky', 'Hamster'))
#

def create_artifact(name:str,origin:str,age:int,description:str,is_magical:bool):
    artifact = Artifact.objects.create(
        name=name,
        origin=origin,
        age=age,
        description=description,
        is_magical=is_magical,
    )
    artifact.save()
    return f"The artifact {artifact.name} is {artifact.age} years old!"

def delete_all_artifacts():
    Artifact.objects.all().delete()

def show_all_locations():
    locs = Location.objects.all().order_by('-id')
    res = []
    for l in locs:
        res.append(f"{l.name} has a population of {l.population}!")

    return '\n'.join(res)


def new_capital():
    new_c = Location.objects.filter().first()
    if new_c is not None:
        new_c.is_capital = True
        new_c.save()

def get_capitals():

    capitals_loc = Location.objects.filter(is_capital=True)

    capitals_names = capitals_loc.values('name')
    return capitals_names
def delete_first_location():
    Location.objects.first().delete()


def apply_discount():
    cars = Car.objects.all()
    for c in cars:
        discount = sum(int(x) for x in str(c.year))
        c.price_with_discount = float(c.price) - (float(c.price) * (float(discount) / 100.0))
        c.save()


def get_recent_cars():
    recent_cars = Car.objects.filter(year__gte=2020)
    return recent_cars.values('model','price_with_discount')
                    # .only(models , price_with etc)
def delete_last_car():
    Car.objects.last().delete()

# def show_unfinished_tasks():
#     unfinished = Task.objects.filter(is_finished=False)
#     result = []
#     for u in unfinished:
#         result.append(f"Task - {u.title} needs to be done until {u.due_date}!")
#     return '\n'.join(result)
def show_unfinished_tasks():
    unfinished_tasks = Task.objects.filter(is_finished=False)
    result = [f"Task - {task.title} needs to be done until {task.due_date}!" for task in unfinished_tasks]
    return '\n'.join(result)


def complete_odd_tasks():
    odd_task_ids = [task.id for task in Task.objects.all() if task.id % 2 != 0]
    Task.objects.filter(id__in=odd_task_ids).update(is_finished=True)


def encode_and_replace(text: str, task_title: str):
    task = Task.objects.get(title=task_title)
    new_description = []
    for char in text:
        enc = ord(char) - 3
        new_description.append(chr(enc))
    task.description = ''.join(new_description)
    task.save()

# TODO fix
def get_deluxe_rooms():
    deluxe_rooms = HotelRoom.objects.filter(room_type='Deluxe')

    room_info_list = []

    for room in deluxe_rooms:
        if room.id % 2 == 0:
            room_info = f"Deluxe room with number {room.room_number} costs {room.price_per_night}$ per night!"
            room_info_list.append(room_info)

    return '\n'.join(room_info_list)

def increase_room_capacity():
    rooms = HotelRoom.objects.order_by('room_number')

    for i, room in enumerate(rooms):
        if rooms.last() or rooms.first() == room:
            room.capacity += room.id

        else:
            previous_room = rooms[i + 1]
            room.capacity += previous_room.capacity
        room.save()


def reserve_first_room():
    first_room = HotelRoom.objects.first()
    if first_room:
        first_room.is_reserved = True
        first_room.save()

def delete_last_room():
    HotelRoom.objects.last().delete()

#TODO 7
