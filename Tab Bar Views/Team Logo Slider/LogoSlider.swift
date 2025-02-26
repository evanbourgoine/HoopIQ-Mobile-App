//
//  LogoSlider.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

// Preserve selected background color between views
fileprivate var selectedColor = Color.gray.opacity(0.1)


struct LogoSlider: View {
    
    @Query(FetchDescriptor<Team>(sortBy: [SortDescriptor(\Team.name, order: .forward)])) private var listOfAllTeamsInDatabase: [Team]
    
    // Default selected background color
    @State private var selectedBgColor = Color.gray.opacity(0.1)
    
    var body: some View {
        NavigationStack {
            ZStack {            // Background
                // Color entire background with selected color
                selectedBgColor
                
                // Place color picker at upper right corner
                VStack {        // Foreground
                    HStack {
                        Spacer()
                        ColorPicker("", selection: $selectedBgColor)
                            .padding()
                    }
                    Spacer()
                    
                    TabView {
                        // Since Photo struct has the 'id' property, no need to specify 'id' in ForEach
                        ForEach(listOfAllTeamsInDatabase) { team in
                            VStack {
                                Link(destination: URL(string: team.websiteUrl)!) {
                                    Text(team.name)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }
                                Image(team.logoFilename)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }   // End of TabView
                    .tabViewStyle(PageTabViewStyle())
                    .onAppear() {
                        UIPageControl.appearance().currentPageIndicatorTintColor = .black
                        UIPageControl.appearance().pageIndicatorTintColor = .gray
                    }
                    
                }   // End of VStack
                .navigationTitle("Team Logos")
                .toolbarTitleDisplayMode(.inline)
                .onAppear() {
                    selectedBgColor = selectedColor
                }
                .onDisappear() {
                    selectedColor = selectedBgColor
                }
                
            }   // End of ZStack
        }   // End of NavigationStack
    }   // End of body var
}

#Preview {
    LogoSlider()
}
