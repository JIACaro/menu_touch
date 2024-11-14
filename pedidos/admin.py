from django.contrib import admin
from .models import Producto, Pedido, PedidoProducto, PerfilUsuario

@admin.register(Producto)
class ProductoAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'categoria', 'precio', 'disponible')  # Personaliza las columnas visibles
    list_filter = ('categoria', 'disponible')  # Filtros por categoría y disponibilidad
    search_fields = ('nombre',)  # Barra de búsqueda por nombre

@admin.register(Pedido)
class PedidoAdmin(admin.ModelAdmin):
    list_display = ('id', 'mesa', 'fecha_pedido', 'estado', 'total')
    list_filter = ('estado', 'fecha_pedido')
    search_fields = ('mesa__username',)  # Búsqueda por nombre de usuario de la mesa

@admin.register(PedidoProducto)
class PedidoProductoAdmin(admin.ModelAdmin):
    list_display = ('pedido', 'producto', 'cantidad', 'subtotal')

@admin.register(PerfilUsuario)
class PerfilUsuarioAdmin(admin.ModelAdmin):
    list_display = ('usuario', 'rol')
    list_filter = ('rol',)
    search_fields = ('usuario__username',)  # Búsqueda por nombre de usuario