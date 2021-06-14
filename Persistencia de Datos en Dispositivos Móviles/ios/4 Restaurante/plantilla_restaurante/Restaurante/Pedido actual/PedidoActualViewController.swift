

import UIKit
import CoreData

class PedidoActualViewController: UIViewController, UITableViewDataSource, LineaPedidoTableViewCellDelegate {

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    @IBAction func realizarPedidoPulsado(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = delegate.persistentContainer.viewContext
        
        StateSingleton.shared.pedidoActual.fecha = Date()
        StateSingleton.shared.pedidoActual.direccion = address?.text
        StateSingleton.shared.pedidoActual.telefono = phone?.text
        try! myContext.save()
        
        StateSingleton.shared.pedidoActual = Pedido(context: myContext)
        let alert = UIAlertController(title: "Pedido Realizado", message: "El pedido se ha realizado con éxito", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            action in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    
    @IBAction func cancelarPedidoPulsado(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = delegate.persistentContainer.viewContext
        myContext.delete(StateSingleton.shared.pedidoActual)
        try! myContext.save()
        myContext.processPendingChanges()
    }
    
    //TODO: descomentar esta línea!!!!
    var platoElegido : Plato!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.dataSource = self
        //TODO:
        // - crear el pedido actual si no existe
        // - crear la linea de pedido y asociarla al plato y al pedido actual
        self.totalLabel.text = "0€"
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let myContext = delegate.persistentContainer.viewContext
        if (StateSingleton.shared.pedidoActual == nil) {
            StateSingleton.shared.pedidoActual = Pedido(context: myContext)
            try! myContext.save()
        }
        let lineaPedido = LineaPedido(context: myContext)
        lineaPedido.cantidad = 1
        lineaPedido.plato = platoElegido
        StateSingleton.shared.pedidoActual.addToLineasPedido(lineaPedido)
        try! myContext.save()

    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabla.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: devolver el número real de filas de la tabla
        return  StateSingleton.shared.pedidoActual.lineasPedido!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLinea", for: indexPath) as! LineaPedidoTableViewCell
        //Necesario para que funcione el delegate
        celda.pos = indexPath.row
        celda.delegate = self
        
        //TODO: rellenar los datos de la celda
        let linea = StateSingleton.shared.pedidoActual.lineasPedido![indexPath.row] as? LineaPedido
        celda.nombreLabel!.text = linea?.plato!.nombre
        return celda
    }
    
    func cantidadCambiada(posLinea: Int, cantidad: Int) {
        //TODO: actualizar la cantidad de la línea de pedido correspondiente
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = delegate.persistentContainer.viewContext
        var lineaPedido = LineaPedido(context: myContext)
        lineaPedido = StateSingleton.shared.pedidoActual.lineasPedido![posLinea] as! LineaPedido
        lineaPedido.cantidad = Int16(cantidad)
        StateSingleton.shared.pedidoActual.replaceLineasPedido(at: posLinea, with: lineaPedido)
        try! myContext.save()
    }
    
    
}
