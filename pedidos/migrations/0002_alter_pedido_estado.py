# Generated by Django 5.0.4 on 2024-11-15 03:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('pedidos', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='pedido',
            name='estado',
            field=models.CharField(choices=[('DISP', 'Disponible'), ('PREP', 'En preparación'), ('LIST', 'Listo para entrega'), ('ENTR', 'Entregado'), ('PAGAR', 'Quieren pagar')], default='DISP', max_length=6),
        ),
    ]
