//
//  Home.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//


import SwiftUI
import SwiftData

struct Home: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Team>(sortBy: [SortDescriptor(\Team.name, order: .forward)])) private var listOfAllTeamsInDatabase: [Team]
    
    @State private var index = 0
    /*
     Create a timer publisher that fires 'every' 3 seconds and updates the view.
     It runs 'on' the '.main' runloop so that it can update the view.
     It runs 'in' the '.common' mode so that it can run alongside other
     common events such as when the ScrollView is being scrolled.
     */
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Image("Welcome")
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("Welcome to HoopIQ!")
                        .font(.largeTitle) // Makes it stand out as a header
                        .fontWeight(.bold)
                        .padding(.bottom, 5) // Adjust padding as needed
                    
                    Text("An educational app to learn about basketball teams, players, and more!")
                        .font(.subheadline) // A smaller font for the description
                        .foregroundColor(.gray) // Optional: Use gray for a subtitle-like effect
                        .multilineTextAlignment(.center) // Aligns text in the center if it spans multiple lines
                }
                .padding()
                
                /*
                 -------------------------------------------------------------------------
                 Show an image slider of the photos of all of the teams in the database.
                 -------------------------------------------------------------------------
                 */
                
                // NBA Team photo obtained from its URL
                Image(listOfAllTeamsInDatabase[index].logoFilename)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipped()
                    .padding(10)
                
                    // Subscribe to the timer publisher
                    .onReceive(timer) { _ in
                        index += 1
                        if index > listOfAllTeamsInDatabase.count - 1 {
                            index = 0
                        }
                    }
                
                // NBA Team photo caption
                Text(listOfAllTeamsInDatabase[index].name)
                    .font(.headline)
                    // Allow lines to wrap around
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Powered By")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .italic()
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                // Show NBA API provider's website in default web browser
                Link(destination: URL(string: "https://sportsdata.io/developers/api-documentation/nba")!) {
                    Text("NBA API | SportsdataIO")
                }
                
                
            }   // End of VStack
            .padding(.bottom, 20)
        }   // End of ScrollView
        .onAppear() {
            startTimer()
        }
        .onDisappear() {
            stopTimer()
        }

        }   // End of ZStack
    }   // End of var
    
    func startTimer() {
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
}


#Preview {
    Home()
}

