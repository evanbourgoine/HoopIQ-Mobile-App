//
//  DirectionsOnMap.swift
//  HoopIQ
//
//  Created by Osman Balci on 9/4/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import MapKit

struct DirectionsOnMap: View {
    
    // Input Parameters
    let selectedTransportTypeIndex: Int
    let startCoordinate: CLLocationCoordinate2D
    let endCoordinate: CLLocationCoordinate2D
    
    @State private var route: MKRoute? = nil
    @State private var routeMapPosition: MapCameraPosition = .automatic
    
    var body: some View {
        
        var transportType: MKDirectionsTransportType = .automobile
       
        switch selectedTransportTypeIndex {
        case 0:
            transportType = MKDirectionsTransportType.automobile
        case 1:
            transportType = MKDirectionsTransportType.transit
        case 2:
            transportType = MKDirectionsTransportType.walking
        default:
            print("Transport type is out of range!")
        }
        
        // Instantiate a new MKDirections Request object
        let request = MKDirections.Request()
        
        // Dress up the newly created Request object
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endCoordinate))
        request.transportType = transportType
        
        Task {
            // Instantiate a new MKDirections object initialized with the Request object created above
            let directions = MKDirections(request: request)
            /*
             Try to calculate the directions and wait for its completion.
             This is a time consuming task. If it is executed too frequently,
             it produces the 'Throttled "Directions" request' error message.
             */
            let response = try? await directions.calculate()
            
            // Process the response optionally to obtain the route
            if let responseObtained = response {
                route = responseObtained.routes.first
            } else {
                // A large map is displayed indicating unsuccessful result.
            }
        }
        
        return AnyView(
            Map(position: $routeMapPosition) {
                if let route {
                    MapPolyline(route)
                        .stroke(.red, lineWidth: 5)
                } else {
                    /*
                     A large map is displayed indicating unsuccessful result.
                     "route" may not be obtained due to transport type or being unable
                     to compute the directions for the given start and end coordinates.
                     */
                }
            }
        )
        
    }   // End of body var
}


