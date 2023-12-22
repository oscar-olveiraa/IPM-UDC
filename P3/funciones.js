function agregarTarea2() {
    var nombreTarea = document.getElementById('nombreTarea').value;
    var descripcionBreve = document.getElementById('descripcionBreve').value;
    var fechaLimite = document.getElementById('fechaLimite').value;
    var descripcionLarga = document.getElementById('descripcionLarga').value;
    
    var tareasGuardadas = JSON.parse(localStorage.getItem('tareas')) || [];
    
    var nuevaTarea = {
        nombre: nombreTarea,
        descripcionBreve: descripcionBreve,
        fechaLimite: fechaLimite,
        descripcionLarga: descripcionLarga
    };
    
    tareasGuardadas.push(nuevaTarea);
    
    localStorage.setItem('tareas', JSON.stringify(tareasGuardadas));
    
    cerrarPopUp();

    mostrarTareasEnPagina(tareasGuardadas);   
}
    
function mostrarTareasEnPagina(tareas) {
    var listaTareas = document.getElementById('contenedor_lista');
    
    listaTareas.innerHTML = '';
    
    tareas.forEach(function(tarea, indice) {

        var nuevoContenedor = document.createElement('div');
        nuevoContenedor.className = 'container';
        nuevoContenedor.setAttribute('role', 'listitem')
        nuevoContenedor.innerHTML = `
        <div class="container_fotos">
            <img src="imagenes/cuadrado.png" aria-label= alt="Marcar tarea como completada" role="img" title="Marcar tarea como completada">
        </div>
        <div class="nombre_tarea">
            <p aria-label="Nombre de la tarea">${tarea.nombre}</p>
        </div>
        <div class="container_fotos">
            <img src="imagenes/editar.jpeg" aria-label="Editar una tarea" alt="Editar Image" role="img" title="Editar descripcion de esta tarea">
        </div>
        <div class="container_fotos">
            <button class="boton_borrar" role="button" onclick="eliminarTarea(${indice})">
                <img src="imagenes/quitar.jpeg" aria-label="Borrar esta tarea" alt="Quitar Image" role="img" title="Eliminar esta tarea">
            </button>
        </div>`;

        var nuevoContenedor2 = document.createElement('div');
        nuevoContenedor2.className = 'container_info';
        nuevoContenedor2.setAttribute('role', 'listitem')
        nuevoContenedor2.innerHTML = `
            <p>   
                <div class="fecha" aria-label="Fecha limite de la tarea">${tarea.fechaLimite}</div>
                <div class="descripcion" aria-label="Descripcion breve de la tarea">${tarea.descripcionBreve}</div>
            </p>
            <div class="descripcionLarga">
                <p aria-label="Descripcion larga de la tarea">${tarea.descripcionLarga}</p>
            </div>
            <hr class="linea_divisoria">`;
        listaTareas.appendChild(nuevoContenedor);
        listaTareas.appendChild(nuevoContenedor2)
    });
}

function eliminarTarea(indice) {
    var tareasGuardadas = JSON.parse(localStorage.getItem('tareas')) || [];

    tareasGuardadas.splice(indice, 1);

    localStorage.setItem('tareas', JSON.stringify(tareasGuardadas));

    mostrarTareasEnPagina(tareasGuardadas);
}
  
document.addEventListener('DOMContentLoaded', function() {
    var tareasGuardadas = JSON.parse(localStorage.getItem('tareas')) || [];

    mostrarTareasEnPagina(tareasGuardadas);
});

function mostrarPopUp() {  
    document.getElementById("popup-container").style.display = "block";
    document.getElementById("overlay").style.display = "block";
  }

  function cerrarPopUp() {
    document.getElementById("popup-container").style.display = "none";
    document.getElementById("overlay").style.display = "none";
  }
