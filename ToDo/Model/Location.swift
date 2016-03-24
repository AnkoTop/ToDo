//
//  Location.swift
//  ToDo
//
//  Created by Anko Top on 22/03/16.
//  Copyright © 2016 Anko Top. All rights reserved.
//

import Foundation
import CoreLocation

struct Location : Equatable {
    
    let name : String
    let coordinate : CLLocationCoordinate2D?
    
    init (name: String, coordinate : CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }

}

// Conform to Equatable protocol
func ==(lhs: Location, rhs: Location) -> Bool {
    
    if lhs.coordinate?.latitude != rhs.coordinate?.latitude {
    
        return false
    
    }
    
    if lhs.coordinate?.longitude != rhs.coordinate?.longitude {
      
        return false
   
    }
    
    if lhs.name != rhs.name {
        
        return false
    
    }
    
    return true
}

