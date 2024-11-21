document.addEventListener('DOMContentLoaded', function() {
    // Actualizar el reloj
    function updateClock() {
        const clockElement = document.getElementById('clock');
        if (clockElement) {
            const now = new Date();
            const hours = now.getHours().toString().padStart(2, '0');
            const minutes = now.getMinutes().toString().padStart(2, '0');
            const period = hours >= 12 ? 'P.M' : 'A.M';
            clockElement.textContent = `${hours}:${minutes} ${period}`;
        }
    }
    setInterval(updateClock, 1000);
    updateClock();

    // Manejo de botones para cambiar el estado de los pedidos
    document.querySelectorAll('.check-button').forEach(button => {
        button.addEventListener('click', function() {
            const orderId = this.getAttribute('data-order-id');
            console.log("Order ID:", orderId);
            console.log("CSRF Token:", getCSRFToken());

            fetch(`http://127.0.0.1:8000/garzon/cambiar-estado-pedido/${orderId}/`, { // URL de Garzón
                method: 'POST',
                headers: {
                    'X-CSRFToken': getCSRFToken(),
                    'Content-Type': 'application/json',
                }
            })
            .then(response => {
                if (response.headers.get("content-type") && response.headers.get("content-type").includes("text/html")) {
                    return response.text().then(html => {
                        console.error("Unexpected HTML response:", html);
                        throw new Error("Received HTML instead of JSON.");
                    });
                }
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    // Recargar la página automáticamente
                    location.reload();
                } else {
                    console.error('Error:', data.error);
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        });
    });

    // Obtener el token CSRF
    function getCSRFToken() {
        const token = document.cookie.split(';').find(row => row.trim().startsWith('csrftoken='));
        return token ? token.split('=')[1] : null;
    }

    // Refrescar la página automáticamente cada 5 segundos
    setInterval(function() {
        console.log("Intentando refrescar la página...");
        location.reload();
    }, 5000);
    
});
