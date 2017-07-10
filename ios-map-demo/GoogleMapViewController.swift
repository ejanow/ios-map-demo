//
//  GoogleMapViewController.swift
//  janowski-final-demo
//
//  Created by e on 6/1/17.
//  Copyright © 2017 DePaul University. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {
    
    var mapView: GMSMapView!
    var toStreetViewButton: UIButton!
    var toMapButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView() // must be called first!
        
        setCustomMapStyle()
        setMarkers()
    }
    
    private func makeGoogleMap() {
        let camera =
            GMSCameraPosition.camera(withTarget: Fixtures.WRIGLEY_FIELD,
                                     zoom: 12.0)
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView = mapView
        self.view = mapView
        mapView.addSubview(toStreetViewButton)
        moveToJohnHancock()
    }
    
    private func setMarkers() {
        
        let wrigley = GMSMarker(position: Fixtures.WRIGLEY_FIELD)
        let johnHancock = GMSMarker(position: Fixtures.JOHN_HANCOCK)
        
        wrigley.title = "Wrigley Field"
        wrigley.snippet = "Where the cubs play"
        johnHancock.title = "John Hancock"
        johnHancock.snippet = "Tall Building"
        
        wrigley.map = mapView
        johnHancock.map = mapView
        
    }
    
    private func setCustomMapStyle() {
        do {
            guard let filePath = Bundle.main.url(forResource: "GoogleMapStyle", withExtension: "json")
                else { return }
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: filePath)
        } catch {
            print("Error setting style!")
        }
    }
    
    @objc private func goToStreetView() {
        let currentLoc = mapView.camera.target
        let panoView = GMSPanoramaView(frame: .zero)
        self.view = panoView
        panoView.moveNearCoordinate(currentLoc)
        panoView.addSubview(toMapButton)
        
    }
    
    @objc private func goToMap() {
        self.view = self.mapView
    }
    
    private func createButtons() {
        
        let w = CGFloat(225)
        let h = CGFloat(50)
        
        let x = self.view.frame.maxX - 250
        let y = self.view.frame.maxY - 75
        
        let toSv = UIButton(frame: CGRect(x: x, y: y, width: w, height: h))
        let toMap = UIButton(frame: CGRect(x: x, y: y - 500, width: w, height: h))
        toSv.setTitle("Go To Street View", for: .normal)
        toMap.setTitle("Go Back To Map", for: .normal)
        
        toSv.addTarget(self, action: #selector(self.goToStreetView), for: .touchUpInside)
        toMap.addTarget(self, action: #selector(self.goToMap), for: .touchUpInside)
        
        toSv.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        toMap.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        
        self.toStreetViewButton = toSv
        self.toMapButton = toMap
    }
    
    private func initView() {
        self.createButtons()
        self.makeGoogleMap()
    }
    
    private func moveToJohnHancock() {
        let camera = GMSCameraPosition.camera(withTarget: Fixtures.JOHN_HANCOCK, zoom: 15.0)
        mapView.camera = camera
    }
}
