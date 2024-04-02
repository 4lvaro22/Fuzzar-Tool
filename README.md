# OBD-II-Fuzzer-Tool  
Este repositorio está centrado para realizar la asignatura Trabajo Fin de Grado (TFG) de Ingeniería del Software en la Universidad de Málaga. 

## Autor  
Álvaro Portales Luna [[Github]](https://github.com/4lvaro22) [[LinkedIn]](https://www.linkedin.com/in/alvaro-portales-luna/)

## Tutores  
- Antonio Jesús Muñoz Gallego
- Rubén Ríos del Pozo

## Introducción  
El TFG consiste en el estudio de vulnerabilidades en el entorno vehicular. Como ya sabemos, los vehículos son máquinas esenciales en nuestra vida diaria, pero tras ellos no solo existen mecanismos para que sea un objeto funcional, sino que éstos cuentan con un gran números de dispositivos electrónicos cuyas vulnerabilidades pueden ser aprovechadas por atacantes.  
  
El protocolo a estudiar consiste en el sistema OBD-II. Con nacimiento entorno al 1990, es un sistema dedicado al mantenimiento y control del vehiculo. Puede aportar gran cantidad de información importante y valiosa, además de realizar una monitorización de fallos del sistema. Desde su obligatoriedad en EE.UU sobre el 1996, se ha extendido su uso sobre los diferentes estados del mundo como en Europa o Asia (aunque se usan variantes del mismo).  

Por otra parte, la técnica a utilizar se concentraría en el fuzzing. Esta técnica consiste en el envío inteligente o aleatorios de mensajes para controlar comportamientos erróneos del sistema que se esté probando.

La intención es realizar estos ataques sobre OBD-II para comprobar si se pueden detectar brechas de seguridad.

## Descripción del repositorio  
- El script [app.sh](/app.sh) consiste en la aplicación automatizada de las pruebas realizadas sobre el protocolo. Aporta diferente información valiosa, durante la ejecuicón y post-ejecución, al ususario.
- La carpeta [inputs](/inputs) contiene una serie de ficheros que se van a utilizar para realizar los diferentes análisis o ataques al sistema simulado.

> [!WARNING]
> El análisis solamente funciona para simuladores de OBD-II desarrollados en los lenguajes C/C++.

## Dependencias
- Herramienta [AFLPlusPlus](https://github.com/AFLplusplus/AFLplusplus/tree/stable)

## Cómo empezar  

1. Instalar [dependencias](https://github.com/4lvaro22/OBD-II-Fuzzer-Tool?tab=readme-ov-file#dependencias)
2. Clonar el repositorio
```
git clone https://github.com/4lvaro22/OBD-II-Fuzzer-Tool.git
```
3. Ejecutar el bash script
```
sudo bash app.sh
```
4. Disfrutar del fuzzing !!

## Referencias  
- AFLPlusplus: https://github.com/AFLplusplus/AFLplusplus
