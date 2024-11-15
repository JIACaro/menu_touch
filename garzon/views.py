from django.shortcuts import render
from pedidos.models import Pedido, PerfilUsuario  # Importa el modelo Pedido desde la aplicación de pedidos
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_exempt

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