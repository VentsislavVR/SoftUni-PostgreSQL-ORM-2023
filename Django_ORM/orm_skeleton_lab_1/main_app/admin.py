from django.contrib import admin

from main_app.models import Employee


# Register your models here.
@admin.register(Employee)
class EmployeeAdmin(admin.ModelAdmin):
    pass