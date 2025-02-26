//
//  FilteredPlayersList.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct FilteredPlayersList: View {
    let teamName: String
    @Query(FetchDescriptor<Player>(sortBy: [SortDescriptor(\Player.name, order: .forward)])) private var listOfAllPlayersInDatabase: [Player]
    
    var filteredPlayers: [Player] {
        listOfAllPlayersInDatabase.filter { $0.team == teamName }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredPlayers) { player in
                    NavigationLink(destination: PlayerDetails(player: player)) {
                        PlayerItem(player: player)
                    }
                }
            }
            .navigationTitle("Favorite \(teamName) Players")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}
