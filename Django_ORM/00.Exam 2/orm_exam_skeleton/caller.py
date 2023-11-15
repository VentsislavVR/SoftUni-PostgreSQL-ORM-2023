import os
import django
from django.db import transaction
from django.db.models import Q, Count, F

# Set up Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm_skeleton.settings")
django.setup()
from main_app.models import Profile, Order, Product


# Import your models here
# Create and run your queries within functions

def get_profiles(search_string=None):
    if search_string is not None:
        profiles = Profile.objects.filter(
            Q(full_name__icontains=search_string) |
            Q(email__icontains=search_string) |
            Q(phone_number__icontains=search_string)
        )
        if profiles.exists():

            res = []
            for p in profiles.order_by('full_name'):
                res.append(f"Profile: {p.full_name}, email: {p.email}, phone number: {p.phone_number}, orders: {p.orders.count()}")
            return '\n'.join(res)
        return ''
    return ''

def get_loyal_profiles():
    loyal_profiles = Profile.objects.get_regular_customers()
    if loyal_profiles.exists():
        res = []
        for p in loyal_profiles:
            res.append(f"Profile: {p.full_name}, orders: {p.orders.count()}")

        return '\n'.join(res)
    return ''


def get_last_sold_products():
    last_sold_products = Order.objects.prefetch_related('products').order_by('-creation_date')
    if last_sold_products:
        for order in last_sold_products:
            products_in_order = order.products.all()
            res = []
            for product in products_in_order:
                res.append(product.name)

            return f"Last sold products: {', '.join(res)}"
    return ''


def get_top_products():

        top_sold_products = (
            Product.objects
            .annotate(num_orders=Count('orders__id', distinct=True))
            .order_by('-num_orders', 'name'))[:5]
        if top_sold_products:
            res = ['Top products:',]
            for product in top_sold_products:
                res.append(f"{product.name}, sold {product.num_orders} times")

            return '\n'.join(res)
        return ''

def apply_discounts():
    # Filter orders with more than two products and is_completed=False
    orders_to_update = Order.objects.annotate(num_products=Count('products', distinct=True)).filter(num_products__gt=2, is_completed=False)

    num_of_orders_to_update = orders_to_update.count()

    if num_of_orders_to_update > 0:
        orders_to_update.update(total_price=F('total_price') * 0.9)

    return f"Discount applied to {num_of_orders_to_update} orders."


def complete_order():

    order_to_complete = Order.objects.prefetch_related('products').filter(is_completed=False).first()
    if not order_to_complete:
        return ''
    if order_to_complete:
        for product in order_to_complete.products.all():
            if product.in_stock<= 0:
                product.is_available = False
            else:
                product.is_available = True
                product.in_stock -= 1
                product.save()

        order_to_complete.is_completed = True
        order_to_complete.save()

        return "Order has been completed!"
    else:
         return ""

