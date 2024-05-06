sanitizers = document.getElementsByClassName("sanitizer");
modal = document.getElementById("sanitizer-modal");
modalTitle = document.getElementById("modal-title");
modalDescription = document.getElementById("modal-description");

SANITIZER = {
    ASAN: "La exploración de errores realizada intenta encontrar vulnerabilidades en las direcciones de memorias usadas por el simulador del simulador. \n\nPor ejemplo: use-after-free (UAF), null pointer deference buffer overruns, etc.",
    MSAN: "MSAN trata de encontrar lecturas a memorias no inicializadas.",
    UBSAN: "El objetivo de UBSAN es encontrar instancias donde se encuentren comportamientos no definidos por el programa.",
    CFISAN: "Su finalidad consiste en encontrar flujos de control probablementes ilegales, es decir, la detección de vulnerabilidades de confusión de tipos.",
    TSAN: "Su propósito es encontrar hilos de ejecución en el sistema que pueden ser manipulados por los atacantes.",
    NAN: "No se ha utilizado ningún sanitizer. Sus pruebas han seguido un flujo de exploración estándar de errores." 
}


for (var i = 0; i < sanitizers.length; i++) {
    sanitizers[i].addEventListener('click', linkClick, false);
}

function linkClick(event) {
    var target = event.target.innerHTML;
    modal.showModal();
    modalTitle.innerText = target == '-' ? 'No se ha encontrado uso de ningún sanitizer.' : "Información sobre: " + target + ".";
    modalDescription.innerText = SANITIZER[target == 'Estándar' ? 'NAN' : target.toUpperCase()];
}