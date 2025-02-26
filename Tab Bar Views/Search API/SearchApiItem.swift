//
//  SearchApiItem.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct SearchApiItem: View {
    let player: PlayerStruct
    
    var body: some View {
        HStack {
            getImageFromUrl(url: player.photoFilename, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading) {
                Text(player.name)
                HStack {
                    Text("Team: \(player.team)")
                        .font(.system(size: 14))
                } //end HStack 
                HStack {
                    Image(systemName: "map")
                        .foregroundColor(.black) //map icon is black
                    Text(player.nationality)
                        .font(.system(size: 14))
                } //end HStack
            }
            .font(.system(size: 14))
        }
    }
    
    
}
