# Pong Multipeer

## Yaser El Dabete Arribas

### Descripción

El proyecto trata de realizar un clon del juego "pong" que implemente el modo de conexión *peer-to-peer*, es decir, que los juegadores sean pares cercanos y sus dispositivos intercambien información. 

Para poder jugar, uno de los jugadores deberá establecer una sesión a través de la tacnología `MultipeerConnectivity` que proporciona iOS y el otro deberá unirse a dicha sesión. Una vez que los dos pares estén conectados, se podrá iniciar la partida.

El juego se ejecuta sobre el framework de Apple `SpriteKit` . El contenido de la aplicación se describe en el siguiente listado:

- Fichero `GameScene.sks`: Se encuentra la definición visual de la única escena del juego, contiene los nodos que actúan como marcador, la bola y los jugadores entre otros.
- Fichero `GameScene.swift`: Es el fichero donde está la definición funcional del juego. 
    - Se obtienen las referencias de los difrentes nodos. 
    - Definición del inicio y la unión a sesiones.
    - Lógica del juego.
    - Envío y procesamiento de datos *peer-to-peer*.
- Carpeta `Fonts`: Aquí se encuentra la fuente escogida para los textos del juego.


### Dificultades encontradas

Puedo destacar dos fases del desarrollo como las que más me han costado de susperar.

- `MCAdvertiserAssistant`: En un primer momento traté de implementarlo en un fichero separado con el objetivo de mantener un código limpio y claro pero finalmente, la forma más sencilla de introducirlo era directamente en el fichero `GameScene.swift`
- Gestión de los datos: Me ha costado bastante controlar los ciclos de enviar y recibir datos ya que aveces el propio dispositivo que envíaba el dato con la posición de la pelota recibía ese mismo dato cuando el que tenía que recibirlo era el segundo dispositivo.


### Capturas de la aplicación 
![Inicio](https://github.com/mastermoviles/practica-2-dualclone-yasmanets/blob/main/screenshots/inicio.png)
![Peers](https://github.com/mastermoviles/practica-2-dualclone-yasmanets/blob/main/screenshots/peers.png)
![juego 1](https://github.com/mastermoviles/practica-2-dualclone-yasmanets/blob/main/screenshots/juego1.png)
![Juego 2](https://github.com/mastermoviles/practica-2-dualclone-yasmanets/blob/main/screenshots/juego2.png)

