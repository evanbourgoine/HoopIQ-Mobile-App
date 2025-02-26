//
//  SearchApiDetails.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct SearchApiDetails: View {
    let player: PlayerStruct
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showAlertMessage = false
    
    var body: some View {
        Form {
            Group {
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
                Section(header: Text("Add Player To Favorites")) {
                    Button(action: {
                        savePlayerToDatabaseAsFavorite()
                        
                        showAlertMessage = true
                        alertTitle = "Player Added!"
                        alertMessage = "Selected Player is added to the database as your favorite."
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Add Player to Database")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
            } // End of Group
        } // End of Form
        .font(.system(size: 14))
        .navigationTitle("Player Details")
        .toolbarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {
                if alertTitle == "Player Added!" {
                    // Dismiss this view and go back to the previous view
                    dismiss()
                }
            }
        }, message: {
            Text(alertMessage)
        })
        
        
    } // End of body var
    
    func savePlayerToDatabaseAsFavorite() {
        let newPlayer = Player(name: player.name, team: player.team, photoFilename: player.photoFilename, position: player.position, birthDate: player.birthDate, height: player.height, college: player.college, number: player.number, nationality: player.nationality)
        
        modelContext.insert(newPlayer)
        
        do {
            try modelContext.save()
        } catch {
            fatalError("Unable to save database changes")
        }
    }
    
}
