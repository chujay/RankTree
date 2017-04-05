//
//  MapViewController.swift
//  RankTree
//
//  Created by Chujay on 22/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import IBAnimatable
import EasyAnimation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var otherButton: AnimatableButton!
    @IBOutlet weak var mainButton: AnimatableButton!
    @IBOutlet weak var satelliteButton: AnimatableButton!
    @IBOutlet weak var hybridButton: AnimatableButton!
    var mapView: GMSMapView!
    var myLocation: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    func setUp() {
        self.myLocation = CLLocationManager()
        self.myLocation.delegate = self
        self.myLocation.distanceFilter = kCLLocationAccuracyNearestTenMeters
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.accessibilityElementsHidden = false
        self.mapView.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        self.view = mapView

        self.view.addSubview(hybridButton)
        self.view.addSubview(satelliteButton)
        self.view.addSubview(otherButton)
        self.view.addSubview(mainButton)
        self.otherButton.maskType = .circle
        self.mainButton.maskType = .circle
        self.hybridButton.maskType = .circle
        self.satelliteButton.maskType = .circle
        self.otherButton.center = self.mainButton.center
        self.hybridButton.center = self.mainButton.center
        self.satelliteButton.center = self.mainButton.center
        self.mainButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        self.otherButton.addTarget(self, action: #selector(showMapType), for: .touchUpInside)
        self.satelliteButton.addTarget(self, action: #selector(showMapType), for: .touchUpInside)
        self.hybridButton.addTarget(self, action: #selector(showMapType), for: .touchUpInside)

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways {
            self.mapView.isMyLocationEnabled = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let myLocation = change?[NSKeyValueChangeKey.newKey] as? CLLocationCoordinate2D else { return }
        self.mapView.camera = GMSCameraPosition.camera(withTarget: myLocation, zoom: 10.0)
        self.mapView.settings.myLocationButton = true
    }
    
    func showMenu(_ sender: Any) {
        self.mainButton.pop(repeatCount: 1)
        if self.otherButton.center == self.mainButton.center {
            UIView.animate(withDuration: 0.5, animations: {
                self.otherButton.center.y += 75
                self.hybridButton.center.y += 150
                self.satelliteButton.center.y += 225
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.otherButton.center = self.mainButton.center
                self.hybridButton.center = self.mainButton.center
                self.satelliteButton.center = self.mainButton.center
            })
        }
    }
    func showMapType(_ sender: AnimatableButton) {
        switch sender {
        case self.otherButton:
            self.mapView.mapType = .normal
        case self.hybridButton:
            self.mapView.mapType = .hybrid
        case self.satelliteButton:
            self.mapView.mapType = .satellite
        default:
            self.mapView.mapType = .normal
        }
    }
}
