//
//  TeamQuiz.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct TeamQuiz: View {
    enum Difficulty {
        case easy, medium, hard
    }
    
    let difficulty: Difficulty
    
    @Query(FetchDescriptor<Team>(sortBy: [SortDescriptor(\Team.name)])) private var teams: [Team]
    
    @State private var currentTeam: Team?
    @State private var options: [String] = []
    @State private var questionText = ""
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var correctAnswer = ""
    
    @State private var currentQuestion = 1
    @State private var score = 0
    @State private var quizFinished = false
    @State private var hardQuestionType = 0
    
    var body: some View {
        NavigationStack {
            if quizFinished {
                VStack {
                    Text("Quiz Finished!")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Your Score: \(score) / 5")
                        .font(.title)
                        .padding()
                    
                    Button("Restart Quiz") {
                        resetQuiz()
                    }
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Question \(currentQuestion) of 5")
                            .font(.headline)
                        
                        if let team = currentTeam {
                            Text(questionText)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                            
                            if difficulty == .easy || difficulty == .medium {
                                Image(team.logoFilename)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    checkAnswer(option)
                                }) {
                                    Text(option)
                                        .font(.body)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        } else {
                            Text("Loading Quiz...")
                                .font(.title2)
                                .onAppear {
                                    generateQuestion()
                                }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Quiz: \(difficultyText)")
                .alert(isPresented: $showResult) {
                    Alert(
                        title: Text(isCorrect ? "Correct!" : "Wrong!"),
                        message: Text(isCorrect ? "Good job!" : "The correct answer was \(correctAnswer)."),
                        dismissButton: .default(Text(currentQuestion < 5 ? "Next Question" : "See Score")) {
                            nextQuestion()
                        }
                    )
                }
            }
        }
    }
    
    private func generateQuestion() {
        guard teams.count >= 4 else { return }
        
        currentTeam = teams.randomElement()
        
        switch difficulty {
        case .easy:
            questionText = "Which team is this?"
            correctAnswer = currentTeam?.name ?? ""
            options = generateOptions(correct: correctAnswer)
            
        case .medium:
            questionText = "What is the \(currentTeam?.name ?? "") arena name?"
            correctAnswer = currentTeam?.homeArena ?? ""
            options = generateOptions(correct: correctAnswer)
            
        case .hard:
            hardQuestionType = Int.random(in: 0...2)
            if hardQuestionType == 0 {
                questionText = "What is the \(currentTeam?.name ?? "") division?"
                correctAnswer = "\(currentTeam?.division ?? "")"
            } else if hardQuestionType == 1 {
                questionText = "How many championships do the \(currentTeam?.name ?? "") have?"
                correctAnswer = "\(currentTeam?.championships ?? 0)"
            } else {
                questionText = "Who is the \(currentTeam?.name ?? "") head coach?"
                correctAnswer = currentTeam?.headCoach ?? "Unknown"
            }
            options = generateOptions(correct: correctAnswer)
        }
    }
    
    private func generateOptions(correct: String) -> [String] {
        var allOptions = teams.map {
            switch difficulty {
            case .easy: return $0.name
            case .medium: return $0.homeArena
            case .hard:
                if hardQuestionType == 0 {
                    return $0.division
                } else if hardQuestionType == 1 {
                    return String($0.championships)
                } else {
                    return $0.headCoach
                }
            }
        }
        allOptions.removeAll { $0.isEmpty || $0 == correct }
        let uniqueOptions = Set(allOptions).prefix(3)
        var randomOptions = Array(uniqueOptions)
        randomOptions.append(correct)
        return randomOptions.shuffled()
    }
    
    private func checkAnswer(_ selected: String) {
        isCorrect = selected == correctAnswer
        if isCorrect { score += 1 }
        showResult = true
    }
    
    private func nextQuestion() {
        if currentQuestion < 5 {
            currentQuestion += 1
            generateQuestion()
        } else {
            quizFinished = true
        }
    }
    
    private func resetQuiz() {
        currentQuestion = 1
        score = 0
        quizFinished = false
        generateQuestion()
    }
    
    private var difficultyText: String {
        switch difficulty {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
}
