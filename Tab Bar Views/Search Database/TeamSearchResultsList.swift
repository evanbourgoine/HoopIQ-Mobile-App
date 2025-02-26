//
//  TeamSearchResultsList.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//


import SwiftUI

struct TeamSearchResultsList: View {
    let results: [Team]

    var body: some View {
        List {
            ForEach(results) { aTeam in
                NavigationLink(destination: TeamDetails(team: aTeam)) {
                    TeamItem(team: aTeam)
                }
            }
        }
        .navigationTitle("Database Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}
