//
//  ContentView.swift
//  NoughtsAndCrosses
//
//  Created by  User on 11.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var currentPlayer: Player = .cross
    @State private var currentEnemy: Player = .nought
    @State private var board: [Player?] = Array(repeating: nil, count: 9)
    @State private var gameEnded: Bool = false
    @State private var isPlayingAsCross: Bool = true
    
    var body: some View {
        VStack {
            Text("Крестики-Нолики")
                .font(.title)
                .padding()

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(0..<9) { index in
                    Button(action: {
                        cellTapped(index)
                    }) {
                        Text(board[index]?.rawValue ?? "")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .background(Color.blue.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }

            Text(resultText)
                .font(.title)
                .padding()

            Toggle("Play as \(isPlayingAsCross ? "X" : "O")", isOn: $isPlayingAsCross)
                          .padding()
                          .onChange(of: isPlayingAsCross, perform: { _ in
                              restartGame()
                          })

            
            Button(action: {
                restartGame()
            }) {
                Text("Restart")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private func cellTapped(_ index: Int) {
        guard !gameEnded, board[index] == nil else {
            return
        }

        board[index] = currentPlayer
        checkGameEnd()
        
        lifecycleAiTurn()
    }
    
    private func checkGameEnd(){
        if checkForWinner() != nil {
            gameEnded = true
        } else if board.allSatisfy({ $0 != nil }) {
            gameEnded = true
        }
    }
    private func lifecycleAiTurn(){
        if !gameEnded
        {
            aiTurn()
        }
        checkGameEnd()
    }
    
    private func aiTurn() {
            var turn = Int.random(in: 0...8)

            while board[turn] != nil {
                turn = Int.random(in: 0...8)
            }
            board[turn] = currentEnemy
        }
    private func checkForWinner() -> Player? {
        let winningCombinations: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        for combination in winningCombinations {
            if let player = board[combination[0]], board[combination[1]] == player, board[combination[2]] == player {
                return player
            }
        }
        return nil
    }

    private func restartGame() {
        
        currentPlayer = isPlayingAsCross ? .cross : .nought
        currentEnemy = !isPlayingAsCross ? .cross : .nought
        
        board = Array(repeating: nil, count: 9)
        gameEnded = false
        
        if currentEnemy == .cross{
            lifecycleAiTurn()
        }
    }

    private var resultText: String {
        if gameEnded {
            if checkForWinner() != nil {
                return "\(checkForWinner()!) wins!"
            } else {
                return "Draw!"
            }
        } else {
            return ""
        }
    }
}
enum Player: String {
    case cross = "X"
    case nought = "O"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
