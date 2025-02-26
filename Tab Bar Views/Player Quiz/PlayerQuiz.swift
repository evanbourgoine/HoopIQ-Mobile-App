//
//  PlayerQuiz.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//


import SwiftUI
import SwiftData

struct PlayerQuiz: View {
    enum Difficulty {
        case easy, medium, hard
    }
    
    let difficulty: Difficulty
    
    @Query(FetchDescriptor<Player>(sortBy: [SortDescriptor(\Player.name)])) private var players: [Player]
    
    @State private var currentPlayer: Player?
    @State private var options: [String] = []
    @State private var questionText = ""
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var correctAnswer = ""
    
    @State private var currentQuestion = 1
    @State private var score = 0
    @State private var quizFinished = false
    
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
                        
                        if let player = currentPlayer {
                            Text(questionText)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                            
                            if difficulty == .easy || difficulty == .medium {
                                Image(player.photoFilename)
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
        guard players.count >= 4 else { return }
        
        // Select the current player randomly
        currentPlayer = players.randomElement()
        
        switch difficulty {
        case .easy:
            questionText = "Which player is this?"
            correctAnswer = currentPlayer?.name ?? ""
            options = generateOptions(correct: correctAnswer)
            
        case .medium:
            questionText = "Which team does this\n player belong to?"
            correctAnswer = currentPlayer?.team ?? ""
            options = generateOptions(correct: correctAnswer)
            
        case .hard:
            let hardQuestionType = Int.random(in: 0...2)
            if hardQuestionType == 0 {
                questionText = "What is \(currentPlayer?.name ?? "") birth date?"
                correctAnswer = "\(currentPlayer?.birthDate ?? "")"
            } else if hardQuestionType == 1 {
                questionText = "Which college did \(currentPlayer?.name ?? "") attend?"
                correctAnswer = currentPlayer?.college ?? "Unknown"
            } else {
                questionText = "What is \(currentPlayer?.name ?? "'s'") height?"
                correctAnswer = currentPlayer?.height ?? "Unknown"
            }
            options = generateOptions(correct: correctAnswer)
        }
    }
    
    private func generateOptions(correct: String) -> [String] {
        var allOptions = players.map {
            switch difficulty {
            case .easy: return $0.name
            case .medium: return $0.team
            case .hard:
                return [$0.birthDate, $0.college, $0.height].randomElement() ?? ""
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
