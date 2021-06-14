//
//  ViewController.swift
//  SieteyMedia
//
//  Created by Yaser  on 28/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var juego = Juego()
    var vistaCartas: [UIImageView] = []
    
    @IBOutlet weak var ganadasMaquina: UILabel!
    @IBOutlet weak var ganadasJugador: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.suscribirse()
        self.ganadasMaquina!.text = "Máquina: 0"
        self.ganadasJugador!.text = "Jugador: 0"
    }
    
    
    @IBAction func nuevaPartida(_ sender: Any) {
        juego.comenzarPartida()
        self.eliminarCartas()
    }
    
    @IBAction func pedirCarta(_ sender: Any) {
        if juego.estado != EstadoJuego.noIniciado {
            juego.jugadorPideCarta()
            let carta = juego.manoJugador.cartas[juego.manoJugador.cartas.count - 1]
            self.dibujarCarta(carta: carta, posicion: vistaCartas.count)
        }
        else {
            showToast(controller: self, message: "No puedes pedir una carta sin iniciar una partida", seconds: 10.0)
        }
        
    }
    
    @IBAction func plantarse(_ sender: Any) {
        if juego.estado != EstadoJuego.noIniciado {
            juego.jugadorSePlanta()
        }
        else {
            showToast(controller: self, message: "No puedes plantarte sin iniciar una partida", seconds: 1.0)
        }
    }
    
    private func suscribirse() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.recibir), name: NSNotification.Name(rawValue: "resultado"), object: nil)
    }
    
    @objc func recibir(notification: Notification) {
        if let userInfo = notification.userInfo {
            let mensaje = userInfo["mensaje"] as! String
            mostrarResultado(mensaje: mensaje)
        }
    }
    
    private func mostrarResultado(mensaje: String) {
        let alert = UIAlertController(title: "Resultado de la partida", message: mensaje, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) {
            action in
            self.eliminarCartas()
            self.ganadasMaquina!.text = "Máquina: \(self.juego.ganasdasMaquina)"
            self.ganadasJugador!.text = "Jugador: \(self.juego.ganadasJugador)"
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func dibujarCarta(carta: Carta, posicion : Int) {
        let nombreImagen = String(carta.valor)+String(carta.palo.rawValue)
        let imagenCarta = UIImage(named: nombreImagen)
        let cartaView = UIImageView(image: imagenCarta)
        cartaView.frame = CGRect(x: -200, y: -200, width: 200, height: 300)
        cartaView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        self.view.addSubview(cartaView)
        self.vistaCartas.append(cartaView)
        UIView.animate(withDuration: 0.5){
            cartaView.frame = CGRect(x:100+70*(posicion-1), y:100, width:70, height:100);
            cartaView.transform = CGAffineTransform(rotationAngle:0);
        }
    }
    
    func eliminarCartas() {
        if self.vistaCartas.count != 0 {
            for carta in self.vistaCartas {
                carta.removeFromSuperview()
            }
        }
        self.vistaCartas = []
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}

