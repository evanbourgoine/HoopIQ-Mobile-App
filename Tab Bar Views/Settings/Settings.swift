//
//  Settings.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct Settings: View {
    
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dark Mode Setting")) {
                    Toggle("Dark Mode", isOn: $darkMode)
                }
                Section(header: Text("View Official NBA Website"), footer: Text("Website can be viewed from the app!").italic()) {
                    NavigationLink(destination: NBAHomepage()) {
                        HStack {
                            Image(systemName: "globe")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Official NBA Website")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    Settings()
}
