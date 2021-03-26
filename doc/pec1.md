---
title: Memoria de desarrollo de la PEC1
author: Damián Serrano Thode
date: 26/03/2021
lang: es
geometry: "a4paper,left=2.5cm,right=2.5cm,top=2.5cm,bottom=2.5cm"
mainfont: arev
fontsize: 12pt
linestretch: 1.5
toc_depth: 2
urlcolor: cyan
toccolor: black
linkcolor: black
numbersections: true
header-includes:
   - \usepackage{arev}
---

# Memoria de desarrollo de la PEC1

# Damián Serrano Thode

# Proceso de desarrollo

Para el desarrollo de esta práctica, y de todas las prácticas de las demás asignaturas, en vez de tener que instalar en mi equipo todas las herramientas y librerías de desarrollo, decidí usar Docker para poder aislar estas dependencias de mi sistema, y de este modo mantener el equipo limpio.

Para ello configuré un archivo ```Dockerfile``` para esta práctica a partir de la imagen base de NodeJS, con el siguiente contenido:

```dockerfile
from node:lts
expose 8080
```

Este archivo me permite configurar un contenedor con NodeJS versión LTS (actualmente la versión 14.16.0), dentro del cual se va a ejecutar todo el código del proyecto, manteniendo mi equipo limpio de librerías y frameworks.

Para poder utilizar cómodamente Docker en mi proceso de desarrollo, me creé el siguiente archivo ```Makefile```, el cual me permite usar el comando ```make``` para poder actuar sobre el contenedor y ejecutar los distintos comandos de NodeJS:

```makefile
IMAGE_NAME=hhyc2
DOCKER_RUN=docker run -it --rm --network=bridge -v $(PWD):/usr/src/pec -w /usr/src/pec $(IMAGE_NAME)

build:
	docker build -f ../Dockerfile -t $(IMAGE_NAME) .
	$(DOCKER_RUN) npm i

destroy:
	docker rmi $(IMAGE_NAME)

start:
	$(DOCKER_RUN) npm start
	
exec:
	$(DOCKER_RUN) $(ARGS)
```

Gracias a este archivo, para construir el entorno de desarrollo puedo usar un comando tan simple como el siguiente:

```
make build
```

Mediante el comando anterior se construye el contenedor a partir de la configuración indicada en el archivo ```Dockerfile``` y se realiza la instalación de las dependencias indicadas en el archivo ```package.json```.

## Descarga de UOC Boilerplate

Para esta práctica se parte del proyecto UOC Boilerplate desarrollado para esta asignatura, por lo que el primer paso es descargar este proyecto. Puesto que yo cuento actualmente con un repositorio privado de Github para todo el contenido desarrollado en el máster, la opción de clonar un proyecto dentro de mi repositorio no es viable, por lo que decidí descargar el código comprimido de Github usando el enlace de descarga del proyecto, y lo descomprimí en la ruta correspondiente:

```bash
wget -O temp.zip https://github.com/uoc-advanced-html-css/uoc-boilerplate/archive/refs/heads/master.zip
unzip temp.zip
rm temp-zip
```

De este modo se ha descargado el código en la ruta ```./uoc-boilerplate-master```.

## Instalación de dependencias

Para este proyecto, además de las dependencias ya presentes en el archivo ```package.json``` instalé los siguientes paquetes adicionales de npm:

* Fontawesome (@fortawesome/fontawesome-free): para los iconos de la página.

* Stylelint (stylelint): requisito de la práctica, usado para validar que el código CSS cumple la metodología usada en la práctica.

* Stylelint Config Recommended SCSS (stylelint-config-recommended-scss): este paquete aplica una configuración base a Stylelint.

* Stylelint BEM (@namics/stylelint-bem): este paquete se utiliza para aplicar las reglas de la metodología BEM en Stylelint.

* Stylelint order (stylelint-order): este paquete se utiliza para aplicar el órden de atributos en las etiquetas HTML, según la metodología de Mark Otto (@mdo).

* Html Validate (html-validate): para validar que el código HTML sigue la especificación de HTML5.

El primer paquete se instaló como una dependencia de producción mediante el flag ```--save```, mientras que las otras cinco se instalaron como dependencias de desarrollo con el flag ```--save-dev```.

La forma de instalar las dependencias en el entorno de desarrollo con Docker sería la que se muestra en el siguiente comando, por ejemplo para instalar Fontawesome:

```
make exec ARGS="npm -i --save @fortawesome/fontawesome-free"
```
## Compilación del proyecto

Además de incluir el paquete Stylelint en el proceso de build como se indica en la práctica, añadí el validador de HTML y así tener mayor confianza de que el código desarrollado cumplía con las especificaciones de HTML5, además de cumplir con la metodología BEM.

De este modo, el script ```build``` de mi archivo ```package.json``` quedó configurado de la siguiente forma:

```json
  "scripts": {
    "parcel:serve": "parcel serve src/*.html -p 8123 --open",
    "parcel:build": "parcel build src/*.html --public-url ./ --dist-dir dist --no-source-maps --no-cache",
    "clean": "rimraf dist .cache .cache-loader .parcel-cache",
    "dev": "npm-run-all clean parcel:serve",
    "build": "npm-run-all clean htmlvalidate stylelint parcel:build",
    "test": "echo 'Everything is working as expected \nStart working on your project by running \\033[1mnpm run dev\\033[0m'",
    "stylelint": "stylelint src/**/*.scss",
    "htmlvalidate": "node_modules/.bin/html-validate src/**/*.html"
  }
```

Para poder completar el build del proyecto debe de ejecutarse correctamente los scripts ```htmlvalidator``` y ```stylelint```, de modo que si hay cualquier fallo con el código HTML o las reglas CSS, la compilación para producción se detendrá y mostrará por consola los errores que hay que corregir.

Uno de los problemas que me encontré fue en la ordenación de las etiquetas HTML, pero gracias al paquete de validación de HTML, este error no llegó al código de producción y pudo ser solventado en cuanto saltó el error de la validación.

Una vez completado el desarrollo de la práctica, para compilar el proyecto para producción usé el siguiente comando, que ejecuta uno de los scripts configurados en el archivo ```package.json```:

```
make exec ARGS="npm run build"
```

Una vez completada la compilación, para testear que se había generado correctamente, ejecuté el siguiente comando dentro de la carpeta ```dist``` en la que se generó el código de producción:

```
python -m SimpleHTTPServer
```

Este comando inicia un servidor HTTP local mediante Python en el puerto 8000, de modo que dirigiendo una pestaña del navegador a la ruta http://localhost:8000/cv.html pude comprobar que el código se había generado correctamente y todos los archivos de la práctica cargaban sin error.

## Publicación del proyecto en Netlify

Para completar la práctica, lo siguiente era publicar el proyecto en Netlify, y para ello ya había configurado en Netlify un sitio web alimentado a partir de la ruta de mi repositorio de Github del máster.

Este sitio está configurado para hacer un seguimiento del repositorio privado, y ejecutar el comando ```build``` dentro de la ruta de esta práctica. Posteriormente al build, se indica que debe recoger los resultados del directorio ```dist``` para publicarlos en el sitio web.

# Justificación de la metodología

Para la realización de esta práctica he decidido utilizar la metodología BEM para la creación de la estructura de estilos CSSde la práctica.

Después de revisar la documentación de las otras metodologías, decidí elegir esta por los siguientes motivos:

* La metodología BEM es la que, según mi juicio, mejor encaja mi estilo de desarrollo, ya que permite definir estilos según un patrón fijo para contenedores, elementos y modificadores, lo cual facilita la identificación de las clases en el código.

* La metodología OOCSS era una que también me resultó interesante para aplicar en la práctica, pero la descarté porque, a mi juicio, no ofrece una estructura sólida para la nomenclatura de las clases, y podría acabar con una duplicación de estilos si no se aplica de forma cuidadosa.

* La metodología SMACSS, desde mi punto de vista de programador backend con experiencia limitada en la creación de sistemas de diseño para el frontend, me pareció demasiado complicada, ya que crea una serie de niveles en la definición de las reglas y me pareció tener un alcance demasiado amplio, comparado con el desarrollo de una pequeña página informativa. Quizá si más adelante fuera necesario crear un sistema de diseño coordinado para un sitio de mayor tamaño donde se combinen distintos módulos, podría ser una metodología a utilizar.

* La metodología ITCSS la vi enfocada del mismo modo que la metodología SMACSS, orientada a crear un sistema de diseño para un sitio web complejo en el que se definen una cierta cantidad de módulos.

## Decisiones de diseño

Para la realización de esta práctica decidí abordar el diseño de la página componiendo primero el aspecto para una pantalla de ordenador de escritorio y, una vez estabilizado el diseño, apliqué las modificaciones a los estilos mediante el uso de un mixin responsive, estableciendo las modificaciones a las propiedades que creí conveniente para presentar un aspecto adecuado en pantallas de móvil o tablet.

## Estructura de las clases CSS

Para la estructura de la página y los estilos CSS que se deben aplicar a las mismas, definí la siguiente jerarquía en las clases de CSS:

```
*
|__ .page
  |__ .page__title
  |
  |__ .block
    |__ .block__icon
    |__ .block__header
    |__ .block__copy
```

Con esta jerarquía compuse los bloques principales de la página: "Personal information", "Introduction", "Work experience" y "Projects", y posteriormente para cada uno de los bloques definí las siguientes jerarquías de estilos:

```
* (.block)
|
|__ .information
  |__ .information__photo
  |__ .information__data
    |
    |__ .information-data
      |__ .information-data__key
      |__ .information-data__value
      |__ .information-data__link
```

```
* (.block)
|
|__ .experience-list
  |__ .experience-list__experience-item
    |
    |__ .experience
      |__ .experience__title
      |__ .experience__timespan
      |__ .experience__description
```

```
* (.block)
|
|__ .projects
  |__ .projects__project-item
    |
    |__ .project
      |__ .project__timespan
      |__ .project__type
      |__ .project__description
      |__ .project__keywords
        |
        |__ .keyword-list
          |__ .keyword-list__item
```

Mediante el uso de esta estructura se aplicaron los estilos correspondientes a cada elemento de la página, y aplicando las modificaciones para pantallas móviles y tablet mediante el uso de un ```mixin``` de SASS para introducir las modificaciones responsive.

## Estructura de los archivos SCSS

Para crear los estilos de cada uno de los bloques indicados en el apartado anterior se crearon una serie de archivos en los que se definieron los estilos de cada uno de los bloques:

* ```cv/_blocks.scss```: Este archivo contiene los estilos para los elementos de clase ```.block``` y descendientes.

* ```cv/_defaults.scss```: Este archivo contiene los estilos por defecto para varios de los componentes de la página, como las cabeceras, los textos o los enlaces. También se definieron unos estilos por defecto para flexbox que luego fueron incluidos en los estilos de otros bloques.

* ```cv/_information.scss```: Contiene los estilos para el bloque de información personal.

* ```cv/_mixins.scss```: Contiene el mixin para aplicar los estilos responsive de los dispositivos móviles y tablets.

* ```cv/_page.scss```: Contiene los estilos para la página y sus descendientes de primer nivel.

* ```cv/_projects.scss```: Contiene los estilos para el bloque de proyectos destacados.

* ```cv/_reset.scss```: Contiene las reglas para resetear los estilos y definir el tamaño de fuente raíz.

* ```cv/_variables.scss```: Contiene las variables que forman labase de la definición del resto de estilos, como las tipografías a aplicar en las cabeceras y textos, los tamaños de fuente para cabeceras y textos, tanto en escritorio como en dispositivos móviles y tablets, o los colores de los elementos.

* ```cv/main.scss```: Este archivo incluye cada uno de los archivos indicados anteriormente, e incluye también los estilos de Fontawesome.

## Configuración de Stylelint

Para validar todas las decisiones explicadas en los apartados anteriores, configuré los paquetes adicionales de Stylelint de la siguiente forma:

```json
{
    "extends": "stylelint-config-recommended-scss",
    "plugins": [
        "@namics/stylelint-bem",
        "stylelint-order"
    ],
    "rules": {
        "plugin/stylelint-bem-namics": {
            "patternPrefixes": [],
            "helperPrefixes": []
        },
        "order/properties-order": [
            "class",
            "id",
            "name",
            "data-*",
            "src",
            "for",
            "type",
            "href",
            "value",
            "title",
            "alt",
            "role",
            "aria-*"
        ]
    }
}
```

En este archivo se indica que se carguen las reglas definidas en el paquete ```stylelint-config-recommended-scss```, los plugins ```@namics/stylelint-bem``` para las reglas de la metodología BEM y ```stylelint-order``` para las reglas de ordenación de @mdo, y cargue las siguientes reglas:

* Las reglas para el plugin de BEM, en la cual se indica que no se van a usar prefijos en los nombres de los estilos.

* Las reglas de ordenacion de los atributos de las etiquetas HTML, siguiendo la guía de estilo de @mdo.

# Enlaces

El enlace de acceso a la página de curriculum publicado en Netlify es el siguiente: [https://wizardly-davinci-97889d.netlify.app/cv.html](https://wizardly-davinci-97889d.netlify.app/cv.html).

El repositorio de Github donde se puede encontrar el código es el siguiente: [https://github.com/dsthode/htmlcss2](https://github.com/dsthode/htmlcss2).
