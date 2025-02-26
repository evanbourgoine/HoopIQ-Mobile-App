//
//  HeightConverter.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//


public func convertInchesToFeetAndInches(_ totalInches: Int) -> String {
    let feet = totalInches / 12
    let inches = totalInches % 12
    return "\(feet)'\(inches)\""
}
