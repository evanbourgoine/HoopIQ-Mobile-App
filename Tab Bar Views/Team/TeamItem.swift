//
//  TeamItem.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct TeamItem: View {
    
    // Input Parameter
    let team: Team
    
    var body: some View {
        HStack {
            Image(team.logoFilename)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading) {
                Text(team.name)
                HStack {
                    Image(systemName: "mappin.circle")
                        .foregroundColor(.black) //person icon is black
                    Text(team.city)
                        .font(.system(size: 14))
                } //end HStack for publisher
                HStack {
                    Image(systemName: "trophy")
                        .foregroundColor(.black) //calendar icon is black
                    Text("Championships Won: \(team.championships)")
                        .font(.system(size: 14))
                } //end HStack for creation date
            }
            .font(.system(size: 14))
        }
    }
}
