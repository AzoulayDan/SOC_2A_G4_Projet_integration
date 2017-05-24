//
//  Artwork.swift
//  J.O.Infos
//
//  Created by joffrey pijoan on 17/05/2017.
//  Copyright © 2017 joffrey pijoan. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation {
  let title: String?
  let discipline: String
  let coordinate: CLLocationCoordinate2D
  
  init(title: String, discipline: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.discipline = discipline
    self.coordinate = coordinate
    
    super.init()
  }
  
  class func fromJSON(_ json: [JSONValue]) -> Artwork? {
    // 1
    var title: String
    if let titleOrNil = json[0].string {
      title = titleOrNil
    } else {
      title = ""
    }
    let discipline = json[1].string
    
    // 2
    let latitude = (json[2].string! as NSString).doubleValue
    let longitude = (json[3].string! as NSString).doubleValue
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
    // 3
    return Artwork(title: title, discipline: discipline!, coordinate: coordinate)
  }
  
  var subtitle: String? {
    return title
  }
  
  // MARK: - MapKit related methods
  
  // pinTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
  func pinTintColor() -> UIColor  {
    switch discipline {
    case "Stade":
      return MKPinAnnotationView.redPinColor()
    case "Restaurant":
      return MKPinAnnotationView.greenPinColor()
    case "Hotel":
      return MKPinAnnotationView.purplePinColor()
    default:
      return MKPinAnnotationView.greenPinColor()
    }
  }
  
  // annotation callout opens this mapItem in Maps app
  func mapItem() -> MKMapItem {
    let addressDict = [CNPostalAddressStreetKey: subtitle!]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    
    return mapItem
  }
  
}
