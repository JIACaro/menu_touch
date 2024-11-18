// Variables globales
let carrito = {};
let historialPedidos = []; // Almacena los pedidos realizados
let totalAcumulado = 0; // Monto acumulado de todos los pedidos

// Generar o cargar el ID de sesión desde las cookies
function setSessionCookie() {
    const sessionId = `mesa-${Math.random().toString(36).substr(2, 9)}`; // ID único
    document.cookie = `sessionId=${sessionId}; path=/; max-age=${60 * 60 * 24}`; // 1 día de duración
    return sessionId;
}

//cerrar sesion
function cerrarSesion() {
    console.log("Cerrando sesión para la sesión actual:", sessionId);

    limpiarCacheMesa(); // Llama a la función para limpiar todos los datos

    // Redirigir al usuario al inicio de sesión
    window.location.href = "/mesa_login/";
}


function getSessionCookie() {
    const cookies = document.cookie.split(';');
    for (let cookie of cookies) {
        const [name, value] = cookie.trim().split('=');
        if (name === 'sessionId') return value;
    }
    return null;
}

const sessionId = getSessionCookie() || setSessionCookie();
console.log("ID de sesión actual:", sessionId);

// Guardar el carrito en cookies
function guardarCarritoEnCookies() {
    const carritoKey = `carrito-${sessionId}`;
    document.cookie = `${carritoKey}=${JSON.stringify(carrito)}; path=/; max-age=${60 * 60 * 24}`;
    console.log(`Carrito guardado en cookies para la sesión ${sessionId}:`, carrito);
}


// Cargar el carrito desde cookies
function cargarCarritoDesdeCookies() {
    const carritoKey = `carrito-${sessionId}`;
    const cookies = document.cookie.split(';');

    for (let cookie of cookies) {
        const [name, value] = cookie.trim().split('=');
        if (name === carritoKey) {
            try {
                carrito = JSON.parse(decodeURIComponent(value));
                console.log(`Carrito cargado para la sesión ${sessionId}:`, carrito);
                return;
            } catch (e) {
                console.error("Error al parsear el carrito desde cookies:", e);
            }
        }
    }

    carrito = {}; // Iniciar un carrito vacío si no se encuentra uno
    console.log(`Carrito inicializado para la sesión ${sessionId}.`);
}


// Funciones existentes adaptadas
function agregarAlCarrito(productoId) {
    if (carrito[productoId]) {
        carrito[productoId].cantidad += 1;
    } else {
        const nombre = document.querySelector(`[data-id="${productoId}"] .card-title`).textContent;
        const precio = parseInt(document.querySelector(`[data-id="${productoId}"] .price`).textContent.replace('$', ''), 10);
        carrito[productoId] = { nombre, precio, cantidad: 1 };
    }
    actualizarCarrito();
    guardarCarritoEnCookies();
}

function eliminarDelCarrito(productoId) {
    if (carrito[productoId]) {
        carrito[productoId].cantidad -= 1;
        if (carrito[productoId].cantidad === 0) {
            delete carrito[productoId];
        }
    }
    actualizarCarrito();
    guardarCarritoEnCookies();
}

function actualizarCarrito() {
    console.log("Ejecutando actualizarCarrito...");

    const cartItems = document.getElementById("cart-items");
    const cartTotal = document.getElementById("cart-total");
    const cartCount = document.getElementById("cart-count");

    if (!cartItems || !cartTotal || !cartCount) {
        console.warn("Elementos del carrito no encontrados en esta página.");
        return;
    }

    cartItems.innerHTML = '';
    let total = 0;
    let count = 0;

    for (const id in carrito) {
        const item = carrito[id];
        total += item.precio * item.cantidad;
        count += item.cantidad;

        cartItems.innerHTML += `
            <div class="d-flex justify-content-between align-items-center">
                <span>${item.nombre} (${item.cantidad})</span>
                <span>$${(item.precio * item.cantidad).toLocaleString('es-CL')}</span>
                <button class="btn btn-sm btn-danger" onclick="eliminarDelCarrito(${id})">X</button>
            </div>
        `;
    }

    cartTotal.textContent = `$${total.toLocaleString('es-CL')}`;
    cartCount.textContent = count;

    if (count === 0) {
        cartItems.innerHTML = '<p class="text-center">Tu carrito está vacío.</p>';
    }

    guardarCarritoEnCookies();
}


// Función para procesar el pedido
function agregarPedido() {
    console.log("Ejecutando agregarPedido...");

    // Verificar que el carrito no esté vacío
    if (!carrito || Object.keys(carrito).length === 0) {
        alert("El carrito está vacío. Agrega productos antes de solicitar un pedido.");
        return;
    }

    // Preparar los datos para enviar al servidor
    const carritoArray = Object.keys(carrito).map((id) => ({
        id,
        nombre: carrito[id].nombre,
        cantidad: carrito[id].cantidad,
        subtotal: carrito[id].precio * carrito[id].cantidad,
    }));
    const data = { carrito: carritoArray };

    console.log("Enviando pedido al servidor:", data);

    // Enviar el pedido al servidor
    fetch('/agregar-pedido/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': document.querySelector('[name=csrfmiddlewaretoken]').value,
        },
        body: JSON.stringify(data),
    })
        .then((response) => response.json())
        .then((result) => {
            if (result.error) {
                alert(`Error: ${result.error}`);
                return;
            }

            const pedidoId = result.pedido_id; // Recibir el ID del servidor
            console.log("Pedido guardado con ID:", pedidoId);

            // Crear el objeto del nuevo pedido
            const nuevoPedido = {
                id: pedidoId,
                productos: carritoArray,
                fecha: new Date().toLocaleString(),
            };

            // Guardar el pedido en el historial del cliente
            const historialKey = `historial-${sessionId}`;
            let pedidosRealizados = JSON.parse(sessionStorage.getItem(historialKey) || "[]");
            pedidosRealizados.push(nuevoPedido);
            sessionStorage.setItem(historialKey, JSON.stringify(pedidosRealizados));

            console.log(`Historial actualizado para la sesión ${sessionId}:`, pedidosRealizados);

            // Limpia el carrito tras realizar el pedido
            carrito = {};
            guardarCarritoEnCookies();
            actualizarCarrito();

            alert("Pedido solicitado con éxito.");
            window.location.href = "/carrito/";
        })
        .catch((error) => {
            console.error("Error al enviar el pedido al servidor:", error);
            alert("Ocurrió un error al enviar el pedido. Por favor, intenta nuevamente.");
        });
}


function mostrarHistorialPedidos() {
    console.log("Ejecutando mostrarHistorialPedidos...");

    const historialKey = `historial-${sessionId}`;
    const pedidosRealizados = JSON.parse(sessionStorage.getItem(historialKey) || "[]");
    const contenedorHistorial = document.getElementById("pedidos-realizados");
    const totalAcumuladoElem = document.getElementById("total-acumulado");

    if (!contenedorHistorial || !totalAcumuladoElem) {
        console.error("No se encontraron los elementos 'pedidos-realizados' o 'total-acumulado' en carrito.html.");
        return;
    }

    contenedorHistorial.innerHTML = "";
    let totalAcumulado = 0;

    if (pedidosRealizados.length === 0) {
        contenedorHistorial.innerHTML = "<p class='text-center text-muted'>No hay pedidos realizados.</p>";
        totalAcumuladoElem.textContent = "Total acumulado: $0";
        return;
    }

    pedidosRealizados.forEach((pedido) => {
        const pedidoHTML = `
            <div class="pedido">
                <p><strong>Pedido #${pedido.id}</strong> - ${pedido.fecha}</p>
                <ul>
                    ${pedido.productos
                        .map(
                            (prod) =>
                                `<li>${prod.nombre} (${prod.cantidad}) - $${prod.subtotal.toLocaleString("es-CL")}</li>`
                        )
                        .join("")}
                </ul>
            </div>
            <hr>
        `;
        contenedorHistorial.innerHTML += pedidoHTML;
        totalAcumulado += pedido.productos.reduce((sum, prod) => sum + prod.subtotal, 0);
    });

    totalAcumuladoElem.textContent = `Total acumulado: $${totalAcumulado.toLocaleString("es-CL")}`;
    console.log(`Historial renderizado para la sesión ${sessionId}:`, pedidosRealizados);
}


function guardarHistorialEnLocalStorage() {
    localStorage.setItem('historialPedidos', JSON.stringify(historialPedidos));
    localStorage.setItem('totalAcumulado', totalAcumulado.toString());
}

function cargarHistorialDesdeLocalStorage() {
    const historialGuardado = localStorage.getItem('historialPedidos');
    const totalGuardado = localStorage.getItem('totalAcumulado');
    
    historialPedidos = historialGuardado ? JSON.parse(historialGuardado) : [];
    totalAcumulado = totalGuardado ? parseFloat(totalGuardado) : 0;
}


function mostrarCarritoEnResumen() {
    const detallesCarrito = document.getElementById('detalles-carrito');
    const totalCarrito = document.getElementById('total-pagar');
    detallesCarrito.innerHTML = '';

    // Verifica si el carrito tiene productos
    if (!carrito || Object.keys(carrito).length === 0) {
        detallesCarrito.innerHTML = '<p class="text-center">Tu carrito está vacío.</p>';
        totalCarrito.textContent = '$0';
        return;
    }

    // Mostrar productos del carrito
    let total = 0;
    for (const id in carrito) {
        const item = carrito[id];
        total += item.precio * item.cantidad;

        detallesCarrito.innerHTML += `
            <div class="d-flex justify-content-between align-items-center border-bottom py-2">
                <span>${item.nombre} (${item.cantidad})</span>
                <span>$${(item.precio * item.cantidad).toLocaleString('es-CL')}</span>
            </div>`;
    }

    // Actualizar el total
    totalCarrito.textContent = `$${total.toLocaleString('es-CL')}`;
}

//aca

// Función para cargar y mostrar el historial de pedidos en carrito.html
function mostrarHistorialEnCarrito(historialPedidos, totalAcumulado) {
    const contenedor = document.getElementById('pedidos-realizados');
    const totalContainer = document.getElementById('total-acumulado');

    if (!contenedor || !totalContainer) {
        console.error("Contenedores no encontrados en carrito.html");
        return;
    }

    contenedor.innerHTML = '';
    historialPedidos.forEach(item => {
        contenedor.innerHTML += `
            <div class="d-flex justify-content-between">
                <span>${item.nombre} (${item.cantidad})</span>
                <span>$${item.subtotal.toLocaleString('es-CL')}</span>
            </div>
        `;
    });

    totalContainer.textContent = `Total acumulado: $${totalAcumulado.toLocaleString('es-CL')}`;
}
// ola
function renderizarPedidos(historialPedidos, totalAcumulado) {
    const contenedorPedidos = document.getElementById("pedidos-realizados");
    const contenedorTotal = document.getElementById("total-acumulado");

    if (!contenedorPedidos || !contenedorTotal) {
        console.error("No se encontraron contenedores para renderizar los pedidos.");
        return;
    }

    contenedorPedidos.innerHTML = ""; // Limpia el contenido existente

    historialPedidos.forEach((pedido) => {
        const pedidoHTML = `
            <div class="d-flex justify-content-between border-bottom pb-2 mb-2">
                <span>${pedido.nombre} (x${pedido.cantidad})</span>
                <span>$${pedido.subtotal.toLocaleString("es-CL")}</span>
            </div>
        `;
        contenedorPedidos.innerHTML += pedidoHTML;
    });

    contenedorTotal.textContent = `Total acumulado: $${totalAcumulado.toLocaleString("es-CL")}`;
}


function inicializarCarrito() {
    console.log("Inicializando carrito.html...");

    // Cargar historial de pedidos desde localStorage
    const historialCarrito = JSON.parse(localStorage.getItem("pedidosRealizados") || "[]");
    const totalCarrito = historialCarrito.reduce(
        (total, pedido) => total + pedido.productos.reduce((subtotal, prod) => subtotal + prod.subtotal, 0),
        0
    );

    console.log("Historial cargado en carrito.html:", historialCarrito);
    console.log("Total acumulado:", totalCarrito);

    // Renderizar historial de pedidos
    const contenedorHistorial = document.getElementById("pedidos-realizados");
    const totalAcumuladoElem = document.getElementById("total-acumulado");

    if (!contenedorHistorial || !totalAcumuladoElem) {
        console.error("No se encontraron los elementos 'pedidos-realizados' o 'total-acumulado' en carrito.html.");
        return;
    }

    contenedorHistorial.innerHTML = "";
    if (historialCarrito.length === 0) {
        contenedorHistorial.innerHTML = "<p class='text-center text-muted'>No hay pedidos realizados.</p>";
        totalAcumuladoElem.textContent = "Total acumulado: $0";
        return;
    }

    historialCarrito.forEach((pedido) => {
        const pedidoHTML = `
            <div class="pedido">
                <p><strong>Pedido #${pedido.id}</strong> - ${pedido.fecha}</p>
                <ul>
                    ${pedido.productos
                        .map(
                            (prod) =>
                                `<li>${prod.nombre} (${prod.cantidad}) - $${prod.subtotal.toLocaleString("es-CL")}</li>`
                        )
                        .join("")}
                </ul>
            </div>
            <hr>
        `;
        contenedorHistorial.innerHTML += pedidoHTML;
    });

    totalAcumuladoElem.textContent = `Total acumulado: $${totalCarrito.toLocaleString("es-CL")}`;
}


function renderizarCarrito(historial, total) {
    const contenedorPedidos = document.getElementById("pedidos-realizados");
    const contenedorTotal = document.getElementById("total-acumulado");

    // Verifica si los contenedores existen
    if (!contenedorPedidos) {
        console.error("No se encontró el contenedor 'pedidos-realizados'. Asegúrate de que el ID exista en el HTML.");
        return;
    }

    if (!contenedorTotal) {
        console.error("No se encontró el contenedor 'total-acumulado'. Asegúrate de que el ID exista en el HTML.");
        return;
    }

    // Limpia el contenido anterior
    contenedorPedidos.innerHTML = "";
    historial.forEach((pedido) => {
        const pedidoHTML = `
            <div class="d-flex justify-content-between">
                <span>${pedido.nombre} (${pedido.cantidad})</span>
                <span>$${pedido.subtotal.toLocaleString()}</span>
            </div>`;
        contenedorPedidos.innerHTML += pedidoHTML;
    });

    // Actualiza el total
    contenedorTotal.textContent = `Total acumulado: $${total.toLocaleString()}`;
    console.log("Renderizado completo en carrito.html.");
}


function solicitarPedido() {
    // Obtener carrito actual y pedidos realizados
    const carritoActual = JSON.parse(localStorage.getItem("carritoActual") || "[]");
    const pedidosRealizados = JSON.parse(localStorage.getItem("pedidosRealizados") || "[]");

    if (carritoActual.length === 0) {
        alert("No hay productos en el carrito para solicitar.");
        return;
    }

    // Transferir carrito actual a pedidos realizados
    const nuevoPedido = {
        id: Date.now(), // Genera un identificador único
        productos: carritoActual,
        fecha: new Date().toLocaleString(),
    };
    pedidosRealizados.push(nuevoPedido);

    // Guardar en localStorage
    localStorage.setItem("pedidosRealizados", JSON.stringify(pedidosRealizados));

    // Limpiar carrito actual
    localStorage.setItem("carritoActual", "[]");

    // Actualizar la visualización
    alert("Pedido solicitado con éxito.");
    actualizarCarrito(); // Limpia el carrito visible
    mostrarHistorialPedidos(); // Actualiza el historial
}


// Función para mostrar historial vacío
function mostrarHistorialVacio() {
    const contenedor = document.getElementById('pedidos-realizados');
    const totalElemento = document.getElementById('total-acumulado');
    if (contenedor) contenedor.innerHTML = '<p class="text-center">No hay pedidos realizados.</p>';
    if (totalElemento) totalElemento.textContent = 'Total acumulado: $0';
}

// FINALIZAR PEDIDO
function finalizarPedido() {
    console.log("Finalizando el pedido...");

    const csrfTokenElem = document.querySelector('[name=csrfmiddlewaretoken]');
    if (!csrfTokenElem) {
        console.error("Token CSRF no encontrado. Asegúrate de que esté incluido en el HTML.");
        alert("No se puede completar la acción debido a un error de seguridad.");
        return;
    }

    const csrfToken = csrfTokenElem.value;

    const historialKey = `historial-${sessionId}`;
    let pedidosRealizados = JSON.parse(sessionStorage.getItem(historialKey) || "[]");
    console.log("Historial de pedidos cargado:", pedidosRealizados);

    if (!pedidosRealizados || pedidosRealizados.length === 0) {
        alert("No hay pedidos para finalizar.");
        return;
    }

    const ultimoPedido = pedidosRealizados[pedidosRealizados.length - 1];
    if (!ultimoPedido || !ultimoPedido.id) {
        alert("No se pudo encontrar un pedido válido para finalizar.");
        console.log("Último pedido no válido:", ultimoPedido);
        return;
    }

    console.log("Último pedido seleccionado:", ultimoPedido);

    fetch('/finalizar_pedido/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrfToken,
        },
        body: JSON.stringify({ pedido_id: ultimoPedido.id }),
    })
    .then((response) => response.json())
    .then((result) => {
        if (result.error) {
            alert(`Error: ${result.error}`);
            return;
        }
        console.log(result.mensaje);

        // Limpia el caché de la mesa
        limpiarCacheMesa();

        // Redirigir a la página de confirmación
        window.location.href = "/pagando/";
    })
    .catch((error) => {
        console.error("Error al finalizar el pedido:", error);
        alert("Ocurrió un error al finalizar el pedido. Por favor, intenta nuevamente.");
    });
}

//LIMPIAR CACHE MESA
function limpiarCacheMesa() {
    console.log("Limpiando caché de la mesa...");

    // Eliminar carrito y historial específicos de la sesión
    const carritoKey = `carrito-${sessionId}`;
    const historialKey = `historial-${sessionId}`;

    // Borra las cookies con diferentes configuraciones de path
    document.cookie = `${carritoKey}=; path=/; max-age=0`;
    document.cookie = `${carritoKey}=; path=/carrito; max-age=0`;
    document.cookie = `${historialKey}=; path=/; max-age=0`;
    document.cookie = `${historialKey}=; path=/carrito; max-age=0`;

    // Limpia el sessionStorage
    sessionStorage.removeItem(carritoKey);
    sessionStorage.removeItem(historialKey);

    // Limpia el localStorage relacionado con el carrito o historial
    localStorage.removeItem('carritoActual');
    localStorage.removeItem('pedidosRealizados');

    console.log("Caché de la mesa limpiado.");
}


// ACA ESTA EL DOM

document.addEventListener("DOMContentLoaded", function () {
    const page = document.body.getAttribute("data-page");

    console.log(`Página actual: ${page}`);
    cargarCarritoDesdeCookies(); // Cargar el carrito al inicio

    switch (page) {
        case "base":
            mostrarHistorialPedidos();
            actualizarCarrito();
            break;
        case "carrito-page":
            inicializarCarrito();
            mostrarHistorialPedidos();
            
            break;
        default:
            console.warn("Página desconocida. No se ejecutaron inicializaciones específicas.");
    }
});