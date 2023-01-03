//
//  LandMark.swift
//  Ofood
//
//  Created by funghi on 2023/1/3.
//

import Foundation

import MapKit

struct Landmark: Identifiable, Hashable {
    let placemark: MKPlacemark
    
    let id = UUID()
    
    var name: String {
        self.placemark.name ?? ""
    }
    
    var title: String {
        self.placemark.title ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
}
