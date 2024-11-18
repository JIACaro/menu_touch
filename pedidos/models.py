from django.db import models
from django.conf import settings

# Modelo Producto
class Producto(models.Model):
    CATEGORIAS = [
        ('Platos', 'Platos'),
        ('Bebestibles', 'Bebestibles'),
        ('Acompañamiento', 'Acompañamiento'),
        ('Postres', 'Postres'),
    ]

    nombre = models.CharField(max_length=100)
    categoria = models.CharField(max_length=50, choices=CATEGORIAS)
    precio = models.IntegerField()
    descripcion = models.TextField(blank=True, null=True)
    disponible = models.BooleanField(default=True)
    imagen = models.ImageField(upload_to='productos/', blank=True, null=True)

    def __str__(self):
        return self.nombre

# Modelo Pedido
class Pedido(models.Model):
    ESTADOS = [
        ('PREP', 'En preparación'),
        ('LIST', 'Listo para entrega'),
        ('ENTR', 'Entregado'),
        ('PAGAR', 'Quieren pagar'),
        ('FIN', 'Pagado'),
    ]

    mesa = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)  # Cambiado a AUTH_USER_MODEL
    fecha_pedido = models.DateTimeField(auto_now_add=True)
    productos = models.ManyToManyField(Producto, through='PedidoProducto')
    total = models.IntegerField(default=0)
    estado = models.CharField(max_length=6, choices=ESTADOS, default='PREP')  # Estado inicial

    def __str__(self):
        return f"Pedido #{self.id} - Mesa: {self.mesa.username} - Estado: {self.get_estado_display()}"


# Modelo intermedio para manejar la cantidad de productos en un pedido
class PedidoProducto(models.Model):
    pedido = models.ForeignKey(Pedido, on_delete=models.CASCADE)
    producto = models.ForeignKey(Producto, on_delete=models.CASCADE)
    cantidad = models.PositiveIntegerField(default=1)
    subtotal = models.IntegerField()

    def __str__(self):
        return f"{self.cantidad} x {self.producto.nombre}"

# Modelo PerfilUsuario
class PerfilUsuario(models.Model):
    ROLES = [
        ('mesa', 'Mesa'),
        ('admin', 'Administrador'),
        ('garzon', 'Garzón'),
        ('cocina', 'Cocina'),
    ]
    usuario = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    rol = models.CharField(max_length=10, choices=ROLES)

    def __str__(self):
        return f"{self.usuario.username} - {self.get_rol_display()}"
