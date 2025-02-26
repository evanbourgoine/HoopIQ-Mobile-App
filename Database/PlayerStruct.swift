//
//  PlayerStruct.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct PlayerStruct: Decodable, Hashable {
    let name: String
    let team: String
    let photoFilename: String
    let position: String
    let birthDate: String
    let height: String
    let college: String
    let number: Int
    let nationality: String
}

//"name": "LeBron James",
//"team": "Los Angeles Lakers",
//"photoFilename": "lebronjames",
//"position": "Forward",
//"age": 39,
//"height": "6'9\"",
//"college": "None",
//"number": 6,
//"nationality": "USA"
