//
//  TeamQuizSelector.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct TeamQuizSelector: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Choose Quiz Difficulty")
                    .font(.title)
                
                NavigationLink(destination: TeamQuiz(difficulty: .easy)) {
                    Text("Easy")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: TeamQuiz(difficulty: .medium)) {
                    Text("Medium")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: TeamQuiz(difficulty: .hard)) {
                    Text("Hard")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Favorite Team Quiz")
        }
    }
}
