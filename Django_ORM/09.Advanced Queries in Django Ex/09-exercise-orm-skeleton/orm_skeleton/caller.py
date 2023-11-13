import os
from datetime import date

import django



# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()
from main_app.models import Invoice, RealEstateListing, VideoGame, Technology, Project, Programmer, Task, Exercise

# FIRST output
# house_listings = RealEstateListing.objects.by_property_type('House')
# print("House listings:")
# for listing in house_listings:
#     print(f"- {listing.property_type} in {listing.location}")
#
# affordable_listings = RealEstateListing.objects.in_price_range(75000.00, 120000.00)
# print("Price in range listings:")
# for listing in affordable_listings:
#     print(f"- {listing.property_type} in {listing.location}")
#
# two_bedroom_listings = RealEstateListing.objects.with_bedrooms(2)
# print("Two-bedroom listings:")
# for listing in two_bedroom_listings:
#     print(f"- {listing.property_type} in {listing.location}")
#
# popular_locations = RealEstateListing.objects.popular_locations()
# print("Popular locations:")
#
# for location in popular_locations:
#     print(f"- {location['location']}")


# action_games = VideoGame.objects.games_by_genre('Action')
#
# recent_games = VideoGame.objects.recently_released_games(2019)
#
# average_rating = VideoGame.objects.average_rating()
#
# highest_rated = VideoGame.objects.highest_rated_game()
#
# lowest_rated = VideoGame.objects.lowest_rated_game()
#
#
# print(action_games)
#
# print(recent_games)
#
# print(average_rating)
#
# print(highest_rated)
#
# print(lowest_rated)

# invoices_with_prefix = Invoice.get_invoices_with_prefix("INV")
# for invoice in invoices_with_prefix:
#     print(f"Invoice Number with prefix INV: {invoice.invoice_number}")
#
# invoices_sorted = Invoice.get_invoices_sorted_by_number()
# for invoice in invoices_sorted:
#     print(f"Invoice Number: {invoice.invoice_number}")

# invoice = Invoice.get_invoice_with_billing_info("INV002")
# print(f"Invoice Number: {invoice.invoice_number}")
# print(f"Billing Info: {invoice.billing_info.address}")
# tech1 = Technology.objects.create(name="Python", description="A high-levelprogramming language")
#
# tech2 = Technology.objects.create(name="JavaScript", description="A scripting language for the web")
#
# tech3 = Technology.objects.create(name="SQL", description="Structured QueryLanguage")
#
#
#
# project1 = Project.objects.create(name="Web App Project", description="Developing aweb application")
#
# project1.technologies_used.add(tech1, tech2)
#
# project2 = Project.objects.create(name="Database Project", description="Managing databases")
#
# project2.technologies_used.add(tech3)
#
# # Create instances of Programmer
#
# programmer1 = Programmer.objects.create(name="Alice")
#
# programmer2 = Programmer.objects.create(name="Bob")
#
# # Associate projects with programmers
#
# programmer1.projects.add(project1, project2)
#
# programmer2.projects.add(project1)

# specific_project = Project.objects.get(name="Web App Project")
# programmers_with_technologies = specific_project.get_programmers_with_technologies()
# for programmer in programmers_with_technologies:
#     print(f"Programmer: {programmer.name}")
#     for technology in programmer.projects.get(name="Web App Project").technologies_used.all():
#         print(f"- Technology: {technology.name}")
# specific_programmer = Programmer.objects.get(name="Alice")
# projects_with_technologies = specific_programmer.get_projects_with_technologies()
# for project in projects_with_technologies:
#     print(f"Project: {project.name} for {specific_programmer.name}")
#     for technology in project.technologies_used.all():
#         print(f"- Technology: {technology.name}")
# task1 = Task(title="Task 1",
#              description="Description for Task 1",
#              priority="High",
#              creation_date=date(2023, 1, 15),
#              completion_date=date(2023, 1, 25)
#
#             )
# task2 = Task(
# title="Task 2",
# description="Description for Task 2",
# priority="Medium",
# is_completed=True,
# creation_date=date(2023, 2, 1),
# completion_date=date(2023, 2, 10)
#
# )
# task3 = Task(
# title="Task 3",
# description="Description for Task 3",
# priority="Hard",
# is_completed=True,
# creation_date=date(2023, 1, 15), completion_date=date(2023, 1, 20))
#
# task1.save()
# task2.save()
# task3.save()
#
#
# overdue_high_priority = Task.overdue_high_priority_tasks()
# print("Overdue High Priority Tasks:")
# for task in overdue_high_priority:
#     print('- ' + task.title)
#
# completed_mid_priority = Task.completed_mid_priority_tasks()
# print("Completed Medium Priority Tasks:")
# for task in completed_mid_priority:
#     print('- ' + task.title)
#
# search_results = Task.search_tasks("Task 3")
# print("Search Results:")
# for task in search_results:
#     print('- ' + task.title)
#
# recent_completed = task1.recent_completed_tasks(days=5)
# print("Recent Completed Tasks:")
# for task in recent_completed:
#     print('- ' + task.title)

# exercise1 = Exercise.objects.create(
#
# name="Push-ups",
#
# category="Strength",
#
# difficulty_level=4,
#
# duration_minutes=10,
#
# repetitions=50,
#
# )
#
# exercise2 = Exercise.objects.create(
#
# name="Running",
#
# category="Cardio",
#
# difficulty_level=7,
#
# duration_minutes=20,
#
# repetitions=0, )
#
# exercise3 = Exercise.objects.create( name="Pull-ups", category="Strength", difficulty_level=13, duration_minutes=35, repetitions=20, )
#
# long_and_hard_exercises = Exercise.get_long_and_hard_exercises()
# print("Long and hard exercises:")
# for exercise in long_and_hard_exercises:
#     print('- ' + exercise.name)
#
# short_and_easy_exercises = Exercise.get_short_and_easy_exercises()
# print("Short and easy exercises:")
# for exercise in short_and_easy_exercises:
#     print('- ' + exercise.name)
#
# exercises_within_duration = Exercise.get_exercises_within_duration(20, 40)
# print(f"Exercises within 20 - 40 minutes:")
# for exercise in exercises_within_duration:
#     print('- ' + exercise.name)
#
# exercises_with_difficulty_and_repetitions = Exercise.get_exercises_with_difficulty_and_repetitions(6, 15)
# print(f"Exercises with difficulty 6+ and repetitions 15+:")
# for exercise in exercises_with_difficulty_and_repetitions:
#     print('- ' + exercise.name)