from django.urls import path
from . import views

urlpatterns = [
    path('', views.gestion_pedidos, name='gestion_pedidos'),
    path('cambiar-estado-pedido/<int:order_id>/', views.cambiar_estado_pedido_garzon, name='cambiar_estado_pedido_garzon'),
    path('mesas/', views.mesas_pedidos, name='mesas_pedidos'),
    path('mesas/<str:username>/', views.detalle_pedidos_mesa, name='detalle_pedidos_mesa'),
    path('fusionar/', views.fusionar_pedidos, name='fusionar_pedidos'),
    path('boleta/<int:boleta_id>/', views.boleta_generada, name='boleta_generada'),
    path('boleta/<int:boleta_id>/pagado/', views.marcar_boleta_pagada, name='marcar_boleta_pagada'),
    path('eliminar-boleta/<int:boleta_id>/', views.eliminar_boleta_no_confirmada, name='eliminar_boleta_no_confirmada'),

]