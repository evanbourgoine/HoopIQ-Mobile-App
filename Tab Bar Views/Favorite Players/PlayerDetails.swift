//
//  PlayerDetails.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//


import SwiftUI

struct PlayerDetails: View {
    
    // Input Parameter
    let player: Player
    
    @State private var showAlertMessage = false
    
    var body: some View {
        
        return AnyView(
            Form {
                Section(header: Text("Player Name")) {
                    Text(player.name)
                }
                Section(header: Text("Associated Team")) {
                    Text(player.team)
                }
                Section(header: Text("Jersey Number")) {
                    Text(String(player.number))
                }
                Section(header: Text("Player Image")) {
                    if player.photoFilename.hasSuffix(".png") {
                        getImageFromUrl(url: player.photoFilename, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                            .frame(minWidth: 300, maxWidth: 320, alignment: .center)
                            .contextMenu {
                                Button(action: {        // Context Menu Item
                                    // Copy the logo image to universal clipboard for pasting elsewhere
                                    UIPasteboard.general.image = UIImage(contentsOfFile: player.photoFilename)
                                    
                                    showAlertMessage = true
                                    alertTitle = "Team Logo is Copied to Clipboard"
                                    alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                                }) {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy")
                                }
                            }
                    }
                    else if (player.photoFilename.hasSuffix(".jpg") || player.photoFilename.hasSuffix(".jpeg")) {
                        getImageFromDocumentDirectory(filename: player.photoFilename.components(separatedBy: ".")[0], fileExtension: player.photoFilename.components(separatedBy: ".")[1], defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    }
                    else {
                        Image(player.photoFilename)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                            .frame(minWidth: 300, maxWidth: 320, alignment: .center)
                            .contextMenu {
                                Button(action: {        // Context Menu Item
                                    // Copy the logo image to universal clipboard for pasting elsewhere
                                    UIPasteboard.general.image = UIImage(contentsOfFile: player.photoFilename)
                                    
                                    showAlertMessage = true
                                    alertTitle = "Team Logo is Copied to Clipboard"
                                    alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                                }) {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy")
                                }
                            }
                    }
                }
                Section(header: Text("Player Position")) {
                    Text(player.position)
                }
                Section(header: Text("Players Birth Date")) {
                    Text(String(player.birthDate))
                }
                Section(header: Text("Player Height")) {
                    Text(player.height)
                }
                Section(header: Text("Player College")) {
                    Text(player.college)
                }
                Section(header: Text("Player Nationaility")) {
                    Text(player.nationality)
                }
            }   // End of Form
                .navigationTitle("\(player.name) Details")
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
