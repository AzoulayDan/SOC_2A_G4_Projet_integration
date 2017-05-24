//
//  UrgenceController.swift
//  J.O.Infos
//
//  Created by joffrey pijoan on 17/05/2017.
//  Copyright © 2017 joffrey pijoan. All rights reserved.
//

import UIKit

class UrgenceController: UITableViewController {

    let urgence = ["Samu - 15","Police Secour - 17","Pompiers - 18","Général - 112"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return urgence.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUrgence", for: indexPath)as! UrgenceTableViewCell
        cell.numLabel.text = urgence[(indexPath as NSIndexPath).row]
        cell.telephoneImageView.image = UIImage(named: "Telephone")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let number = "15"
        switch indexPath.row {
        case 0:
            print("Appel Samu")
            if let url = URL(string: "telprompt://\(number)") {
                UIApplication.shared.openURL(url)
            }
        case 1:
            print("Appel Police Secour")
            if let url = URL(string: "telprompt://17") {
                UIApplication.shared.openURL(url)
            }
        case 2:
            print("Appel Pompiers")
            if let url = URL(string: "telprompt://18") {
                UIApplication.shared.openURL(url)
            }
        case 3:
            print("Appel Général")
            if let url = URL(string: "telprompt://112") {
                UIApplication.shared.openURL(url)
            }
        default:
            print("Error TableView")
        }

    }
}

class UrgenceTableViewCell : UITableViewCell {
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var telephoneImageView: UIImageView!
    
}
