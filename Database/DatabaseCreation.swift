//
//  DatabaseCreation.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

var listOfAllTeamsInDatabase = [Team]()
var teamsStructList = [TeamStruct]()

public func createDatabase() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage the Note, ToDoTask, and Contact objects
        modelContainer = try ModelContainer(for: Team.self, Player.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context where the Note, ToDoTask, and Contact objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    /*
     --------------------------------------------------------------------
     |   Check to see if the database has already been created or not   |
     --------------------------------------------------------------------
     */
    let teamFetchDescriptor = FetchDescriptor<Team>()
    var listOfAllTeamsInDatabase = [Team]()
    
    do {
        listOfAllTeamsInDatabase = try modelContext.fetch(teamFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Book objects from the database")
    }
    if !listOfAllTeamsInDatabase.isEmpty {
        print("Database has already been created!")
        return
    }
    
    print("Database will be created!")
    
    
    teamsStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DatabaseInitialContent.json", fileLocation: "Main Bundle")
    // For each book in the list we create a Book class containing the same data and add it to our database
    for aTeam in teamsStructList {
        
        let newTeam = Team(name: aTeam.name, city: aTeam.city, logoFilename: aTeam.logoFilename, conference: aTeam.conference, division: aTeam.division, websiteUrl: aTeam.websiteUrl, championships: aTeam.championships, homeArena: aTeam.homeArena, arenaImageUrl: aTeam.arenaImageUrl, teamColors: aTeam.teamColors, headCoach: aTeam.headCoach, instagramUrl: aTeam.instagramUrl, twitterUrl: aTeam.twitterUrl, latitude: aTeam.latitude, longitude: aTeam.longitude)
        
        modelContext.insert(newTeam)
    }
    
    var playersStructList = [PlayerStruct]()
    playersStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DatabasePlayerInitialContent.json", fileLocation: "Main Bundle")
    // Same thing for the photo
    // For each photo in the list we create a new Photo class containing the same data as the photo struct
    for aPlayer in playersStructList {
        let newPlayer = Player(name: aPlayer.name, team: aPlayer.team, photoFilename: aPlayer.photoFilename, position: aPlayer.position, birthDate: aPlayer.birthDate, height: aPlayer.height, college: aPlayer.college, number: aPlayer.number, nationality: aPlayer.nationality)
        
        modelContext.insert(newPlayer)
    }
    // Try to save the changes to the database
    do {
        try modelContext.save()
    } catch {
        fatalError("Unable to save database changes")
    }
    print("Database is successfully created!")
    
}
