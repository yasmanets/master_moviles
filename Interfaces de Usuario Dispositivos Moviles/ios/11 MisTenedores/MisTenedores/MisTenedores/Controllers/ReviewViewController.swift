//
//  ReviewViewController.swift
//  MisTenedores
//
//  Created by Yaser  on 01/12/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var ratingStackView: UIStackView!
    var ratingSelected: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ratingStackView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.ratingStackView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }

    @IBAction func ratingPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            ratingSelected = "No me gusta"
        case 1:
            ratingSelected = "Me gusta"
        case 2:
            ratingSelected = "Me encanta"
        default:
            break
        }
        performSegue(withIdentifier: "unwindDetailView", sender: sender)
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
