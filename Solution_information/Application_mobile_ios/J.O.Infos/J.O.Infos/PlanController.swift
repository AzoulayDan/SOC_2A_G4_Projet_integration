//
//  PlanController.swift
//  J.O.Infos
//
//  Created by joffrey pijoan on 17/05/2017.
//  Copyright © 2017 joffrey pijoan. All rights reserved.
//

import UIKit
import MapKit

class PlanController: UIViewController, UITabBarDelegate, UITableViewDataSource{
    
    @IBOutlet weak var mapView: MKMapView!
    let url_request = "http://172.30.1.18:5000/lieu"
    
    let regionRadius: CLLocationDistance = 3000
    
    let legendePlan = ["Site Olympique","Restaurant","Hotel"]
    let legendeIcon = ["PlanStade", "PlanRestaurant","PlanMetro"]
    var artworks = [Artwork]()

    
    var tabArtwork = [Artwork]()
    var latitude = Double()
    var longitude = Double()
    var titrePlan = String()
    var subtitle = String()
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set initial location in Paris
        let initialLocation = CLLocation(latitude: 48.857193, longitude:  2.344117)
        centerMapOnLocation(initialLocation)
        
        loadPlan()
        mapView.delegate = self
        mapView.addAnnotations(artworks)
        print(artworks)
    }
    
    func loadPlan() {

        let get_request_result = RequestManager.do_get_request(atUrl: url_request)
        print(get_request_result)
        for element in get_request_result {
            let x = element["latitude"] as! NSString
            let latitude = x.doubleValue
            let y = element["longitude"] as! NSString
            let longitude = y.doubleValue
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let title = element["nom"]
            let type = element["type"]
            let testArtwork = Artwork(title: title as! String, discipline: type as! String, coordinate: coordinate)
            artworks.append(testArtwork)
        }
    }
    
    func loadInitialData() {
        // 1
        let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json");
        var data: Data?
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: fileName!), options: NSData.ReadingOptions(rawValue: 0))
        } catch _ {
            data = nil
        }
        
        // 2
        var jsonObject: Any? = nil
        if let data = data {
            do {
                jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
            } catch _ {
                jsonObject = nil
            }
        }
        
        // 3
        if let jsonObject = jsonObject as? [String: Any],
            // 4
            let jsonData = JSONValue.fromObject(object: jsonObject as AnyObject)?["data"]?.array {
            for artworkJSON in jsonData {
                if let artworkJSON = artworkJSON.array,
                    // 5
                    let artwork = Artwork.fromJSON(artworkJSON) {
                    artworks.append(artwork)
                }
            }
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legendePlan.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPlan", for: indexPath) as! PlanTableViewCell
        let list = legendePlan[indexPath.row]
        let listIcon = legendeIcon[indexPath.row]
        cell.planLabel.text = list
        cell.planImageView.image = UIImage(named: listIcon)
        return cell
    }
    
}

class PlanTableViewCell : UITableViewCell {
    @IBOutlet weak var planLabel: UILabel!
    
    @IBOutlet weak var planImageView: UIImageView!
}

