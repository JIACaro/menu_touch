from django.shortcuts import redirect
from django.conf import settings

class CheckLoginMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Verificar si el usuario no está autenticado
        if not request.user.is_authenticated and request.path != settings.LOGIN_URL:
            # Redirigir al login si el usuario no está autenticado y no está en la página de login
            return redirect(settings.LOGIN_URL)

        # Continuar con la respuesta normal
        response = self.get_response(request)
        return response