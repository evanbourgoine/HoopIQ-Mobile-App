//
//  PlayerSearchResultsList.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//


import SwiftUI

struct PlayerSearchResultsList: View {
    let results: [Player]

    var body: some View {
        List {
            ForEach(results) { aPlayer in
                //Generate book details and item files for the specific book
                NavigationLink(destination: PlayerDetails(player: aPlayer)) {
                    PlayerItem(player: aPlayer)
                }
            }
        }
        .navigationTitle("Database Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}
