# Cómo instalar Fuzzar Tool

## Mediante el código fuente

Para empezar, es necesario tener instalado [Node.js](https://nodejs.org/en) en su versión 18 o superior. Además de instalar el sistema de gestión de paquetes npm.

Asumiendo que esté la herramienta Node.js instalada, se deberán instalar todas las siguientes dependencias:

```shell
sudo apt-get update
# Instalando las dependencias de linux
sudo apt-get install -y jq build-essential python3-dev git python3-setuptools python3-pip
git clone https://github.com/4lvaro22/Fuzzar-Tool.git
cd Fuzzar-Tool
sudo pip3 install -r requirements.txt
# Instalando las dependencias de node
npm i
```

Lo próximo a configurar e instalar sería las herramientas de fuzzing que proporciona por defecto la herramienta. Para ello se ha facilitado un script en bash que se debe de ejecutar de la siguiente forma:

```shell
sudo bash app.sh <fuzzer>
```

Donde `<fuzzer>` puede ser:

- `all`: instala todos los fuzzers definidos
- `honggfuzz`: instala el fuzzer Honggfuzz
- `aflplusplus`: instala el fuzzer AFL++

Tras esto, ya estaría todo lo necesario para utilizar la herramienta en su dispositivo.

## Mediante Docker

1. Clonar el repositorio

```
git clone https://github.com/4lvaro22/Fuzzar-Tool.git \\
cd Fuzzar-Tool/
```

2. Construir la imagen Docker

````
    docker build .
    ```
````

3. Ejecutar el contenedor

```
docker run -v <dir\_local>:/opt/sim --name fuzzar-tool -p 3000:3000 fuzzar-tool
```

`<dir\_local>` se corresponde con el directorio donde se encuentren los programas a analizar
