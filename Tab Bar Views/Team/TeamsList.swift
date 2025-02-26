//
//  TeamsList.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct TeamsList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Team>(sortBy: [SortDescriptor(\Team.name, order: .forward)])) private var listOfAllTeamsInDatabase: [Team]
    
    @State private var showConfirmation = false
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                // Goes through each book found with a specific target
                // and populate the list
                ForEach(filteredTeams) { aTeam in NavigationLink(destination: TeamDetails(team: aTeam)) {
                    TeamItem(team: aTeam)
                } // End of NavigationLink
                } // End of ForEach
            } // End of List
            .navigationTitle("Professional Teams")
            .toolbarTitleDisplayMode(.inline)
        } // End of NavigationStack
        .searchable(text: $searchText, prompt: "Search a Professional Team")
    } // End of body var
    
    // Returns a list of book objects that contain data that we are looking for
    var filteredTeams: [Team] {
        if searchText.isEmpty {
            listOfAllTeamsInDatabase
        } else {
            listOfAllTeamsInDatabase.filter {
                $0.name.localizedStandardContains(searchText) ||
                $0.conference.localizedStandardContains(searchText) ||
                $0.division.localizedStandardContains(searchText)
            }
        }
    }
}
