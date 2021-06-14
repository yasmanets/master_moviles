//
//  OptionsViewController.swift
//  Runtracker
//
//  Created by Yaser  on 26/4/21.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var optionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.optionsTableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
        self.optionsTableView.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
        self.optionsTableView.tableFooterView = UIView(frame: CGRect.zero)
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

// MARK: - Table configurations
extension OptionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath) as! OptionsTableViewCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.cellLabel?.text = "Cadencia"
                cell.buttonLabel.tag = 1
            case 1:
                cell.cellLabel?.text = "Intervalos"
                cell.buttonLabel.tag = 2
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.cellLabel?.text = "Precisión GPS"
                cell.buttonLabel.tag = 3
            case 1:
                cell.cellLabel?.text = "Autopause"
                cell.buttonLabel.isHidden = true
                cell.createSwitch()
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.cellLabel?.text = "Banda HRM"
            case 1:
                cell.cellLabel?.text = "Watch"
            default:
                break
            }
        default:
            break
        }
        return cell
    }
}

extension OptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section {
        case 0:
            title = "Notificaciones"
        case 1:
            title = "Entreno"
        case 2:
            title = "Conectividad"
        default:
            title = ""
        }
        return title
    }
}
