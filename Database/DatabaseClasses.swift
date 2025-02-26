//
//  DatabaseClasses.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

@Model
final class Team {
    
    //attributes
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
    
    init(name: String, city: String, logoFilename: String, conference: String, division: String, websiteUrl: String, championships: Int, homeArena: String, arenaImageUrl: String, teamColors: String, headCoach: String, instagramUrl: String, twitterUrl: String, latitude: Double, longitude: Double) {
        self.name = name
        self.city = city
        self.logoFilename = logoFilename
        self.conference = conference
        self.division = division
        self.websiteUrl = websiteUrl
        self.championships = championships
        self.homeArena = homeArena
        self.arenaImageUrl = arenaImageUrl
        self.teamColors = teamColors
        self.headCoach = headCoach
        self.instagramUrl = instagramUrl
        self.twitterUrl = twitterUrl
        self.latitude = latitude
        self.longitude = longitude
    }
}


@Model
final class Player {
    var name: String
    var team: String
    var photoFilename: String
    var position: String
    var birthDate: String
    var height: String
    var college: String
    var number: Int
    var nationality: String
    init(name: String, team: String, photoFilename: String, position: String, birthDate: String, height: String, college: String, number: Int, nationality: String) {
        self.name = name
        self.team = team
        self.photoFilename = photoFilename
        self.position = position
        self.birthDate = birthDate
        self.height = height
        self.college = college
        self.number = number
        self.nationality = nationality
    }
}
