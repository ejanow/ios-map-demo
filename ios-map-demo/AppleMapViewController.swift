//
//  AppleMapViewController.swift
//  janowski-final-demo
//
//  Created by e on 6/1/17.
//  Copyright © 2017 DePaul University. All rights reserved.
//

import UIKit
import MapKit

class AppleMapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var toDirectionsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        createButtons()
        setMapDisplay()
        setMapFocus()
        addAnnotations()
        //set3DView()
    }
    
    private func setMapDisplay() {
        
        let mapView = MKMapView(frame: .zero)
        
        mapView.mapType = .standard
        mapView.showsPointsOfInterest = false
        mapView.showsBuildings = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        mapView.addSubview(self.toDirectionsButton)
        mapView.delegate = self
        
        self.mapView = mapView
        self.view = mapView
    }
    
    private func addAnnotations() {
        
        let wrigley = AnnotationImpl(Fixtures.WRIGLEY_FIELD, "Wrigley Field", "A baseball park where the Cubs play")
        let johnHancock = AnnotationImpl(Fixtures.JOHN_HANCOCK, "John Hancock Building", "A tall building in Chicago")
        
        mapView.addAnnotation(wrigley)
        mapView.addAnnotation(johnHancock)
    }
    
    private func setMapFocus() {
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let coordinateRegion =
            MKCoordinateRegion(center: Fixtures.WRIGLEY_FIELD, span: coordinateSpan)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func set3DView() {
        guard mapView.isPitchEnabled else { return }
        
        let camera =
        MKMapCamera(lookingAtCenter: Fixtures.WRIGLEY_FIELD,
                    fromDistance: 1000,
                    pitch: 20,
                    heading: 0)
        
        mapView.setCamera(camera, animated: true)
    }
    
    private func createButtons() {
        let w = CGFloat(155)
        let h = CGFloat(50)
        
        let toDir = UIButton(frame: CGRect(x: self.view.frame.maxX - 250, y: self.view.frame.maxY - 75, width: w, height: h))
        toDir.setTitle("Show Directions", for: .normal)
        
        toDir.addTarget(self, action: #selector(self.getDirections), for: .touchUpInside)
        
        toDir.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        self.toDirectionsButton = toDir
    }
    
    @objc private func getDirections() {
        let origin = MKMapItem(placemark: MKPlacemark(coordinate: Fixtures.WRIGLEY_FIELD))
        let dest = MKMapItem(placemark: MKPlacemark(coordinate: Fixtures.JOHN_HANCOCK))
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = origin
        directionsRequest.destination = dest
        directionsRequest.requestsAlternateRoutes = false
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { res, err in
            guard let routes = res?.routes else { return }
            self.addDirectionsToMap(routes)
        }
    }
    
    private func addDirectionsToMap(_ routes: [MKRoute]) {
        guard let route = routes.first else { return }
        self.mapView.add(route.polyline)
        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.fillColor = UIColor.blue
        
        return renderer
    }
}
