enum Palo: String {
    case bastos, copas, espadas, oros
}

class Carta {
    private var valor: Int
    private var palo: Palo
    
    init?(_ valor: Int, _ palo: Palo) {
        if valor < 1 || valor > 12 || valor == 8 || valor == 9 {
            return nil
        }
        self.valor = valor
        self.palo = palo
    }
    func descripcion() -> String {
        return "El \(valor) de \(palo.rawValue)"
    }
}

class Mano {
    private var cartas: [Carta]
    init() {
        cartas = []
    }
    var tamaño: Int {
        get {
            return self.cartas.count
        }
    }
    func addCarta(_ carta: Carta) {
        self.cartas.append(carta)
    }
    func getCarta(pos: Int) -> Carta? {
        if pos < 0 || pos >= self.cartas.count {
            return nil
        }
        return self.cartas[pos];
    }
    
    
}

var mano = Mano()
mano.addCarta(Carta(1, .oros)!)
mano.addCarta(Carta(10, .espadas)!)
mano.addCarta(Carta(7, .copas)!)
print("Hay \(mano.tamaño) cartas")
for num in 0..<mano.tamaño {
    if let carta = mano.getCarta(pos:num) {
        print(carta.descripcion())
    }
}
