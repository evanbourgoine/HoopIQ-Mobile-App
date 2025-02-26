//
//  SearchApi.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct SearchApi: View {
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    @State private var selectedIndex = 0
    let nbaTeams = [
        "ATL", "BOS", "BKN", "CHA", "CHI", "CLE", "DAL", "DEN", "DET",
        "GSW", "HOU", "IND", "LAC", "LAL", "MEM", "MIA", "MIL", "MIN",
        "NOP", "NYK", "OKC", "ORL", "PHI", "PHX", "POR", "SAC", "SAS",
        "TOR", "UTA", "WAS"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("SearchAPI")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                Section(header: Text("Select Team")) {
                    Picker("Selected Team:", selection: $selectedIndex) {
                        ForEach(0 ..< nbaTeams.count, id: \.self) {
                            Text(nbaTeams[$0])
                        }
                    }
                }
                Section(header: Text("Search Database")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchApi()
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
                        NavigationLink(destination: showSearchResults) {
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
                                selectedIndex = 0
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
            } // End of Form
        } // End of NavigationStack
        .navigationTitle("Search Players API")
        .toolbarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {}
        }, message: {
            Text(alertMessage)
        })
        
    } // End of body var
    func searchApi() {
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        searchFieldValue = nbaTeams[selectedIndex]
        let queryCleaned = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // This public function is given in SearchApiData.swift
        getFoundPlayersFromApi(query: queryCleaned)
    }
    
    var showSearchResults: some View {
        /*
         Search results are obtained in SearchApiData.swift and
         stored in the global var foundPlayersList = [PlayerStruct]()
         */
        if foundPlayersList.isEmpty {
            return AnyView(
                NotFound(message: "No Player Found!\n\nThe entered query \(nbaTeams[selectedIndex]) did not return any Players from the API! Please enter another search query.")
            )
        }
        return AnyView(ApiSearchResultsList())
    }
    
    func inputDataValidated() -> Bool {
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        searchFieldValue = nbaTeams[selectedIndex]
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed.isEmpty {
            return false
        }
        return true
    }
}
