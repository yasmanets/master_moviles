//
//  Juego.swift
//  SieteyMedia
//
//  Created by Yaser  on 29/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import Foundation

enum EstadoJuego {
    case turnoJugador, ganaJugador, pierdeJugador, empate, noIniciado
}

class Juego {
    var baraja: Baraja!
    var manoJugador: Mano!
    var estado: EstadoJuego
    var jugadaMaquina: Double = 0.0
    var ganasdasMaquina: Int = 0
    var ganadasJugador = 0
    
    init() {
        self.estado = EstadoJuego.noIniciado
    }
    
    func comenzarPartida() {
        self.baraja = Baraja()
        self.baraja.barajar()
        self.manoJugador = Mano()
        self.estado = EstadoJuego.turnoJugador
        
        jugadaMaquina = Double(Int.random(in: 1...7))
        if Bool.random() {
            jugadaMaquina += 0.5
        }
    }
    
    func jugadorPideCarta() {
        if let pedida = self.baraja?.repartirCarta() {
            print("Sacas \(pedida.descripcion())")
            self.manoJugador.addCarta(pedida)
            let valorMano = self.sumarManoJugador()
            print("Llevas \(valorMano) puntos")
            if (valorMano > 7.5) {
                acabarPartida()
            }
        }
    }
    
    // Se llama cuando el jugador pulsa el botón "Plantarse"
    func jugadorSePlanta() {
        acabarPartida()
    }
    
    var partidasMaquina: Int {
        get {
            return self.ganasdasMaquina
        }
        set(num) {
            self.ganasdasMaquina += num
        }
    }
    
    var partidasJugador: Int {
        get {
            return self.ganadasJugador
        }
        set(num) {
            self.ganadasJugador += num
        }
    }
    
    // Método de uso interno de la clase
    private func acabarPartida() {
        let valorMano = sumarManoJugador()
        var mensaje = ""
        if (valorMano>7.5) {
            mensaje = "Te has pasado!!!, la máquina tenía \(self.jugadaMaquina)"
            self.estado = .pierdeJugador
            self.ganasdasMaquina += 1
        }
        else {
            if (valorMano>jugadaMaquina) {
                mensaje = "Ganas!!!, la máquina tiene \(self.jugadaMaquina)"
                self.estado = .ganaJugador
                self.ganadasJugador += 1
            }
            else if (valorMano<jugadaMaquina) {
                mensaje = "Pierdes!!!, la máquina tiene \(self.jugadaMaquina)"
                self.estado = .pierdeJugador
                self.ganasdasMaquina += 1
            }
            else {
                mensaje = "Empate!!!"
                self.estado = .empate
            }
        }
        self.estado = EstadoJuego.noIniciado
        self.enviarNotificacion(mensaje: mensaje)
    }
    
    private func sumarManoJugador() -> Double {
        var total = 0.0
        for carta in self.manoJugador.cartas {
            total += valor(de:carta)
        }
        return total
    }

    private func valor(de carta:Carta) -> Double {
        if (carta.valor>=10) {
           return 0.5
        }
        else {
           return Double(carta.valor)
        }
    }
    
    private func enviarNotificacion(mensaje: String) {
        let nc = NotificationCenter.default
        nc.post(name: NSNotification.Name(rawValue: "resultado"), object: nil, userInfo: ["mensaje": mensaje])
    }
}
