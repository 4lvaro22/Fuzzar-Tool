# Fuzzar Tool  
<img src="./public/images/logo.png">



Este repositorio está centrado para realizar la asignatura Trabajo Fin de Grado (TFG) de Ingeniería del Software en la Universidad de Málaga. 

Repositorio: https://github.com/4lvaro22/Fuzzar-Tool  
Versión:  ```1.0.0```  
Fecha de creación de la herramienta: Mayo 2024 

## Autor  
Álvaro Portales Luna pl.alvaro43@gmail.com  
  
<a href="https://github.com/4lvaro22"><img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white"></a>
<a href="https://www.linkedin.com/in/alvaro-portales-luna/"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"></a>  

## Tutores  
- Antonio Jesús Muñoz Gallego
- Rubén Ríos del Pozo

A mis tutores les expreso mi más enorme agradecimiento por el gran apoyo y la confianza que han tenido desde el inicio de este proyecto. Sin sus guías no hubiera sido posible la realización de este TFG.

Además, quiero agradecer el gran impulso que me han brindado para adentrarme en el mundo de la ciberseguridad, el cual está siendo un campo de estudio que me llena de entusiasmo e interés.

Enormemente agradecido con vosotros!

## Introducción del Trabajo de Fin de Grado
El TFG consiste en el estudio de vulnerabilidades en el entorno vehicular. Como ya sabemos, los vehículos son máquinas esenciales en nuestra vida diaria, pero tras ellos no solo existen mecanismos para que sea un objeto funcional, sino que éstos cuentan con un gran números de dispositivos electrónicos cuyas vulnerabilidades pueden ser aprovechadas por atacantes.  
  
El protocolo a estudiar consiste en el sistema OBD-II. Con nacimiento entorno al 1990, es un sistema dedicado al mantenimiento y control del vehiculo. Puede aportar gran cantidad de información importante y valiosa, además de realizar una monitorización de fallos del sistema. Desde su obligatoriedad en EE.UU sobre el 1996, se ha extendido su uso sobre los diferentes estados del mundo como en Europa o Asia (aunque se usan variantes del mismo).  

Por otra parte, la técnica a utilizar se concentraría en el fuzzing. Esta técnica consiste en el envío inteligente o aleatorios de mensajes para controlar comportamientos erróneos del sistema que se esté probando.

La intención es realizar estos ataques sobre OBD-II para comprobar si se pueden detectar brechas de seguridad.

## Motivación de la aplicación
Tras realizar unn estudio del protocolo OBD-II y la extensión a otros como CAN Bus o ISO-TP. Se llegó a la conclusión que el desarrollo de una aplicación que ayude a llevar un registro de los análisis realizados podría aportar en gran cantidad a la realización de técnicas fuzzing, apoyando a su automatización y estudio de las pruebas realizadas.

Por ello, el objetivo de esta aplicación consiste en la creación de un registro con diferente documentación que define cada prueba realizada, y ayudar además a las personas, no tan involucradas en el fuzzing testing, a la realización del mismo.  

## Documentación  
Se aconseja visitar la [documentación](https://github.com/4lvaro22/Fuzzar-Tool/tree/main/docs) proporcionada.

## Cómo empezar  

1. Preparación e instalación de la herramienta. [Vamos allá!](https://github.com/4lvaro22/Fuzzar-Tool/blob/main/docs/INSTALL.md)
2. Ejecutar el bash script principal: ```sudo bash app.sh```
3. Utilizar la opción por terminal o vía web.
4. Los datos de los análisis realizados se guardarán en el fichero ```data.csv```. 
5. Disfrutar del fuzzing❗

## Referencias interesantes
### Fuzzers
- AFLPlusplus: https://github.com/AFLplusplus/AFLplusplus
- BooFuzz: https://boofuzz.readthedocs.io/en/stable/index.html  
- Randamsa: https://gitlab.com/akihe/radamsa
- HonggFuzz: https://github.com/google/honggfuzz
- LibFuzzer: https://llvm.org/docs/LibFuzzer.html

### Papers
- The Art, Science, and Engineering of Fuzzing: A Survey  
https://arxiv.org/pdf/1812.00140º
- Fuzzing: State of the Art   
https://wcventure.github.io/FuzzingPaper/Paper/TRel18_Fuzzing.pdf  
- An empirical study of the reliability of UNIX utilities  
https://dl.acm.org/doi/10.1145/96267.96279

