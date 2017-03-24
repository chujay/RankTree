//
//  MapViewController.swift
//  RankTree
//
//  Created by Chujay on 22/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

//    Q.  requestDirections(??:completion:[<Route>])
//    >
//    > 1. <Route> is the type of route objects in swift.
//    > 2. Fill in what parameters you need for ?? field.
    
    typealias requestDirection = ([MKRoute]?, Error?) -> Void
    func requestDirections(from source: MKMapItem, destination: MKMapItem, transportType: MKDirectionsTransportType, completion: @escaping requestDirection) {
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = source
        directionRequest.destination = destination
        directionRequest.transportType = transportType
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: { (response, error) -> Void in
            guard let response = response else {
                print("error")
                return
            }
            completion(response.routes, error)
            
        })
        
        
    }
    
    
    
    
}
