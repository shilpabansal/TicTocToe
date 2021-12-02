//
//  TicTocBoard.swift
//  TicTocToeGame
//
//  Created by Shilpa Bansal on 02/12/21.
//

import Foundation
import Combine

enum Player: String {
    case player1 = "0"
    case player2 = "X"
    case notFilled = ""
}

enum GameStatus {
    case notStarted
    case playing
    case allCellsFilled
    case winner(Player)
    case error
}

class Board: ObservableObject {
    let GameIndex = 3
    var gameStatus: GameStatus = .notStarted
    @Published var game: [[Player]]
    @Published var matrixIndex: MatrixIndex
    var currentTurn: Player = .player1
    
    private var cancellables: [AnyCancellable] = []
    
    deinit {
        self.cancellables.removeAll()
    }
    
    init() {
        game = [[Player]](repeating: [.notFilled, .notFilled, .notFilled], count: GameIndex)
        self.matrixIndex = MatrixIndex(row: -1, column: -1)
        
        self.$matrixIndex.sink { value in
            guard (value.row != -1) && (value.column != -1) else {
                return
            }
        }
        .store(in: &self.cancellables)
    }
    
    func isValidMove(row: Int, column: Int) -> Bool {
        return game[row][column] == .notFilled
    }
    
    var isAllCellFilled: Bool {
        let isFilled = game.allSatisfy { rows in
            rows.allSatisfy { column in
                return column != .notFilled
            }
        }
        if isFilled {
            updateGameStatus(.allCellsFilled)
        }
        
        return isFilled
    }
    
    @discardableResult
    func isGameCompleted() -> Bool {
        if case .allCellsFilled = gameStatus {
            return true
        }
        if case let .winner(player) =  gameStatus, player != .notFilled {
            return true
        }
        return false
    }
    
    func didWinGame(row: Int, column: Int) -> Bool {
        var areAllRowsSame = true
        for rowIndex in 0..<3 {
            if game[rowIndex][column] != currentTurn {
                areAllRowsSame = false
                break
            }
        }
        
        var areAllColumnsSame = true
        for colIndex in 0..<3 {
            if game[row][colIndex] != currentTurn {
                areAllColumnsSame = false
                break
            }
        }
        
        var areDiagonalElementsSame = true
        for rowIndex in 0..<3 {
            for colIndex in 0..<3 {
                if game[rowIndex][colIndex] != currentTurn && rowIndex == colIndex {
                    areDiagonalElementsSame = false
                    break
                }
            }
        }
        
        return areAllRowsSame || areAllColumnsSame || areDiagonalElementsSame
    }
    
    func updateGameStatus(_ status: GameStatus) {
        gameStatus = status
    }
    
    func playGame(row: Int, column: Int) {
        if isGameCompleted() {
            return
        }
        
        if isValidMove(row: row, column: column) {
            game[row][column] = currentTurn
            updateGameStatus(.playing)
        }
        else {
            updateGameStatus(.error)
            return
        }
        
        if didWinGame(row: row, column: column) {
            updateGameStatus(.winner(currentTurn))
        }
        
        if isAllCellFilled {
            updateGameStatus(.allCellsFilled)
        }
        currentTurn = currentTurn == .player1 ? .player2 : .player1
    }
    
    func restartGame() {
        game = [[Player]](repeating: [.notFilled, .notFilled, .notFilled], count: GameIndex)
        updateGameStatus(.notStarted)
    }
}
