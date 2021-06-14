# iBeacons

## Yaser El Dabete Arribas

### Descripción

El proyecto trata de realizar aplicación del tipo `Tab Bar` con dos vistas, en una de las vistas el dispositivo será capaz de escanear los iBeacons cercanos y mostrar la información recibida y la otra pantalla pondrá el dispositivo como emisor iBeacon, 

La aplicación ejecuta los frameworks `CoreLocation` y `CoreBluetooth` para la locacización del iBeacon y para la emisión de señal. Los controladores que componen las dos vistas están en el directorio `Controllers`.

- Fichero `EmitViewController.swift`: Es el controlador encargado de gestionar la emisión de señal como iBeacon del dispositivo. Además, el usuario podrá modificar los datos con los que quiere empezar a emitir.
- Fichero `ScanViewController.swift`: Es el controlador encargado de gestionar los datos obtenidos de los iBeacons cercanos al dispositivo. Está compuesto por un `TableView` que contendrá los datos y unos campos de texto par aque el usuairo pueda modificar los datos con los que se empieza a escanear.
- Fichero `BeaconTableViewCell.swift`: Es el fichero que define la vista de la celda de la tabla.

### Dificultades encontradas

En esta práctica no puedo descatar ninguna parte como algo difícil de implementar. Creo que ha sido la práctima más sencilla de las tres que se han realizado en la asginatura.

### Capturas de la aplicación 
![Dos dispositivos](https://github.com/mastermoviles/practica-3-beacons-yasmanets/blob/main/screenshots/devices.JPG)
![Proximidad 1](https://github.com/mastermoviles/practica-3-beacons-yasmanets/blob/main/screenshots/prox1.PNG)
![Proximidad 2](https://github.com/mastermoviles/practica-3-beacons-yasmanets/blob/main/screenshots/prox2.png)
![Proximidad 3](https://github.com/mastermoviles/practica-3-beacons-yasmanets/blob/main/screenshots/prox3.png)

