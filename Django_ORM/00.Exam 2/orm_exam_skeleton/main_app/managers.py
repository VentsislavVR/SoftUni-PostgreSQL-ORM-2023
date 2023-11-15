from django.db import models
from django.db.models import Count


class CustomProfileManager(models.Manager):
    def get_regular_customers(self):
        return (self.prefetch_related('orders').annotate(order_count=Count('orders')).filter(order_count__gt=2)
                .order_by('-order_count'))



