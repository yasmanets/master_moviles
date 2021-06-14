# RunTrackerFinal

## Yaser El Dabete Arribas

### Descripción

El proyecto trata de ampliar la funcionalidad de la práctica 1 de la asignatura. En mi caso he implementado los siguientes puntos:

- Algoritmo para calcular el número de calorías consumidas (https://farmarunning.com/met).
- Animación de la pulsación larga del botón que termina el entrenamiento.
- Registro de usuarios con las siguientes opciones:
    - Registro e inicio de sesión con email y contraseña.
    - Registro e inicio de sesión con Google.
- Los datos del perfil del usuario se guardan en Firebase.
- Los datos del perfil del usuario se recuperan desde Firebase

A diferencia de la práctica 1 se ha implementado un nuevo controlador llamado `AuthViewController`que se encarga de gestionar
el registro y el inicio de sesión de los usuarios.

El código utilizado para realizar la animación del botón es el siguiente:
   
    ```swift
    @objc fileprivate func onLongPressed(_ sender: UILongPressGestureRecognizer) {
        if self.trainingStatus != .Stopped {
            self.animateView(self.actionButton)
            self.stopTraining()
        }
    }
    
    // Función para animar el botón cuando se hace una pulsación larga
    fileprivate func animateView(_ viewToAnimate: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    ```

Para poder ejecutar la práctica se debe de ejecutart el comando `pod install` en la raíz del proyecto con el objetivo de instalar todas las dependencias de Firebase.

### Dificultades encontradas

- Búsqueda de un algoritmo que calcule el número de calorías consumidas. He buscado mucha información y la conclusión a la que he llegado es que con los datos
de distancia y peso del usuario se puede obtener una aproximación de las calorías consumidas pero este valor siempre llevará un error.
- Navegación entre la vista de autenticación y el tabbar. Creo que a reíz de un error mío no conseguia navegar entre estos dos componentes y tuve que emplear mucho
tiempo en buscar la solución.

### Capturas de la aplicación 
![Auth](https://github.com/mastermoviles/proyecto-final-yasmanets/blob/main/screenshots/auth.PNG)
![Profile](https://github.com/mastermoviles/proyecto-final-yasmanets/blob/main/screenshots/profile.jpeg)
![firebase-users](https://github.com/mastermoviles/proyecto-final-yasmanets/blob/main/screenshots/users.png)
![firebase-data](https://github.com/mastermoviles/proyecto-final-yasmanets/blob/main/screenshots/profile-data.png)
