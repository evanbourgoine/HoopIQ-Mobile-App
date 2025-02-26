//
//  TeamStruct.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//s

import SwiftUI

struct TeamStruct: Decodable {
    var name: String
    var city: String
    var logoFilename: String
    var conference: String
    var division: String
    var websiteUrl: String
    var championships: Int
    var homeArena: String
    var arenaImageUrl: String
    var teamColors: String
    var headCoach: String
    var instagramUrl: String
    var twitterUrl: String
    var latitude: Double
    var longitude: Double
    
}

//EXAMPLE TEAM JSON DESCRIPTION
//----------------------------------------
//"name": "Celtics",
//"city": "Boston",
//"logoFilename": "Celtics",
//"conference": "Eastern",
//"division": "Atlantic"
//"websiteUrl": "https://www.nba.com/celtics/",
//"championships": "18",
//"homeArena": "TD Garden",
//"arenaImageUrl": "https://blog.ticketmaster.com/wp-content/uploads/TD-Garden-e1568316426445.jpg",
//"teamColors": "Green, White, Gold",
//"headCoach": "Joe Mazzulla",
//"instagramUrl": "https://www.instagram.com/celtics/",
//"twitterUrl": "https://x.com/celtics",
//"latitude": 42.3663,
//"longitude": -71.0622
