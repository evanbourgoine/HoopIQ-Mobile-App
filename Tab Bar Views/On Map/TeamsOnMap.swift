//
//  TeamsOnMap.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//


import SwiftUI
import CoreLocation
import MapKit
import SwiftData

struct Location: Identifiable {
    var id = UUID()
    var team: Team
    var coordinate: CLLocationCoordinate2D
}

struct TeamsOnMap: View {
    // Fetch all teams from the SwiftData database
    @Query(sort: \Team.name) private var listOfAllTeamsInDatabase: [Team]
    
    @State private var mapCameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 39.8283, // Geographic center of the US
                longitude: -98.5795
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 40.0,
                longitudeDelta: 40.0
            )
        )
    )
    
    var annotations: [Location] {
        listOfAllTeamsInDatabase.map { team in
            Location(team: team, coordinate: CLLocationCoordinate2D(latitude: team.latitude, longitude: team.longitude))
        }
    }
    
    var body: some View {
        NavigationStack {
            Map(position: $mapCameraPosition) {
                ForEach(annotations) { loc in
                    Annotation(loc.team.name, coordinate: loc.coordinate) {
                        AnnotationView(team: loc.team)
                    }
                }
            }
            .mapStyle(.standard)
            .navigationTitle("NBA Teams on Map")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

/*
 ==============================
 |   Custom Annotation View   |
 ==============================
 */
struct AnnotationView: View {
    let team: Team
    @State private var showTeamName = false
    
    var body: some View {
        VStack(spacing: 0) {
            if showTeamName {
                NavigationLink(destination: TeamDetails(team: team)) {
                    Text(team.name)
                        .font(.caption)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(10)
                        .fixedSize(horizontal: true, vertical: false) // Prevent truncation
                }
            }
            Image(team.logoFilename)
                .resizable() 
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showTeamName.toggle()
                    }
                }
        }
    }
}
