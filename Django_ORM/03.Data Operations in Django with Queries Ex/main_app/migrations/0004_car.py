# Generated by Django 4.2.4 on 2023-10-25 19:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main_app', '0003_location'),
    ]

    operations = [
        migrations.CreateModel(
            name='Car',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('model', models.CharField(max_length=40)),
                ('year', models.PositiveIntegerField()),
                ('color', models.CharField(max_length=40)),
                ('price', models.DecimalField(decimal_places=2, max_digits=10)),
                ('price_with_discount', models.DecimalField(decimal_places=2, default=0, max_digits=10)),
            ],
        ),
    ]
