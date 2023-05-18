# Introducción-a-STM32-BLUE-PILL

##Funcionamiento del proyecto
Este proyecto en especifico muestra en 8 leds los números escritos en binario, es decir, para el caso en el que se represente el número 1 en binario se mostrará un 01 en los leds, donde el led encendido indica uno y el led apagado indica 0 en binario. Se cuenta también con dos botones configurados de tal forma que al presionar un botón se decremetará el conteo, mientras que al presionar otro botón se hará un aumento en el conteo de uno en uno. Además, al presionar ambos botones al mismo tiempo se reseteará el conteo apagando todos los leds.

##Diagrama del proyecto
El siguiente diagrama representa las conexiones hechas en la placa utilizada para este proyecto, se hizo uso de una blue pill
![logo](htps://i.ibb.co/rFfJVnY/STM32-Blue-Pill-Pr-ctica-1.png)

##Procedimiento de compilación
En primera instancia necesitamos conectar la placa a nuestro ordenador para verificar que el sistema operativo la reconoce. Para esto, se hizo uso del software STM32CubeProgrammer para hacer el reconocimiento de la placa. Una vez hecho esto, iremos a nuestro archivo ensamblador para ejecutar los comandos correspondientes para obtener el archivo binario que grabaremos en nuestra placa.
Primero, ensamblamos el contenido del archivo leds.s a través del comando leds.s -o leds.o.
Después, una vez generado el archivo leds.o, construiremos un objeto binario a partir del archivo blink.o, esto lo haremos con el comando arm-objcopy -O binary leds.o leds.bin.
Finalmente, una vez hecho este procedimiento, haciendo uso del STM32CubeProgrammer simplemente conectamos el grabador con la placa y damos click en la parte superior derecha en Connect y buscamos el apartado de Erasing & Programmingy, buscamos nuestro archivo leds.bin y famos clic en Start Programming para realizar el grabado del programa en nuestra placa.

##Marcos del programa
El marco de la función de decremento cuenta con un tamaño de 16 bytes, 8 bytes para el argumento de la función y 8 bytes para r7 y lr

![logo](https://i.ibb.co/8BPHdPy/Marco-Decremento.png)

El marco de la función de incremento cuenta con un tamaño de 16 bytes, 8 bytes para el argumento de la función y 8 bytes para r7 y lr
![logo](https://i.ibb.co/8BPHdPy/Marco-Decremento.png)

El marco de la función delay cuenta con un marco de 32 bytes, donde 8 bytes son para respaldar r7, 8 bytes para el argumento de la función y 16 bytes para las variables de la función
![logo](https://i.ibb.co/8BPHdPy/Marco-Decremento.png)

El marco de la función de reset cuenta con un tamaño de 16 bytes, 8 bytes para el argumento de la función y 8 bytes para r7 y lr.
![logo](https://i.ibb.co/8BPHdPy/Marco-Decremento.png)
