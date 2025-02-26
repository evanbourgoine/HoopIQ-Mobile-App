//
//  PlayersList.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//


import SwiftUI
import SwiftData

struct PlayersList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Player>(sortBy: [SortDescriptor(\Player.name, order: .forward)])) private var listOfAllPlayersInDatabase: [Player]
    
    @State private var showConfirmation = false
    @State private var toBeDeleted: IndexSet?
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                // Goes through each book found with a specific target
                // and populate the list
                ForEach(filteredPlayers) { aPlayer in NavigationLink(destination: PlayerDetails(player: aPlayer)) {
                    PlayerItem(player: aPlayer)
                        .alert(isPresented: $showConfirmation) {
                            Alert(title: Text("Delete Confirmation"),
                                  message: Text("Are you sure to permanently delete the player?"),
                                  primaryButton: .destructive(Text("Delete")) {
                                /*
                                 'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                 element to be deleted. It is nil if the array is empty. Process it as an optional.
                                 */
                                if let index = toBeDeleted?.first {
                                    let playerToDelete = listOfAllPlayersInDatabase[index]
                                    modelContext.delete(playerToDelete)
                                }
                                toBeDeleted = nil
                            }, secondaryButton: .cancel() {
                                toBeDeleted = nil
                            }
                            )
                        }
                } // End of NavigationLink
                } // End of ForEach
                .onDelete(perform: delete)
            } // End of List
            .navigationTitle("Favorite NBA Players")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                // Place the Add (+) button on right side of the toolbar
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddPlayer()) {
                        Image(systemName: "plus")
                    }
                }
            }
        } // End of NavigationStack
        .searchable(text: $searchText, prompt: "Search a Favorite Player")
    } // End of body var
    
    // Returns a list of book objects that contain data that we are looking for
    var filteredPlayers: [Player] {
        if searchText.isEmpty {
            listOfAllPlayersInDatabase
        } else {
            listOfAllPlayersInDatabase.filter {
                $0.name.localizedStandardContains(searchText) ||
                $0.team.localizedStandardContains(searchText) ||
                $0.position.localizedStandardContains(searchText)
            }
        }
    }
    
    private func delete(offsets: IndexSet) {
        toBeDeleted = offsets
        showConfirmation = true
    }
}
