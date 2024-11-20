from django.shortcuts import render, redirect
from pedidos.models import Pedido, PerfilUsuario, Boleta 
from django.http import JsonResponse
from django.contrib import messages  # Importar mensajes para notificaciones
from .decorators import garzon_required
from django.db.models import Case, When, Value, CharField
from django.db import transaction  # Para manejar transaccione
from django.shortcuts import render, get_object_or_404



@garzon_required
def gestion_pedidos(request):
    # Eliminar boletas no confirmadas antes de renderizar la página
    Boleta.eliminar_no_confirmadas()

    # Filtra usuarios con el rol de "mesa"
    perfiles_mesas = PerfilUsuario.objects.filter(rol='mesa')

    # Calcular el estado de cada mesa basado en los pedidos asociados
    mesas_con_estados = []
    for perfil in perfiles_mesas:
        # Obtiene todos los pedidos asociados a la mesa (usuario)
        mesa_pedidos = Pedido.objects.filter(mesa=perfil.usuario)

        # Determina el estado más relevante de los pedidos
        if mesa_pedidos.filter(estado='PAGAR').exists():
            estado = 'PAGAR'  # Prioridad más alta
        elif mesa_pedidos.filter(estado='LIST').exists():
            estado = 'LIST'
        elif mesa_pedidos.filter(estado='PREP').exists():
            estado = 'PREP'
        else:
            estado = 'OTHER'  # Si no hay pedidos relevantes

        # Agrega la mesa con su estado al contexto
        mesas_con_estados.append({
            'username': perfil.usuario.username,
            'estado': estado,
        })

    # Filtra pedidos listos para entrega (opcional para mostrar en la vista)
    pedidos = Pedido.objects.filter(estado='LIST').order_by('fecha_pedido')

    # Renderiza la plantilla con los datos preparados
    return render(request, 'garzon/gestion_pedidos.html', {
        'mesas_con_estados': mesas_con_estados,
        'pedidos': pedidos,
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

        if not pedidos_ids:
            messages.error(request, "Debes seleccionar al menos un pedido para fusionar.")
            previous_url = request.META.get('HTTP_REFERER', 'gestion_pedidos')
            return redirect(previous_url)

        pedidos = Pedido.objects.filter(id__in=pedidos_ids)

        # Verificar si ya existe una boleta con los mismos pedidos
        boleta_existente = None
        for boleta in Boleta.objects.all():
            boleta_pedidos_ids = set(boleta.pedidos.values_list('id', flat=True))
            if boleta_pedidos_ids == set(map(int, pedidos_ids)):
                boleta_existente = boleta
                break

        if boleta_existente:
            boleta = boleta_existente
        else:
            # Crear una nueva boleta
            boleta = Boleta()
            boleta.save()
            boleta.pedidos.set(pedidos)  # Asignar los pedidos a la boleta
            boleta.calcular_total()

        # Depuración: Verificar pedidos asociados después de fusionar
        print(f"Pedidos asociados a la boleta #{boleta.id}: {[pedido.id for pedido in boleta.pedidos.all()]}")

        # Redirigir a la vista de boleta generada
        return redirect('boleta_generada', boleta_id=boleta.id)

    return JsonResponse({"error": "Método no permitido"}, status=405)



@garzon_required
def boleta_generada(request, boleta_id):
    try:
        boleta = Boleta.objects.prefetch_related('pedidos').get(id=boleta_id)
        pedidos = boleta.pedidos.all()  # Recuperar los pedidos relacionados

        if not pedidos.exists():
            messages.warning(request, "Esta boleta no tiene pedidos asociados.")

        return render(request, 'garzon/boleta_generada.html', {
            'boleta': boleta,
            'pedidos': pedidos
        })
    except Boleta.DoesNotExist:
        messages.error(request, "La boleta no existe.")
        return redirect('gestion_pedidos')


@garzon_required
def marcar_boleta_pagada(request, boleta_id):
    try:
        # Recuperar la boleta y los pedidos asociados
        boleta = Boleta.objects.prefetch_related('pedidos').get(id=boleta_id)

        # Registrar los IDs de los pedidos asociados
        pedidos_ids = list(boleta.pedidos.values_list('id', flat=True))

        # Verificar que la boleta tiene pedidos asociados
        if not pedidos_ids:
            messages.error(request, "No hay pedidos asociados a esta boleta.")
            return redirect('boleta_generada', boleta_id=boleta_id)

        # Cambiar el estado de los pedidos a 'FIN'
        pedidos = Pedido.objects.filter(id__in=pedidos_ids)
        for pedido in pedidos:
            pedido.estado = 'FIN'
            pedido.save()

        # Confirmar la boleta sin modificar la relación ManyToMany
        boleta.confirmada = True
        boleta.save()

        # Reafirmar la relación ManyToMany si es necesario
        boleta.pedidos.add(*pedidos)

        # Depuración: Verificar pedidos después de guardar
        print(f"Pedidos asociados después de marcar como pagada: {[pedido.id for pedido in boleta.pedidos.all()]}")

        # Mensaje de éxito y redirección
        messages.success(request, f"La boleta #{boleta.id} se ha marcado como pagada correctamente.")
        return redirect('gestion_pedidos')

    except Boleta.DoesNotExist:
        messages.error(request, "La boleta no existe.")
        return redirect('gestion_pedidos')

    except Exception as e:
        messages.error(request, f"Error al procesar la boleta: {e}")
        return redirect('gestion_pedidos')

@garzon_required
def eliminar_boleta_no_confirmada(request, boleta_id):
    if request.method == "POST":
        try:
            boleta = Boleta.objects.get(id=boleta_id, confirmada=False)
            boleta.delete()
            return JsonResponse({"success": True})
        except Boleta.DoesNotExist:
            return JsonResponse({"error": "Boleta no encontrada o ya confirmada"}, status=404)
    return JsonResponse({"error": "Método no permitido"}, status=405)
