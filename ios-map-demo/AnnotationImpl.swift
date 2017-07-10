//
//  AnnotationDemo.swift
//  janowski-final-demo
//
//  Created by e on 6/2/17.
//  Copyright © 2017 DePaul University. All rights reserved.
//

import Foundation
import MapKit.MKAnnotation

class AnnotationImpl: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(_ l: CLLocationCoordinate2D, _ t: String?, _ s: String?) {
        self.coordinate = l
        self.title = t
        self.subtitle = s
        super.init()
    }
}
