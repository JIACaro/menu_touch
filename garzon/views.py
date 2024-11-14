from django.shortcuts import render
from pedidos.models import Pedido


def gestion_pedidos(request):
    pedidos = Pedido.objects.all()
    mesas_estado = {}

    for pedido in pedidos:
        estado = pedido.estado  # PREP, LIST, ENTR
        mesa = pedido.mesa.username
        mesas_estado[mesa] = estado  # Sobrescribe el estado con el último pedido

    return render(request, 'garzon/gestion_pedidos.html', {'mesas_estado': mesas_estado})