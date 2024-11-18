from django.shortcuts import render, redirect
from pedidos.models import Pedido, PerfilUsuario, Boleta 
from django.http import JsonResponse
from .decorators import garzon_required
from django.shortcuts import render, get_object_or_404


@garzon_required
def gestion_pedidos(request):
    # Filtra pedidos listos para entrega
    pedidos = Pedido.objects.filter(estado='LIST').order_by('fecha_pedido')

    # Filtra usuarios con el rol de "mesa"
    perfiles_mesas = PerfilUsuario.objects.filter(rol='mesa')

    # Calcula el estado de cada mesa basado en los estados actuales
    mesas_con_estados = []
    for perfil in perfiles_mesas:
        mesa_pedidos = perfil.usuario.pedido_set.all()
        if mesa_pedidos.filter(estado='PAGAR').exists():
            estado = 'PAGAR'
        elif mesa_pedidos.filter(estado='LIST').exists():
            estado = 'LIST'
        elif mesa_pedidos.filter(estado='PREP').exists():
            estado = 'PREP'
        else:
            estado = 'OTHER'
        mesas_con_estados.append({
            'username': perfil.usuario.username,
            'estado': estado
        })

    return render(request, 'garzon/gestion_pedidos.html', {
        'pedidos': pedidos,
        'mesas_con_estados': mesas_con_estados
    })

@garzon_required
def cambiar_estado_pedido_garzon(request, order_id):
    print("Iniciando el proceso para cambiar el estado del pedido en Garzón...")

    if request.method != 'POST':
        return JsonResponse({"error": "Método no permitido"}, status=405)

    try:
        pedido = Pedido.objects.get(id=order_id)
        print(f"Pedido encontrado: {pedido}")

        # Cambia el estado según la lógica
        if pedido.estado == 'PREP':  # Si el pedido está en preparación
            print("Cambiando el estado del pedido a 'Listo para entrega'")
            pedido.estado = 'LIST'
            pedido.save()
            return JsonResponse({"success": True, "new_state": "LIST"})

        elif pedido.estado == 'LIST':  # Si el pedido está listo
            print("Cambiando el estado del pedido a 'Entregado'")
            pedido.estado = 'ENTR'
            pedido.save()
            return JsonResponse({"success": True, "new_state": "ENTR"})

        elif pedido.estado == 'ENTR':  # Si el pedido ya fue entregado
            print("El pedido ya ha sido entregado.")
            return JsonResponse({"error": "El pedido ya ha sido entregado"}, status=400)

        else:  # Maneja cualquier otro estado inesperado
            print(f"Estado desconocido: {pedido.estado}")
            return JsonResponse({"error": f"El estado actual ({pedido.estado}) no permite el cambio"}, status=400)

    except Pedido.DoesNotExist:
        print("Error: Pedido no encontrado")
        return JsonResponse({"error": "Pedido no encontrado"}, status=404)

    except Exception as e:
        print(f"Error desconocido: {e}")
        return JsonResponse({"error": "Error interno del servidor"}, status=500)
    

@garzon_required
def mesas_pedidos(request):
    # Traer todas las mesas que están activas (con perfil de rol "mesa")
    mesas = PerfilUsuario.objects.filter(rol='mesa')

    # Traer todos los pedidos asociados a esas mesas
    pedidos_por_mesa = {}
    for mesa in mesas:
        pedidos = Pedido.objects.filter(mesa=mesa.usuario).exclude(estado='FIN').order_by('-fecha_pedido')
        pedidos_por_mesa[mesa] = pedidos

    return render(request, 'garzon/mesas_pedidos.html', {
        'mesas': mesas,
        'pedidos_por_mesa': pedidos_por_mesa
    })


@garzon_required
def detalle_pedidos_mesa(request, username):
    mesa = get_object_or_404(PerfilUsuario, usuario__username=username, rol='mesa')

    # Filtrar pedidos con los estados especificados
    estados_validos = ['PREP', 'LIST', 'ENTR', 'PAGAR']
    pedidos = Pedido.objects.filter(
        mesa=mesa.usuario,
        estado__in=estados_validos
    ).order_by('-fecha_pedido')

    return render(request, 'garzon/detalle_pedidos_mesa.html', {
        'mesa': mesa,
        'pedidos': pedidos
    })


@garzon_required
def fusionar_pedidos(request):
    if request.method == 'POST':
        pedidos_ids = request.POST.getlist('pedidos_seleccionados')  # Obtener los pedidos seleccionados
        pedidos = Pedido.objects.filter(id__in=pedidos_ids)

        # Crear la boleta
        boleta = Boleta()
        boleta.save()
        boleta.pedidos.set(pedidos)  # Asignar los pedidos a la boleta
        boleta.calcular_total()  # Calcular el total de la boleta

        # Redirigir a la vista de boleta generada
        return redirect('boleta_generada', boleta_id=boleta.id)
    return JsonResponse({"error": "Método no permitido"}, status=405)


@garzon_required
def boleta_generada(request, boleta_id):
    try:
        boleta = Boleta.objects.get(id=boleta_id)
        pedidos = boleta.pedidos.all()

        return render(request, 'garzon/boleta_generada.html', {
            'boleta': boleta,
            'pedidos': pedidos
        })
    except Boleta.DoesNotExist:
        return JsonResponse({"error": "Boleta no encontrada"}, status=404)



@garzon_required
def marcar_boleta_pagada(request, boleta_id):
    try:
        boleta = Boleta.objects.get(id=boleta_id)
        pedidos = boleta.pedidos.all()

        # Cambiar el estado de cada pedido a 'FIN'
        for pedido in pedidos:
            pedido.estado = 'FIN'
            pedido.save()

        # Redirigir a la página principal de garzón
        return redirect('gestion_pedidos') 
    except Boleta.DoesNotExist:
        return JsonResponse({"error": "Boleta no encontrada"}, status=404)
