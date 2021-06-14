// EJERCICIO 1
print("Ejercicio 1\n")
let valor = "true"
var b: Bool?
b = Bool(valor)
print(b!)

// EJERCICIO 2
print("\nEjercicio 2\n")
var mensaje: String?
// mensaje = "Se escribe el mensaje"
if let msj = mensaje {
    print(msj)
}
else {
    print("Cadena vacía")
}

// EJERCICIO 3
print("\nEjercicio 3\n")
var bizcocho = ["huevos", "leche", "harina"]
for i in 0..<bizcocho.count {
  print(bizcocho[i])
}

// EJERCICIO 4
print("\nEjercicio 4\n")
func filtrar(_ list: [Int], max maxium: Int)-> [Int] {
    var filteredList: [Int] = []
    for i in 0..<list.count {
        if list[i] <= maxium {
            filteredList.append(list[i])
        }
    }
    return filteredList
}
var lista = [10, 4, 5, 7]
var f = filtrar(lista, max:5)
print(f)

// EJERCICIO 5
print("\nEjercicio 5\n")
class Persona {
    private var nombre: String
    private var edad: Int
    init(nombre: String, edad: Int) {
        self.nombre = nombre
        self.edad = edad
    }
    var adulto: Bool {
        get {
            return self.edad >= 18 ? true : false
        }
    }
}

var p = Persona(nombre:"Pepe", edad:20)
if p.adulto { print("ADULTO!") }

// EJERCICIO 6
print("\nEjercicio 6\n")
enum DiaSemana: Int {
    case lunes, martes, miercoles, jueves, viernes, sabado, domingo
    
    func cuantoFalta() -> Int {
        if self.rawValue == DiaSemana.sabado.rawValue || self.rawValue == DiaSemana.domingo.rawValue {
            return 0
        }
        else {
            return DiaSemana.sabado.rawValue - self.rawValue
        }
    }
}

var dia = DiaSemana.lunes
print(dia.rawValue)
dia = .viernes
print(dia.cuantoFalta())
