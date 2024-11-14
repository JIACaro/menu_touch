from django.apps import AppConfig


class CocinaConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'cocina'


class PedidosConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'pedidos'

    def ready(self):
        import pedidos.signals
