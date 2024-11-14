document.addEventListener('DOMContentLoaded', function () {
    // Función para refrescar la vista automáticamente cada 10 segundos
    function autoRefresh() {
        setInterval(() => {
            location.reload();
        }, 10000); // Refresca cada 10 segundos
    }

    // Función para cambiar el estado de un pedido
    function cambiarEstadoPedido(pedidoId) {
        fetch(`http://127.0.0.1:8000/garzon/cambiar-estado-pedido/${pedidoId}/`, {
            method: 'POST',
            headers: {
                'X-CSRFToken': getCSRFToken(),
                'Content-Type': 'application/json',
            },
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Error en la respuesta de la red');
                }
                return response.json();
            })
            .then((data) => {
                if (data.success) {
                    // Recargar para reflejar los cambios
                    location.reload();
                } else {
                    console.error('Error al cambiar el estado del pedido:', data.error);
                }
            })
            .catch((error) => {
                console.error('Error en la solicitud:', error);
            });
    }

    // Función para obtener el token CSRF
    function getCSRFToken() {
        const cookieValue = document.cookie
            .split('; ')
            .find((row) => row.startsWith('csrftoken='))
            ?.split('=')[1];
        return cookieValue || '';
    }

    // Escuchar eventos de clic en los botones de las mesas (si los hay)
    document.querySelectorAll('.mesa').forEach((mesa) => {
        mesa.addEventListener('click', function () {
            const pedidoId = this.getAttribute('data-pedido-id'); // Obtener ID del pedido de un atributo personalizado
            if (pedidoId) {
                cambiarEstadoPedido(pedidoId);
            }
        });
    });

    // Inicializar el auto-refresh
    autoRefresh();
});
