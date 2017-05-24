//
//  PlanningController.swift
//  J.O.Infos
//
//  Created by joffrey pijoan on 18/05/2017.
//  Copyright © 2017 joffrey pijoan. All rights reserved.
//

import UIKit

class PlanningController: UITableViewController {
    
    let url_request = "http://172.30.1.18:5000/planning"
    var date : [String] = []
    var heure : [String] = []
    var event : [String] = []
    var site : [String] = []

    override func viewDidLoad() {
        loadPlannig()
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPlannig () {
        let get_request_result = RequestManager.do_get_request(atUrl: url_request)
        print(get_request_result)
        for element in get_request_result {
            date.append((element["date"] as! NSString)as String)
            heure.append((element["heure"]as! NSString)as String)
            event.append((element["evenement"]as! NSString)as String)
            site.append((element["lieu"]as! NSString)as String)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return date.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPlanning", for: indexPath) as! PlanningCell
        cell.dateLabel.text = date[indexPath.row]
        cell.heureLabel.text = heure[indexPath.row]
        cell.eventLabel.text = event[indexPath.row]
        cell.siteLabel.text = site[indexPath.row]
        return cell
    }
}
