from django.urls import path
from . import views

urlpatterns = [
    path('', views.gestion_pedidos, name='garzon_gestion_pedidos'),
]
