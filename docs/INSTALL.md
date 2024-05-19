# Cómo instalar Fuzzar Tool

Para empezar, es necesario tener instalado [Node.js](https://nodejs.org/en) en su versión 18 o superior.

Asumiendo que esté la herramienta Node.js instalada, se deberán instalar todas las siguientes dependencias:

```shell
sudo apt-get update
# Instalando las dependencias de linux
sudo apt-get install -y jq build-essential python3-dev git python3-setuptools
git clone https://github.com/4lvaro22/Fuzzar-Tool.git
cd Fuzzar-Tool
# Instalando las dependencias de node
npm i
```

Ya estaría todo lo necesario para utilizar la herramienta en su dispositivo.

