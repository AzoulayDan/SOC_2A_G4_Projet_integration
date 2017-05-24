//
//  MenuInfosController.swift
//  J.O.Infos
//
//  Created by joffrey pijoan on 23/05/2017.
//  Copyright © 2017 joffrey pijoan. All rights reserved.
//

import UIKit

class MenuInfosController: UITableViewController {
    
    let menus = ["Plan","Planning","Paiement","Urgence","Borne","Autres Informations"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menus"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menus.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MenuInfosCell
        cell.titleMenuLabel.text = menus[indexPath.row]
        cell.imageTitreMenu.image = UIImage(named: menus[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Plan")
            performSegue(withIdentifier: "segueToPlan", sender: nil)
        case 1:
            print("Planning")
            performSegue(withIdentifier: "segueToPlanning", sender: nil)
        case 2:
            print("Paiement")
            performSegue(withIdentifier: "segueToPaiment", sender: nil)
        case 3:
            print("Urgence")
            performSegue(withIdentifier: "segueToUrgence", sender: nil)
        case 4:
            print("Borne d'accueil")
            performSegue(withIdentifier: "segueToBA", sender: nil)
        case 5:
            print("Autres Informations")
        default:
            print("Error en dehors des clous")
        }
    }
}

class MenuInfosCell : UITableViewCell {
    @IBOutlet weak var titleMenuLabel: UILabel!
    
    @IBOutlet weak var imageTitreMenu: UIImageView!
}
