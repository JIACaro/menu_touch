from django.shortcuts import render, redirect, get_object_or_404
from .models import Producto, Pedido, PedidoProducto, PerfilUsuario
from django.contrib.auth import authenticate, login, logout
from django.core.serializers.json import DjangoJSONEncoder
from django.http import JsonResponse
import json
from .decorators import mesa_required
from django.views.decorators.csrf import csrf_exempt

# HOME
@mesa_required
def home(request):
    mesa_nombre = request.user.username if request.user.is_authenticated else "Desconocida"
    return render(request, 'home.html', {'mesa_nombre': mesa_nombre})

# LOGIN
def mesa_login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')

        # Autenticación del usuario
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)  # Iniciar sesión
            
            # Obtener el perfil del usuario
            perfil = PerfilUsuario.objects.filter(usuario=user).first()
            if perfil:
                # Redirigir según el rol del usuario
                if perfil.rol == 'admin':
                    return redirect('administrativo_dashboard')
                elif perfil.rol == 'garzon':
                    return redirect('gestion_pedidos')  
                elif perfil.rol == 'mesa':
                    return redirect('home')  
                elif perfil.rol == 'cocina':
                    return redirect('vista_cocina')  

            # Si no tiene un rol definido, redirigir a una página predeterminada
            return redirect('home')
        else:
            # Mostrar error si las credenciales son incorrectas
            return render(request, 'login.html', {'error': 'Credenciales incorrectas.'})

    return render(request, 'login.html')


# CATEGORIAS
@mesa_required
def categorias(request):
    categorias_disponibles = [
        {'nombre': 'Platos', 'imagen': '/media/platos.jpg'},
        {'nombre': 'Bebestibles', 'imagen': '/media/bebestibles.jpg'},
        {'nombre': 'Acompañamiento', 'imagen': '/media/acompañamiento.jpg'},
        {'nombre': 'Postres', 'imagen': '/media/postres.jpg'},
    ]

    context = {
        'categorias': categorias_disponibles,
        'mesa_nombre': request.user.username if request.user.is_authenticated else "Desconocida",
    }
    return render(request, 'categorias.html', context)

# MENU
@mesa_required
def menu(request):
    categoria = request.GET.get('categoria')
    if categoria:
        productos = Producto.objects.filter(categoria=categoria)
    else:
        productos = Producto.objects.all()

    return render(request, 'menu.html', {
        'productos': productos,
        'mesa_nombre': request.user.username if request.user.is_authenticated else "Desconocida",
        'categoria_seleccionada': categoria
    })

# AGREGAR PEDIDO

@csrf_exempt
def agregar_pedido(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body.decode('utf-8'))
            carrito = data.get('carrito', [])

            if not carrito:
                return JsonResponse({'error': 'El carrito está vacío'}, status=400)
            
            user = request.user
            if not user.is_authenticated:
                return JsonResponse({'error': 'Usuario no autenticado'}, status=401)

            pedido = Pedido.objects.create(mesa=user, total=0)
            total_pedido = 0

            for item in carrito:
                try:
                    producto = Producto.objects.get(id=item['id'])
                except Producto.DoesNotExist:
                    return JsonResponse({'error': f'Producto con ID {item["id"]} no existe'}, status=400)

                cantidad = item['cantidad']
                subtotal = producto.precio * cantidad
                total_pedido += subtotal

                PedidoProducto.objects.create(
                    pedido=pedido,
                    producto=producto,
                    cantidad=cantidad,
                    subtotal=subtotal
                )

            pedido.total = total_pedido
            pedido.save()

            return JsonResponse({'mensaje': 'Pedido agregado exitosamente', 'pedido_id': pedido.id})  # Devuelve el ID

        except Exception as e:
            return JsonResponse({'error': f'Error interno: {str(e)}'}, status=500)

    return JsonResponse({'error': 'Método no permitido'}, status=405)



# LOGOUT
def logout_view(request):
    logout(request)  # Cerrar sesión
    return redirect('mesa_login')  # Redirigir al login después del logout

# CARRITO
@mesa_required
def carrito(request):
    pedidos = Pedido.objects.filter(mesa=request.user).order_by('-id')
    historial_pedidos = [
        {
            "nombre": item.producto.nombre,
            "cantidad": item.cantidad,
            "subtotal": float(item.subtotal)
        }
        for pedido in pedidos for item in pedido.pedidoproducto_set.all()
    ]
    total_acumulado = sum(item["subtotal"] for item in historial_pedidos)

    context = {
        'historial_pedidos': json.dumps(historial_pedidos, cls=DjangoJSONEncoder),
        'total_acumulado': round(total_acumulado, 2)  # Redondea a 2 decimales
    }

    return render(request, 'carrito.html', context)

# AGREGAR AL CARRITO
@mesa_required
def agregar_al_carrito(request, producto_id):
    if request.method == 'GET':
        producto = get_object_or_404(Producto, id=producto_id)
        pedido, _ = Pedido.objects.get_or_create(mesa=request.user, total=0)

        pedido_producto, created = PedidoProducto.objects.get_or_create(
            pedido=pedido,
            producto=producto,
            defaults={'cantidad': 1, 'subtotal': producto.precio}
        )

        if not created:
            pedido_producto.cantidad += 1
            pedido_producto.subtotal = pedido_producto.cantidad * producto.precio
            pedido_producto.save()

        pedido.total = sum(item.subtotal for item in pedido.pedidoproducto_set.all())
        pedido.save()

        productos_en_carrito = pedido.pedidoproducto_set.all()
        carrito_items = [
            {"nombre": item.producto.nombre, "cantidad": item.cantidad, "subtotal": float(item.subtotal)}
            for item in productos_en_carrito
        ]
        total = float(pedido.total)

        return JsonResponse({"carrito_items": carrito_items, "total": total, "carrito_count": productos_en_carrito.count()})
    else:
        return JsonResponse({"error": "Método no permitido"}, status=405)

# DISMINUIR CANTIDAD EN EL CARRITO
@mesa_required
def disminuir_cantidad(request, producto_id):
    pedido = Pedido.objects.get(mesa=request.user)
    pedido_producto = get_object_or_404(PedidoProducto, pedido=pedido, producto_id=producto_id)

    if pedido_producto.cantidad > 1:
        pedido_producto.cantidad -= 1
        pedido_producto.subtotal = pedido_producto.cantidad * pedido_producto.producto.precio
        pedido_producto.save()
    else:
        pedido_producto.delete()

    return _actualizar_respuesta_carrito(pedido)

# ELIMINAR DEL CARRITO
def eliminar_del_carrito(request, producto_id):
    pedido = Pedido.objects.get(mesa=request.user)
    pedido_producto = get_object_or_404(PedidoProducto, pedido=pedido, producto_id=producto_id)
    pedido_producto.delete()

    return _actualizar_respuesta_carrito(pedido)

# FUNCIÓN AUXILIAR PARA ACTUALIZAR EL CARRITO
def _actualizar_respuesta_carrito(pedido):
    productos_en_carrito = pedido.pedidoproducto_set.all()
    carrito_items = [
        {
            "id": item.producto.id,
            "nombre": item.producto.nombre,
            "cantidad": item.cantidad,
            "subtotal": float(item.subtotal),
        }
        for item in productos_en_carrito
    ]
    total = float(pedido.total)

    return JsonResponse({
        "carrito_items": carrito_items,
        "total": total,
        "carrito_count": productos_en_carrito.count()
    })

#FINALIZAR PEDIDO 


@csrf_exempt
@mesa_required
def finalizar_pedido(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body.decode('utf-8'))
            print("Datos recibidos en finalizar_pedido:", data)  # Debug log

            pedido_id = data.get('pedido_id')
            if not pedido_id:
                return JsonResponse({'error': 'No se proporcionó un ID de pedido'}, status=400)

            pedido = get_object_or_404(Pedido, id=pedido_id)
            pedido.estado = 'PAGAR'
            pedido.save()

            return JsonResponse({'mensaje': f'Pedido {pedido_id} actualizado a estado PAGAR correctamente'})
        except Exception as e:
            print(f"Error en finalizar_pedido: {e}")
            return JsonResponse({'error': f'Error interno: {str(e)}'}, status=500)
    return JsonResponse({'error': 'Método no permitido'}, status=405)

@mesa_required
def pagando(request):
    # Renderizar la página de pago
    return render(request, 'pagando.html', {})
