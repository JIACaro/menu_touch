from django.shortcuts import render



def gestion_pedidos(request):
    return render(request, 'garzon/gestion_pedidos.html')
