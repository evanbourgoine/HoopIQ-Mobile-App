//
//  TeamDetails.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import MapKit
import SwiftData

fileprivate var teamLocationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct TeamDetails: View {
    
    // Input Parameter
    let team: Team
    
    @Query(sort: \Player.name) private var listOfAllPlayersInDatabase: [Player]
    
    @State private var showAlertMessage = false
    
    @State private var selectedMapStyleIndex = 0
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    
    var filteredPlayers: [Player] {
            listOfAllPlayersInDatabase.filter { $0.team == team.name }
        }
    
    var body: some View {
        
        teamLocationCoordinate = CLLocationCoordinate2D(latitude: team.latitude, longitude: team.longitude)
        
        return AnyView(
            Form {
                    Section(header: Text("Team Name")) {
                        Text(team.name)
                    }
                    Section(header: Text("Team Location")) {
                        Text(team.city)
                    }
                    Section(header: Text("Team Logo")) {
                        
                        Image(team.logoFilename)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                            .frame(minWidth: 300, maxWidth: 320, alignment: .center)
                            .contextMenu {
                                Button(action: {        // Context Menu Item
                                    // Copy the logo image to universal clipboard for pasting elsewhere
                                    UIPasteboard.general.image = UIImage(contentsOfFile: team.logoFilename)
                                    
                                    showAlertMessage = true
                                    alertTitle = "Team Logo is Copied to Clipboard"
                                    alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                                }) {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy")
                                }
                            }
                    }
                Section(header: Text("Favorite Players on Team")) {
                    if filteredPlayers.isEmpty {
                        Text("There are currently no favorite players on this team.")
                    } else {
                        NavigationLink(destination: FilteredPlayersList(teamName: team.name)) {
                            HStack {
                                Image(systemName: "person.text.rectangle")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("View Favorite Players on Team")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(Color.blue)
                        }
                    }
                }
                Section(header: Text("Team Conference")) {
                    Text(team.conference)
                }
                Section(header: Text("Team Division")) {
                    Text(team.division)
                }
                Section(header: Text("Team Website")) {
                    // Show company's website externally in default web browser
                    Link(destination: URL(string: team.websiteUrl)!) {
                        HStack {
                            Image(systemName: "globe")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Team Website")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
                Section(header: Text("Championships Won")) {
                    Text(String(team.championships))
                }
                Section(header: Text("Team Arena")) {
                    VStack {
                        Text(team.homeArena)
                        getImageFromUrl(url: team.arenaImageUrl, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                            .frame(minWidth: 300, maxWidth: 320, alignment: .center)
                            .contextMenu {
                                Button(action: {        // Context Menu Item
                                    // Copy the arena image to universal clipboard for pasting elsewhere
                                    UIPasteboard.general.image = UIImage(contentsOfFile: team.logoFilename)
                                    
                                    showAlertMessage = true
                                    alertTitle = "Team Arena is Copied to Clipboard"
                                    alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                                }) {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy")
                                }
                            }
                    }
                }
                Section(header: Text("Team Arena On Map")) {
                    
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    NavigationLink(destination: TeamLocationOnMap(team: team, mapStyleIndex: selectedMapStyleIndex)) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Team Arena Location on Map")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(Color.blue)
                    }
                }
                Section(header: Text("Team Head Coach")) {
                    Text(team.headCoach)
                }
                Section(header: Text("Team Primary Colors")) {
                    Text(team.teamColors)
                }
                Section(header: Text("Team Social Media Links")) {
                    List {
                        HStack {
                            Image("Instagram")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40.0)
                            Link("\(team.name) Instagram Account", destination: URL(string: team.instagramUrl)!)
                        }
                        HStack {
                            Image("Twitter")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40.0)
                            Link("\(team.name) Twiter Account", destination: URL(string: team.twitterUrl)!)
                        }
                    }
                }
            }   // End of Form
                .navigationTitle("\(team.name) Details")
            .toolbarTitleDisplayMode(.inline)
            .font(.system(size: 14))
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        )   // End of AnyView
    }   // End of body var
}

struct TeamLocationOnMap: View {
    
    // Input Parameters
    let team: Team
    let mapStyleIndex: Int
    
    @State private var mapCameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            // landmarkLocationCoordinate is a fileprivate var
            center: teamLocationCoordinate,
            // 1 degree = 69 miles.
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1)
        )
    )
    
    var body: some View {
        
        var mapStyle: MapStyle = .standard
        
        switch mapStyleIndex {
        case 0:
            mapStyle = MapStyle.standard
        case 1:
            mapStyle = MapStyle.imagery     // Satellite
        case 2:
            mapStyle = MapStyle.hybrid
        case 3:
            mapStyle = MapStyle.hybrid(elevation: .realistic)   // Globe
        default:
            print("Map style is out of range!")
        }
        
        return AnyView(
            Map(position: $mapCameraPosition) {
                Marker(team.homeArena, coordinate: teamLocationCoordinate)
            }
                .mapStyle(mapStyle)
                .navigationTitle(team.name)
                .toolbarTitleDisplayMode(.inline)
        )
    }   // End of body var
}

