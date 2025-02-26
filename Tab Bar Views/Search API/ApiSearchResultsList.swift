//
//  ApiSearchResultsList.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct ApiSearchResultsList: View {
    var body: some View {
        List {
            ForEach(foundPlayersList, id:\.name) { aPlayer in
                NavigationLink(destination: SearchApiDetails(player: aPlayer)) {
                    SearchApiItem(player: aPlayer)
                }
            }
        }
        .font(.system(size: 14))
        .navigationTitle("API Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}
