//
//  HoopIQApp.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct HoopIQApp: App {

    init() {
        // Create Teams and players Database upon App Launch IF the app is being launched for the first time.
        createDatabase()      // Given in DatabaseCreation.swift
    }
    
    @Environment(\.undoManager) var undoManager
    
    @AppStorage("darkMode") private var darkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(darkMode ? .dark : .light)
            
                /*
                 Inject the Model Container into the environment so that you can access its Model Context
                 in a SwiftUI file by using @Environment(\.modelContext) private var modelContext
                 */
                .modelContainer(for: [Team.self, Player.self], isUndoEnabled: true)
        }
    }
}
