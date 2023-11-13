import os
import django



# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()
from main_app.models import RealEstateListing, VideoGame, BillingInfo, Invoice

# Import your models
# Create and check models
# Run and print your queries
# RealEstateListing.objects.create(property_type='House',price=100000.00,bedrooms=3,location='Los Angeles')
#
# RealEstateListing.objects.create(property_type='Flat', price=75000.00, bedrooms=2, location='New York City' )
#
# RealEstateListing.objects.create( property_type='Villa', price=250000.00, bedrooms=4, location='Los Angeles')
# RealEstateListing.objects.create( property_type='House', price=120000.00, bedrooms=3, location='San Francisco' )
#


#works
# house_listings = RealEstateListing.objects.by_property_type('House')
# print("House listings:")
# for listing in house_listings:
#     print(f"- {listing.property_type} in {listing.location}")

# affordable_listings = RealEstateListing.objects.in_price_range(75000.00, 120000.00)
# print("Price in range listings:")
# for listing in affordable_listings:
#     print(f"- {listing.property_type} in {listing.location}")
#
# two_bedroom_listings = RealEstateListing.objects.with_bedrooms(2)
# print("Two-bedroom listings:")
# for listing in two_bedroom_listings:
#     print(f"- {listing.property_type} in {listing.location}")

# popular_locations = RealEstateListing.objects.popular_locations()
# print("Popular locations:")
# for location in popular_locations:
#     print(f"- {location['location']}")
# game1 = VideoGame.objects.create(
#     title="The Last of Us Part II",
#     genre="Action",
#     release_year=2020, rating=9.0)
# game2 = VideoGame.objects.create(
#     title="Cyberpunk 2077",
#     genre="RPG",
#     release_year=2020,
#     rating=7.2)
# game3 = VideoGame.objects.create(
#     title="Red Dead Redemption 2",
#     genre="Adventure",
#     release_year=2018,
#     rating=9.7)
# game4 = VideoGame.objects.create(
#     title="FIFA 22",
#     genre="Sports",
#     release_year=2021,
#     rating=8.5)
# game5 = VideoGame.objects.create(
#     title="Civilization VI",
#     genre="Strategy",
#     release_year=2016,
#     rating=8.8)
# action_games = VideoGame.objects.games_by_genre('Action')
#
# recent_games = VideoGame.objects.recently_released_games(2019)
# # #
# average_rating = VideoGame.objects.average_rating()
# # #
# highest_rated = VideoGame.objects.highest_rated_game()
# # #
# lowest_rated = VideoGame.objects.lowest_rated_game()
#
#
# print(action_games)
#
# print(recent_games)
#
# print(average_rating)
# #
# print(highest_rated)
# #
# print(lowest_rated)
# Create BillingInfo instances with real addresses

# billing_info_1 = BillingInfo.objects.create(address="456 Oak Lane, Boston, MA02108")
#
# billing_info_2 = BillingInfo.objects.create(address="789 Maple Avenue, SanFrancisco, CA 94101")
#
# billing_info_3 = BillingInfo.objects.create(address="101 Pine Street, New York, NY10001")
#
# # Create Invoice instances with related BillingInfo
#
# invoice_1 = Invoice.objects.create(invoice_number="INV007",billing_info=billing_info_1)
# invoice_2 = Invoice.objects.create(invoice_number="INV002", billing_info=billing_info_2)
# invoice_3 = Invoice.objects.create(invoice_number="INV004", billing_info=billing_info_3)
invoices_with_prefix = Invoice.get_invoices_with_prefix("INV")
for invoice in invoices_with_prefix:
    print(f"Invoice Number with prefix INV: {invoice.invoice_number}")

