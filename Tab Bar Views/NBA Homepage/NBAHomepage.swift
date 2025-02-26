//
//  NBAHomepage.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//


import SwiftUI
import WebKit
 
struct NBAHomepage: View {
    
    //setup NCAAHomepage tab with Webview and given website url
    var body: some View {
        VStack {
            WebView(url: "https://nba.com")
        }
    }
}

#Preview {
    NBAHomepage()
}
