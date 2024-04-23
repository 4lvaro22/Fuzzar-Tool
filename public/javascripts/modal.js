sanitizers = document.getElementsByClassName("sanitizer");
modal = document.getElementById("sanitizer-modal");
modalTitle = document.getElementById("modal-title");
modalDescription = document.getElementById("modal-description");

SANITIZER = {
    ASAN: "La exploración de errores realizada intenta encontrar vulnerabilidades en las direcciones de memorias usadas por el simulador del simulador. Como port ejemplo: use-after-free (UAF), null pointer deference buffer overruns, etc.",
    MSAN: "MSAN trata de encontrar lecturas a memorias no inicializadas.",
    UBSAN: "El objetivo de UBSAN es encontrar instancias donde se encuentren comportamientos no definidos por el programa.",
    CFISAN: "Su finalidad consiste en encontrar flujos de control probablementes ilegales, es decir, la detección de vulnerabilidades de confusión de tipos.",
    TSAN: "Su propósito es encontrar hilos de ejecución en el sistema que pueden ser manipulados por los atacantes.",
    NAN: "No se ha utilizado ningún sanitizer. Sus pruebas han seguido un flujo de exploración de errores estándar." 
}


for (var i = 0; i < sanitizers.length; i++) {
    console.log("target");
    sanitizers[i].addEventListener('click', linkClick, false);
}

function linkClick(event) {
    var target = event.target.innerHTML;
    console.log(target);
    modal.setAttribute("open", "");
    modalTitle.innerText = target == '-' ? 'No se ha encontrado uso de ningún sanitizer.' : "Información sobre: " + target + ".";
    modalDescription.innerText = SANITIZER[target == '-' ? 'NAN' : target.toUpperCase()];
}