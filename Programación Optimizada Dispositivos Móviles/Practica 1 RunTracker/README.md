# RunTracker

## Yaser El Dabete Arribas

### Descripción

El proyecto trata de realizar una aplicación capaz de gestionar los entrenamientos del usuario de forma que se monitorice tanto la ruta que sigue durante su entrenamiento y sus ciertas estadísticas como la cadencia, el ritmo, la distancia y el tiempo.

Además el usuario podrá establecer parámetros para que el sistema lance notificaciones acústicas avisando al usuario de que ha alcanzado los valores que haya configurado.

- Carpeta `Utils`: Contiene diferentes ficheros de utilidades para el sistema.
    - Place: definición del objeto que representa puntos en el mapa.
    - Train: definición del objeto que representa el entrenamiento del usuario.
    - TimeManagement: contiene varias funciones para procesar los tiempos.
    - DistanceManagement: contiene varias funciones para procesar las distancias.
- Carpeta `Controllers`: Contiene los controladores de cada una de las vistas de la aplicación. Entre los controladores cabe destacar el controlador de la pantalla `Entreno`, es decir, el fichero `ViewController`. Este controlador es el encargado de pedir al usuario los diferentes permisos que se necesitan en la aplicación, también gestiona el cronómetro y obtiene los valores de los diferentes datos estadísticos.

   Por último y no menos importante, se encarga de gestionar los diferentes estados del entrenamiento según los eventos que acontecen en la aplicación. Los estados del entrenamiento están definidos en el siguiente fragmento de código
   
    ```swift
    private enum TrainingStatus {
        case Started
        case Paused
        case Stopped
    }
    ```

En cuanto a las funcionalidades se debe resaltar, que el usuario dispondrá de una pantalla con los datos históricos de sus entrenamientos en los que podrá ver la fecha de cada entrenamiento y la distancia recorrida durante el tiempo que ha durado el entrenamiento.

También tendrá una pantalla con sus dato de perfil dónde podrá establecer una foto, su nombre, sexo, edad, peso y altura.

### Dificultades encontradas

Puedo destacar dos fases del desarrollo como las que más me han costado de susperar.

- Pantalla de opciones: Al principio me costó mucho implementar la tabla con las diferentes opciones y sobre todo la gestión de las mismas. Procesar el click en cada fila y poder mostrar el `UIAlertController` para recoger los datos del usuario.
- Gestión y permisos del entrenamiento: He tratado de pedir los permisos en el momento que se van a necesitar y no antes y además he puesto diferentes estados del entrenamiento que van cambiando según los eventos que ocrruen (pulsación del botón, pulsación larga del botón o autopause). Entonces, mezclar las dos cosas para que funcionase correctamente me costó un poco.

Por último, la obtención y procesamiento de los datos del podómetro, motionActivityManager y del mapa ha sido relativamente sencillo gracias a la documentación y los ejercicios guiados.

### Capturas de la aplicación 
![Training](https://github.com/mastermoviles/practica-1-runtracker-yasmanets/blob/main/screenshots/training.PNG)
![Route](https://github.com/mastermoviles/practica-1-runtracker-yasmanets/blob/main/screenshots/route.PNG)
![Profile](https://github.com/mastermoviles/practica-1-runtracker-yasmanets/blob/main/screenshots/profile.PNG)
![Historic](https://github.com/mastermoviles/practica-1-runtracker-yasmanets/blob/main/screenshots/historic.PNG)
![Options](https://github.com/mastermoviles/practica-1-runtracker-yasmanets/blob/main/screenshots/options.PNG)
![Options_Alert](https://github.com/mastermoviles/practica-1-runtracker-yasmanets/blob/main/screenshots/options_alert.PNG)


