//
//  HistoricViewController.swift
//  Runtracker
//
//  Created by Yaser  on 28/4/21.
//

import UIKit

class HistoricViewController: UIViewController {

    @IBOutlet weak var historicTableView: UITableView!
    private var trainings: [Train] = []
    private let userDefauls = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.historicTableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
        self.historicTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.historicTableView.rowHeight = 90
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let decoder = JSONDecoder()
        if let trainingsData = userDefauls.object(forKey: "trainings") as? Data {
            if let storedTrainings = try? decoder.decode([Train].self, from: trainingsData) {
                self.trainings = storedTrainings
            }
        }
    }
}

// MARK: - Table configurations
extension HistoricViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trainings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historicCell", for: indexPath) as! HistoricTableViewCell
        cell.dateLabel.text = self.trainings[indexPath.row].date
        cell.statsLabel.text = "\(self.trainings[indexPath.row].distance) km en \(self.trainings[indexPath.row].time)"
        cell.caloriesLabel.text = "\(self.trainings[indexPath.row].calories) kcal"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension HistoricViewController: UITableViewDelegate {

}
