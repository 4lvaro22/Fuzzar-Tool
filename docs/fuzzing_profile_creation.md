# Creación de perfil fuzzing
Lo siguiente describe como se deberá de realizar una creación del perfil fuzzing que se adapte al cada caso específico.

La creaciones de los perfiles consisten en diferentes configuraciones importantes:  
1. Nombre y descripción que definen la prueba que analiza el perfil.
2. Configuraciones específicas para la herramienta que desea utilizar.
3. Datos de entrada para los casos de prueba iniciales.

Sabiendo esto comenzamos con una explicación paso-a-paso de los diferentes campos disponibles para el usuario.

## Descripción de los campos

### 1. Nombre del perfil  
Nombre descriptivo y breve que se le quiere asignar al perfil fuzzing.  
 
Esta denominación va a consistir en la forma en la que se identifica a cada uno de los perfiles creado. Por lo tanto, será necesario que sea una denominación única para cada uno de ellos.  

### 2. Directorio de errores 
Esta información que debe proporcionar el usuario consiste en el directorio local y absoluto, donde la herramienta de fuzzing que se quiere utilizar crea los diferentes ficheros con los datos de entrada erróneos detectados.

Por ejemplo: 

- Herramienta AFLPlusPlus: a partir del directorio de ejecución y la carpeta elegida en ```/<carpeta_elegida>/default/crashes```  
- Herramienta HonggFuzz: en el directorio especificado por la ejecución  
- Herramienta clang con LibFuzzer: en el directorio donde se ejecuta el análisis

### 3. Configuración de compilación  
Esta configuración consiste en la forma que se va a compilar la aplicación, simulador o código que se quiere analizar.

Según la aplicación bajo pruebas deberá consistir en diferentes comandos a utilizar. Además, algunos fuzzer exigen una forma de compilar específica.

[Uso de sanitizers](https://github.com/4lvaro22/OBD-II-Fuzzer-Tool?tab=readme-ov-file#uso-de-ssanitizers)

Por ejemplo:  
- Herramienta AFLPlusPlus + Aplicación compilable con CMake: ```CC=afl-<compilador_seleccionado> CXX=afl-<compilador_seleccionado> ./configure --disable-shared```

> [!NOTE]
> Según la aplicación y fuzzer elegido puede que no sea necesario realizar una compilación específica o ni si quiera compilar el sistema bajo pruebas. Como por ejemplo con el fuzzer Radamsa.

### 4. Directorio raíz del simulador o fichero  
Consiste en el directorio absoluto en el que se encuentra el simulador o código para el testeo.  

Se deberá de proporcionar el directorio raíz (si se trata de un proyecto) o el directorio hacia el código (si se trata de un fichero).

### 5. Configuración del fuzzing
En este campo se deberá proporcionar la prueba fuzzing que se quiere realizar. 

> [!TIP]
> Comprobar como realizar las pruebas con la herramienta elegida.

### 6. Fuente de datos predeterminada  
Si se tiene un conjunto de datos utilizable por el fuzzer a usar, entonces deberá de seleccionar la opción ```No predeterminado```. 

> [!CAUTION]
> Los datos se deberán de incluir en un directorio llamado ```inputs``` en camino raíz de la herramienta Fuzzar. 

Si no se tienen los datos a priori y, se quiere analizar protocolos OBD-II o CAN Bus, la herramienta ofrece la posibilidad de crear los casos de pruebas iniciales automáticamente. Para el caso de CAN Bus será necesario crear con carácter previo una interfaz de red CAN de
la librería can-utils.

### 7. Descripción de la prueba  
Por último, pero no menos importante, se posibilita la opción de generar una descripción del análisis que realiza el perfil que se está creando.

## Uso de sanitizers
Una característica muy utilizada en las técnicas de análisis fuzzing son los demoninados sanitizers. Esta funcionalidad permite realizar análisis centrándose en diferentes puntos de ataques posiblemente vulnerables, algunos ejemplos son: corrupciones en memoria, accesos a memorias no inicializadas, comportamientos no definidos, ... .  

Por ello, Fuzzar Tool permite realizar estás pruebas orientadas a el programa bajo pruebas.  

Para llevar a cabo esta tarea será necesario tener conocimiento de como se definen para el fuzzer elegido y, proporcionar el comando o variable en el campo del formulario correcto.

Si se deben crear variables de entorno, podrás definir la variable en el campo destinado a la configuración del fuzzing.   

Por ejemplo: ```export <nombre_variable>=1; <configuración_del_fuzzing>```  

> [!WARNING]
> Pueden existir fuzzers que la especificación del sanitizer se defina en la configuración de la compilación.
