

import UIKit
import CoreData

class PlatosViewController: UIViewController, UITableViewDataSource, PlatoTableViewCellDelegate, NSFetchedResultsControllerDelegate, UISearchResultsUpdating  {
    
    @IBOutlet weak var tabla: UITableView!
    var frc: NSFetchedResultsController<Plato>!
    let searchController = UISearchController(searchResultsController: nil)
    let throttlet = Throttler(minimumDelay: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.dataSource = self
        //TODO: crear un NSFetchedResultsController
        let delegate = UIApplication.shared.delegate! as! AppDelegate
        let myContext = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<Plato>(entityName: "Plato")
        let sortType = NSSortDescriptor(key: "tipo", ascending: true)
        request.sortDescriptors = [sortType]
        self.frc = NSFetchedResultsController<Plato>(fetchRequest: request, managedObjectContext: myContext, sectionNameKeyPath: "tipo", cacheName: nil)
        try! self.frc.performFetch()
        self.frc.delegate = self
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Buscar plato"
        self.searchController.searchBar.sizeToFit()
        self.tabla.tableHeaderView = searchController.searchBar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO devolver el número de filas en la sección
        return self.frc.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //TODO: devolver el título de la sección
        return self.frc.sections![section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //TODO: devolver el número de secciones
        return self.frc.sections!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPlato", for: indexPath) as! PlatoTableViewCell
        
        //Necesario para que funcione el botón "añadir"
        celda.delegate = self
        celda.index = indexPath
        
        //TODO: rellenar la celda con los datos del plato: nombre, precio y descripción
        //Para formato moneda puedes usar un NumberFormatter con estilo moneda
        //let fmt = NumberFormatter()
        //fmt.numberStyle = .currency
        //let formateado = fmt.string(from: NSNumber(value: 10.7)) //€10.70
        let plato = self.frc.object(at: indexPath)
        celda.nombreLabel.text = plato.nombre
        celda.descripcionLabel.text = plato.descripcion
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.currencySymbol = "€"
        celda.precioLabel.text = fmt.string(from: NSNumber(value: plato.precio))
        return celda
    }
    
    //Se ha pulsado el botón "Añadir"
    func platoAñadido(indexPath: IndexPath) {
        //TODO: obtener el Plato en la posición elegida
        let platoElegido = self.frc.object(at: indexPath)
        
        //Le pasamos el plato elegido al controller de la pantalla de pedido
        //Y saltamos a esa pantalla
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tu Pedido") as! PedidoActualViewController
        
        //TODO: DESCOMENTAR ESTA LINEA!!!!!!!!!
        vc.platoElegido = platoElegido
        
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        throttlet.throttle {
            let texto = searchController.searchBar.text!
            guard let coreDelegate = UIApplication.shared.delegate as? AppDelegate else{
                return
            }
            let myContext = coreDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<Plato>(entityName: "Plato")
            let predicate = NSPredicate(format: "nombre CONTAINS[c] '\(texto)'")
            let sortType = NSSortDescriptor(key: "tipo", ascending: true)
            request.sortDescriptors = [sortType]

            if texto.isEmpty {
                self.frc = NSFetchedResultsController<Plato>(fetchRequest: request, managedObjectContext: myContext, sectionNameKeyPath: "tipo", cacheName: nil)
                try! self.frc.performFetch()
                self.tabla.reloadData()
                return
            }
            request.predicate = predicate
            self.frc = NSFetchedResultsController<Plato>(fetchRequest: request, managedObjectContext: myContext, sectionNameKeyPath: "tipo", cacheName: nil)
            try! self.frc.performFetch()
            self.tabla.reloadData()
        }
    }
    

}
