//
//  SearchDatabase.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

var searchCat = ""
var searchQuery = ""
var typeOfDatabase = 0

struct SearchDatabase: View {
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    @State private var selectedCategoryIndex = 0
    @State private var selectedTeamIndex = 0
    @State private var selectedPlayerIndex = 0
    
    let searchManager = DatabaseSearchManager() // Create an instance of the manager
    
    let teamSearchCategoriesList = ["Team Name", "Team Location", "Team Conference", "Team Division", "Team Championships ≥", "Team Championships ≤"]
    let playerSearchCategoriesList = ["Player Name", "Player Team", "Player Position", "Player College"]
    let searchCategories = ["Team", "Player"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("SearchDatabase")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                Section(header: Text("Search")) {
                    Picker("", selection: $selectedCategoryIndex) {
                        ForEach(0 ..< searchCategories.count, id: \.self) {
                            Text(searchCategories[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedCategoryIndex) {
                        searchCompleted = false //reset search completed
                        searchFieldValue = "" //reset field value
                    }
                }
                if (selectedCategoryIndex == 0) {
                    Section(header: Text("Select A Search Category For Teams")) {
                        Picker("", selection: $selectedTeamIndex) {
                            ForEach(0 ..< teamSearchCategoriesList.count, id: \.self) {
                                Text(teamSearchCategoriesList[$0])
                            }
                        }
                    }
                    Section(header: Text("Search Query Under Selected Category")) {
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if searchFieldValue.isEmpty {
                                        showAlertMessage = true
                                        alertTitle = "Empty Query"
                                        alertMessage = "Please enter a search query!"
                                    }
                                }
                            Button(action: {
                                searchFieldValue = ""
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                    Section(header: Text("Search Database")) {
                        HStack {
                            Spacer()
                            Button(searchCompleted ? "Search Completed" : "Search") {
                                if inputDataValidated() {
                                    searchDB()
                                    searchCompleted = true
                                } else {
                                    showAlertMessage = true
                                }
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            
                            Spacer()
                        }
                    }
                    if searchCompleted {
                        Section(header: Text("List Teams Found")) {
                            NavigationLink(destination: showSearchResults) {
                                HStack {
                                    Image(systemName: "list.bullet")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                        .foregroundColor(.blue)
                                    Text("List Teams Found")
                                        .font(.system(size: 16))
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        Section(header: Text("Clear")) {
                            HStack {
                                Spacer()
                                Button("Clear", action: {
                                    searchFieldValue = ""
                                    searchCompleted = false
                                }
                                )
                                .tint(.blue)
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                                
                                Spacer()
                            }
                        }
                    }
                } else {
                    Section(header: Text("Select A Search Category For Players")) {
                        Picker("", selection: $selectedPlayerIndex) {
                            ForEach(0 ..< playerSearchCategoriesList.count, id: \.self) {
                                Text(playerSearchCategoriesList[$0])
                            }
                        }
                    }
                    Section(header: Text("Search Query Under Selected Category")) {
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if searchFieldValue.isEmpty {
                                        showAlertMessage = true
                                        alertTitle = "Empty Query"
                                        alertMessage = "Please enter a search query!"
                                    }
                                }
                            Button(action: {
                                searchFieldValue = ""
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                    Section(header: Text("Search Database")) {
                        HStack {
                            Spacer()
                            Button(searchCompleted ? "Search Completed" : "Search") {
                                if inputDataValidated() {
                                    searchDB()
                                    searchCompleted = true
                                } else {
                                    showAlertMessage = true
                                }
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            
                            Spacer()
                        }
                    }
                    if searchCompleted {
                        Section(header: Text("List Players Found")) {
                            NavigationLink(destination: showPhotoSearchResults) {
                                HStack {
                                    Image(systemName: "list.bullet")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                        .foregroundColor(.blue)
                                    Text("List Players Found")
                                        .font(.system(size: 16))
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        Section(header: Text("Clear")) {
                            HStack {
                                Spacer()
                                Button("Clear", action: {
                                    searchFieldValue = ""
                                    searchCompleted = false
                                }
                                )
                                .tint(.blue)
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                                
                                Spacer()
                            }
                        }
                    }
                }
            } // End of Form
            .font(.system(size: 14))
            .navigationTitle("Search Database")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        } // End of NavigationStack
    } // End of var body
    
    func searchDB() {
        print("Initiating search...")
        searchCompleted = false
        
        if selectedCategoryIndex == 0 {
            let searchCat = teamSearchCategoriesList[selectedTeamIndex]
            searchManager.conductTeamDatabaseSearch(searchCat: searchCat, searchQuery: searchFieldValue)
        } else {
            let searchCat = playerSearchCategoriesList[selectedPlayerIndex]
            searchManager.conductPlayerDatabaseSearch(searchCat: searchCat, searchQuery: searchFieldValue)
        }
    }
    
    var showPhotoSearchResults: some View {
        if searchManager.databasePlayerSearchResults.isEmpty {
            return AnyView(
                NotFound(message: "Database Search Produced No Results!\n\nThe database did not return any value for the given search query!")
            )
        }
        return AnyView(PlayerSearchResultsList(results: searchManager.databasePlayerSearchResults))
    }

    var showSearchResults: some View {
        if searchManager.databaseTeamSearchResults.isEmpty {
            return AnyView(
                NotFound(message: "Database Search Produced No Results!\n\nThe database did not return any value for the given search query!")
            )
        }
        return AnyView(TeamSearchResultsList(results: searchManager.databaseTeamSearchResults))
    }
    
    func inputDataValidated() -> Bool {
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if queryTrimmed.isEmpty {
            alertTitle = "Missing Input Data!"
            alertMessage = "Please enter a database search query!"
            return false
        }
        searchQuery = queryTrimmed
        return true
        
        
    }
    
    
}
#Preview {
    SearchDatabase()
}
