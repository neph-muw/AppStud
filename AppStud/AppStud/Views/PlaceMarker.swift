//
//  SecondViewController.swift
//  AppStud
//
//  Created by Roman Mykitchak on 2/10/17.
//  Copyright © 2017 Roman Mykitchak. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    let place: GooglePlace
    
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate!
//        icon = UIImage(named: place.placeType+"_pin")
        icon = UIImage(named: "first")
        icon = place.photo
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = kGMSMarkerAnimationPop
    }
}

