from django.urls import path
from . import views

urlpatterns = [
    path('', views.gestion_pedidos, name='gestion_pedidos'),
    path('cambiar-estado-pedido/<int:order_id>/', views.cambiar_estado_pedido_garzon, name='cambiar_estado_pedido_garzon'),
]