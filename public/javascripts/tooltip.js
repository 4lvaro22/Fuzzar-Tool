const tooltips = document.getElementsByClassName("create-form-info");

const enumToolTip = {
    "info-name": "Nombre con el que se le va a identificar al perfil.",
    "info-direrrs": "Directorio relativo de la carpeta donde la herramienta almacena los errores.",
    "info-confcomp": "Comandos de la configuración con la que se va a compilar la aplicación bajo pruebas.",
    "info-pathsim": "Directorio raíz del simulador o directorio del fichero bajo pruebas (directorio absoluto).",
    "info-conffuzz": "Comandos de la configuración para la ejecución de la prueba fuzzing.",
    "info-sourcedata": "Fuente de los datos para los casos de pruebas iniciales a testear.",
    "info-descrip": "Descipción de la prueba que realiza el perfil fuzzing, se ruega que sea lo más descriptiva posible.",
    "info-time": "Tiempo máximo de ejecución del análisis."
}

for (const [key, value] of Object.entries(enumToolTip)) {
    new tippy('#'+key, {
        content: value,
        animation:'scale',
        theme:'light',
    });
}