from django.shortcuts import render, get_object_or_404, redirect
from django.db.models import Count, Sum
from .decorators import admin_required
from django.db.models.functions import TruncDate
from datetime import timedelta
from django.utils.timezone import now
from pedidos.models import Producto, Pedido, Boleta
from .forms import ProductoForm

@admin_required
def dashboard(request):
    return render(request, 'administrativo/dashboard.html')

@admin_required
def lista_productos(request):
    productos = Producto.objects.all()
    return render(request, 'administrativo/lista_productos.html', {'productos': productos})

@admin_required
def crear_producto(request):
    if request.method == 'POST':
        form = ProductoForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('lista_productos')
    else:
        form = ProductoForm()
    return render(request, 'administrativo/crear_producto.html', {'form': form})

@admin_required
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

@admin_required
def eliminar_producto(request, pk):
    producto = get_object_or_404(Producto, pk=pk)
    if request.method == 'POST':
        producto.delete()
        return redirect('lista_productos')
    return render(request, 'administrativo/eliminar_producto.html', {'producto': producto})


@admin_required
def listar_pedidos_por_mesa(request):
    """
    Vista para listar los pedidos agrupados por mesa y por día.
    Solo incluye los pedidos de los últimos 7 días.
    """
    # Fecha límite (hace 7 días)
    fecha_limite = now() - timedelta(days=7)

    # Filtrar pedidos finalizados dentro de los últimos 7 días
    pedidos_finalizados = Pedido.objects.filter(estado='FIN', fecha_pedido__gte=fecha_limite).values('mesa__username')

    # Agrupar pedidos por mesa
    pedidos_agrupados = (
        Pedido.objects.filter(fecha_pedido__gte=fecha_limite)  # Filtrar últimos 7 días
        .values('mesa__username')                              # Agrupar por mesa (username)
        .annotate(
            total_pedidos=Count('id'),                         # Total de pedidos por mesa
            monto_total=Sum('total'),                         # Suma del monto total generado
        )
        .order_by('mesa__username')                           # Ordenar por mesa
    )

    # Convertir los pedidos finalizados en un diccionario {mesa: cantidad_finalizados}
    pedidos_finalizados_count = {
        item['mesa__username']: item['total'] for item in pedidos_finalizados.annotate(total=Count('id'))
    }

    # Añadir la cantidad de pedidos con boleta al resultado principal
    for item in pedidos_agrupados:
        item['pedidos_con_boleta'] = pedidos_finalizados_count.get(item['mesa__username'], 0)

    # Agrupar pedidos por día dentro de los últimos 7 días
    pedidos_por_dia = (
        Pedido.objects.filter(fecha_pedido__gte=fecha_limite)  # Filtrar últimos 7 días
        .annotate(fecha=TruncDate('fecha_pedido'))             # Agrupar por fecha (sin hora)
        .values('fecha')                                       # Obtener solo la fecha
        .annotate(
            total_pedidos=Count('id'),                         # Contar pedidos por día
            monto_total=Sum('total'),                         # Sumar el total generado por día
        )
        .order_by('-fecha')                                    # Ordenar por fecha descendente
    )

    return render(
        request,
        'administrativo/listar_pedidos_por_mesa.html',
        {
            'pedidos_agrupados': pedidos_agrupados,
            'pedidos_por_dia': pedidos_por_dia,
        }
    )


@admin_required
def ver_pedidos_mesa(request, mesa_username):
    """
    Vista para listar los pedidos realizados por una mesa específica.
    Incluye información de las boletas asociadas a los pedidos.
    """
    pedidos = Pedido.objects.filter(mesa__username=mesa_username).select_related('mesa')
    
    # Crear un diccionario de boletas asociadas a cada pedido
    boletas = {
        pedido.id: Boleta.objects.filter(pedidos=pedido).first() for pedido in pedidos
    }
    
    context = {
        'mesa_username': mesa_username,
        'pedidos': pedidos,
        'boletas': boletas,  # Diccionario de boletas asociadas
    }
    return render(request, 'administrativo/ver_pedidos_mesa.html', context)



@admin_required
def ver_boleta(request, boleta_id):
    """
    Vista para mostrar los detalles de una boleta específica,
    junto con los pedidos asociados y los productos con cantidad y subtotales.
    """
    boleta = get_object_or_404(Boleta, id=boleta_id)
    pedidos = boleta.pedidos.prefetch_related('productos', 'pedidoproducto_set')

    mesa_username = pedidos.first().mesa.username if pedidos.exists() else None

    return render(
        request,
        'administrativo/ver_boleta.html',
        {'boleta': boleta, 'pedidos': pedidos, 'mesa_username': mesa_username}
    )
