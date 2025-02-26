//
//  ContentView.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                Home()
            }
            Tab("Teams", systemImage: "basketball") {
                TeamsList()
            }
            Tab("Players", systemImage: "person.fill") {
                PlayersList()
            }
            Tab("Search DB", systemImage: "cylinder.split.1x2") {
                SearchDatabase()
            }
            Tab("Search API", systemImage: "magnifyingglass.circle.fill") {
                SearchApi()
            }
            Tab("View Teams On Map", systemImage: "mappin.and.ellipse") {
                TeamsOnMap()
            }
            Tab("Player Quiz", systemImage: "person.fill.questionmark") {
                QuizSelector()
            }
           Tab("Team Quiz", systemImage: "questionmark.text.page.fill") {
                TeamQuizSelector()
            }
            Tab("Team Logo Slider", systemImage: "photo.on.rectangle.angled") {
                LogoSlider()
             }
            Tab("Settings", systemImage: "gear") {
                Settings()
            }
        }   // End of TabView
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
