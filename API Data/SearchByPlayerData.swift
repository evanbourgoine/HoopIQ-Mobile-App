//
//  SearchByPlayerData.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import Foundation

var foundPlayersList = [PlayerStruct]()

public func getFoundPlayersFromApi(query: String) {
    let apiUrlString = "https://api.sportsdata.io/v3/nba/scores/json/Players/\(query)?key=9880793d20dd4297af1278ac8f15ca6f"
    foundPlayersList = [PlayerStruct]()
    
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: nbaApiHeaders, apiUrl: apiUrlString, timeout: 10.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)

        
        if let jsonObject = jsonResponse as? NSArray {
            for player in jsonObject {
                if let temp = player as? NSDictionary {
                    var name = ""
                    if let tempName = temp["DraftKingsName"] as? String {
                        name = tempName
                    }
                    var team = ""
                    if let tempTeam = temp["Team"] as? String {
                        team = tempTeam
                    }
                    let fullTeamName = getTeamName(from: team)
                    var position = ""
                    if let tempPosition = temp["Position"] as? String {
                        position = tempPosition
                    }
                    let positionConverted = getPosition(from: position)
                    var photoID = ""
                    if let tempPhoto = temp["NbaDotComPlayerID"] as? Int {
                        photoID = String(tempPhoto)
                    }
                    var birthDate = ""
                    if let tempBirthDate = temp["BirthDate"] as? String {
                        birthDate = tempBirthDate
                    }
                    birthDate = String(birthDate.prefix(10))
                    var height = 0
                    if let tempHeight = temp["Height"] as? Int {
                        height = tempHeight
                    }
                    let heightInFeet = convertInchesToFeetAndInches(height)
                    var jerseyNum = 0
                    if let tempNumber = temp["Jersey"] as? Int {
                        jerseyNum = tempNumber
                    }
                    var country = ""
                    if let tempCountry = temp["BirthCountry"] as? String {
                        country = tempCountry
                    }
                    var college = ""
                    if let tempCollege = temp["College"] as? String {
                        college = tempCollege
                    }
                    
                    let foundPlayer = PlayerStruct(name: name, team: fullTeamName, photoFilename: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/\(photoID).png", position: positionConverted, birthDate: birthDate, height: heightInFeet, college: college, number: jerseyNum, nationality: country)
                    foundPlayersList.append(foundPlayer)
                    
                }
                
            }
        }
        
        
        
        
    } catch { return }
    
}
