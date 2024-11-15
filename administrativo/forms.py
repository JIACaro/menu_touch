from django import forms
from pedidos.models import Producto


class ProductoForm(forms.ModelForm):
    class Meta:
        model = Producto
        fields = ['nombre', 'categoria', 'precio', 'descripcion', 'disponible', 'imagen']
