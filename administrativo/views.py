from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from pedidos.models import Producto
from .forms import ProductoForm
def dashboard(request):
    return render(request, 'administrativo/dashboard.html')

# Lista de productos
def lista_productos(request):
    productos = Producto.objects.all()
    return render(request, 'administrativo/lista_productos.html', {'productos': productos})

# Crear producto
def crear_producto(request):
    if request.method == 'POST':
        form = ProductoForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('lista_productos')
    else:
        form = ProductoForm()
    return render(request, 'administrativo/crear_producto.html', {'form': form})

# Editar producto
def editar_producto(request, pk):
    producto = get_object_or_404(Producto, pk=pk)
    if request.method == 'POST':
        form = ProductoForm(request.POST, request.FILES, instance=producto)
        if form.is_valid():
            form.save()
            return redirect('lista_productos')
    else:
        form = ProductoForm(instance=producto)
    return render(request, 'administrativo/editar_producto.html', {'form': form})

# Eliminar producto
def eliminar_producto(request, pk):
    producto = get_object_or_404(Producto, pk=pk)
    if request.method == 'POST':
        producto.delete()
        return redirect('lista_productos')
    return render(request, 'administrativo/eliminar_producto.html', {'producto': producto})