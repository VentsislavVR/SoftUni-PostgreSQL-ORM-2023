# Generated by Django 4.2.4 on 2023-10-23 17:23

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main_app', '0007_supplier'),
    ]

    operations = [
        migrations.CreateModel(
            name='Person',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=40)),
                ('age', models.PositiveIntegerField()),
                ('age_group', models.CharField(default='No age group', max_length=20)),
            ],
        ),
    ]
