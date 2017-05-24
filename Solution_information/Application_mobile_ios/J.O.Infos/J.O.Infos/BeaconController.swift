//
//  BeaconController.swift
//  J.O.Infos
//
//  Created by joffrey pijoan on 23/05/2017.
//  Copyright © 2017 joffrey pijoan. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        startScanningForBeaconRegion(beaconRegion: getBeaconRegion())
    }
    
    func getBeaconRegion() -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion.init(proximityUUID: UUID.init(uuidString: "623C4C56-34E7-4E55-9257-BDE28C1CC51A")!,
                                               identifier: "TestiBeacon")
        return beaconRegion
    }
    
    func startScanningForBeaconRegion(beaconRegion: CLBeaconRegion) {
        print(beaconRegion)
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    // Delegate Methods
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let beacon = beacons.last
        
        if beacons.count > 0 {
            if beacon?.proximity == CLProximity.unknown {
                distanceLabel.text = "Position Inconnu"
            } else if beacon?.proximity == CLProximity.immediate {
                distanceLabel.text = "Borne très proche"
            } else if beacon?.proximity == CLProximity.near {
                distanceLabel.text = "Borne a proximité"
            } else if beacon?.proximity == CLProximity.far {
                distanceLabel.text = "Borne éloigné"
            }
        } else {
            distanceLabel.text = ""
        }
        
        print("Ranging")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
