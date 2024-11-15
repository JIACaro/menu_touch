from django.http import HttpResponseForbidden
from pedidos.models import PerfilUsuario

def cocina_required(view_func):
    def _wrapped_view(request, *args, **kwargs):
        # Verificar si el usuario está autenticado
        if not request.user.is_authenticated:
            return HttpResponseForbidden("No tienes permisos para acceder a esta página.")

        # Verificar el rol del usuario
        perfil = PerfilUsuario.objects.filter(usuario=request.user).first()
        if perfil and perfil.rol == 'cocina':
            return view_func(request, *args, **kwargs)

        return HttpResponseForbidden("No tienes permisos para acceder a esta página.")
    return _wrapped_view
