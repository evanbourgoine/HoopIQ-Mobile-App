//
//  DatabaseSearch.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//


import SwiftUI
import SwiftData

//NOTE: Print statements adding as debugging technique to
//further understand database search

//Create one modelContainer to handle both Book and Photos database
class DatabaseSearchManager {
    var modelContainer: ModelContainer?
    var databaseTeamSearchResults = [Team]()
    var databasePlayerSearchResults = [Player]()

    init() {
        do {
            modelContainer = try ModelContainer(for: Team.self, Player.self)
            print("ModelContainer initialized successfully.")
        } catch {
            fatalError("Unable to create ModelContainer: \(error)")
        }
    }

    func conductTeamDatabaseSearch(searchCat: String, searchQuery: String) {
        print("Conducting Team Database Search...")

        guard let modelContainer = modelContainer else {
            print("ModelContainer is nil. Cannot perform search.")
            return
        }

        let modelContext = ModelContext(modelContainer)
        databaseTeamSearchResults = []

        var searchPredicate: Predicate<Team>?
        
        //Switch to cases depending on category selected
        switch searchCat {
        case "Team Name":
            searchPredicate = #Predicate<Team> {
                $0.name.localizedStandardContains(searchQuery)
            }
        case "Team Location":
            searchPredicate = #Predicate<Team> {
                $0.city.localizedStandardContains(searchQuery)
            }
        case "Team Conference":
            searchPredicate = #Predicate<Team> {
                $0.conference.localizedStandardContains(searchQuery)
            }
        case "Team Division":
            searchPredicate = #Predicate<Team> {
                $0.division.localizedStandardContains(searchQuery)
            }
        case "Team Championships ≥":
            if let pageField = Int(searchQuery) {
                searchPredicate = #Predicate<Team> {
                    $0.championships >= pageField
                }
            }
        case "Team Championships ≤":
            if let pageField = Int(searchQuery) {
                searchPredicate = #Predicate<Team> {
                    $0.championships <= pageField
                }
            }
        default:
            fatalError("Search category is out of range!")
        }

        //Sort Book elements by authors, and then by Book title
        let fetchDescriptor = FetchDescriptor<Team>(
            predicate: searchPredicate,
            sortBy: [SortDescriptor(\Team.name, order: .forward)
            ]
        )

        do {
            databaseTeamSearchResults = try modelContext.fetch(fetchDescriptor)
            print("Fetched \(databaseTeamSearchResults.count) team(s).")
        } catch {
            print("Error fetching data from the database: \(error)")
        }
    }

    //Similar function to Book but now with Photos
    func conductPlayerDatabaseSearch(searchCat: String, searchQuery: String) {
        print("Conducting Player Database Search...")

        guard let modelContainer = modelContainer else {
            print("ModelContainer is nil. Cannot perform search.")
            return
        }

        let modelContext = ModelContext(modelContainer)
        databasePlayerSearchResults = []

        //Cases depending on Photo category selected
        var searchPredicate: Predicate<Player>?
        switch searchCat {
        case "Player Name":
            searchPredicate = #Predicate<Player> {
                $0.name.localizedStandardContains(searchQuery)
            }
        case "Player Team":
            searchPredicate = #Predicate<Player> {
                $0.team.localizedStandardContains(searchQuery)
            }
        case "Player Position":
            searchPredicate = #Predicate<Player> {
                $0.position.localizedStandardContains(searchQuery)
            }
        case "Player College":
            searchPredicate = #Predicate<Player> {
                $0.college.localizedStandardContains(searchQuery)
            }
        default:
            fatalError("Search category is out of range!")
        }

        let fetchDescriptor = FetchDescriptor<Player>(
            predicate: searchPredicate,
            sortBy: [SortDescriptor(\Player.name, order: .forward),
            ]
        )

        do {
            databasePlayerSearchResults = try modelContext.fetch(fetchDescriptor)
            print("Fetched \(databasePlayerSearchResults.count) player(s).")
        } catch {
            print("Error fetching data from the database: \(error)")
        }
    }
}
