//
//  ContentView.swift
//  Scissors
//
//  Created by Daria on 25.05.2024.
//

import SwiftUI

struct ContentView: View {
    var moves = ["📄", "✂️", "🪨"]
    
    @State private var currentChoie = Int.random(in: 0..<3)
    @State private var shouldWin = Bool.random()
    
    @State private var countGame = 0
    @State private var scoreGame = 0
    
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            Color.brown
                .ignoresSafeArea()
            VStack(spacing: 15) {
                Text("Game: \(countGame) / 10")
                    .font(.largeTitle.bold())
                Text("Score: \(scoreGame)")
                    .font(.title)
                Text("\(moves[currentChoie])")
                    .font(.system(size: 50))
                Text("You have to \(shouldWin ? "win" : "lose")")
                    .font(.system(size: 30))
                    .font(.title2)
                    
                HStack(spacing: 20) {
                    ForEach(0..<moves.count) { move in
                        Button {
                            calculateGame(with: move)
                        } label: {
                            Text("\(moves[move])")
                                .font(.system(size: 70))
                        }
                        .frame(width: 100)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .shadow(radius: 7)
                        .disabled(countGame == 10)
                        
                        .alert("Final Score", isPresented: $showingAlert) {
                            Button("Restart", action: resetGame)
                        } message: {
                            Text("Your final score is \(scoreGame) out of 8")
                        }
                        
                    }
                }
            }
            .foregroundStyle(.black)
        }
    }
    func resetGame() {
        scoreGame = 0
        countGame = 0
        showingAlert = false
        currentChoie = Int.random(in: 0..<3)
        shouldWin = Bool.random()
    }
    
    func calculateGame(with move: Int) {
        if currentChoie == move {
            scoreGame += 1
        } else if shouldWin {
            switch currentChoie {
            case 0:
                if move == 1 {
                    scoreGame += 1
                } else if scoreGame > 0 {
                    scoreGame -= 1
                }
            case 1:
                if move == 2 {
                    scoreGame += 1
                } else if scoreGame > 0 {
                    scoreGame -= 1
                }
            case 2:
                if move == 0 {
                    scoreGame += 1
                } else if scoreGame > 0 {
                    scoreGame -= 1
                }
            default:
                break
            }
        } else {
            switch currentChoie {
            case 0:
                if move == 2 {
                    scoreGame += 1
                } else if scoreGame > 0 {
                    scoreGame -= 1
                }
            case 1:
                if move == 0 {
                    scoreGame += 1
                } else if scoreGame > 0 {
                    scoreGame -= 1
                }
            case 2:
                if move == 1 {
                    scoreGame += 1
                } else if scoreGame > 0 {
                    scoreGame -= 1
                }
            default:
                break
            }
        }
        
        countGame += 1
        
        if countGame == 10 {
            showingAlert = true
        } else {
            currentChoie = Int.random(in: 0..<3)
            shouldWin = Bool.random()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
