from django.urls import path
from . import views

urlpatterns = [
    path('', views.dashboard, name='administrativo_dashboard'),
    path('productos/', views.lista_productos, name='lista_productos'),
    path('productos/crear/', views.crear_producto, name='crear_producto'),
    path('productos/editar/<int:pk>/', views.editar_producto, name='editar_producto'),
    path('productos/eliminar/<int:pk>/', views.eliminar_producto, name='eliminar_producto'),
    path('pedidos/por-mesa/', views.listar_pedidos_por_mesa, name='listar_pedidos_por_mesa'),
    path('pedidos/por-mesa/<str:mesa_username>/', views.ver_pedidos_mesa, name='ver_pedidos_mesa'),
    path('boleta/<int:boleta_id>/', views.ver_boleta, name='ver_boleta'),
    
]
