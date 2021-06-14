
import UIKit
import CoreData

class PedidosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = delegate.persistentContainer.viewContext
        let request: NSFetchRequest<Pedido> = NSFetchRequest(entityName: "Pedido")
        if let pedidos = try? myContext.fetch(request) {
            for pedido in pedidos {
                print(pedido)
            }
        }
        super.viewWillAppear(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
