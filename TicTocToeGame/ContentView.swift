//
//  ContentView.swift
//  TicTocToeGame
//
//  Created by Shilpa Bansal on 27/11/21.
//

import SwiftUI
import Combine

struct TicTocView: View {
    @ObservedObject var board = Board()
    var gameStatusColor: Color {
        var gameColor = Color.blue
        switch board.gameStatus {
        case .allCellsFilled:
            gameColor = Color.yellow
        case .error:
            gameColor = Color.red
        case .winner(_):
            gameColor = Color.green
        default:
            gameColor = Color.clear
        }
        return gameColor
    }
    
    var gameStatusTextColor: Color {
        var gameColor = Color.blue
        switch board.gameStatus {
        case .allCellsFilled:
            gameColor = Color.yellow
        case .error:
            gameColor = Color.red
        case .winner(_):
            gameColor = Color.green
        default:
            gameColor = Color.blue
        }
        return gameColor
    }
    
    var gameStatus: String {
        var statusString = ""
        switch board.gameStatus {
        case .allCellsFilled:
            statusString = "Game finished, please start a new game to continue"
        case .error:
            statusString = "The filled cell can't be updated"
        case .winner(let player):
            statusString = "Game winner is: \(player)"
        case .playing:
            statusString = "Next turn is of: \(board.currentTurn)"
           
        default:
            break
        }
        return statusString
    }
    
    @State private var opacity:Double = 1.0
    
    var body: some View {
        VStack(alignment: .center) {
            Text(gameStatus)
                .foregroundColor(gameStatusTextColor)
                .opacity(opacity)
                .onAppear() {
                   let baseAnimation = Animation.linear(duration: 1)
                   withAnimation ( baseAnimation.repeatForever(autoreverses: true))
                    {
                        self.opacity = 0.5
                    }
                }

            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 200, height: 200, alignment: .top)
                    .border(gameStatusColor, width: 5)
                    .opacity(opacity)
                    .onAppear() {
                       let baseAnimation = Animation.linear(duration: 1)
                       withAnimation ( baseAnimation.repeatForever(autoreverses: true))
                        {
                            self.opacity = 0.5
                        }
                    }
                
                VStack(alignment: .center) {
                    
                    ForEach(0 ..< 3) { i in
                        HStack {
                            ForEach(0 ..< 3) { j in
                                TicTocCell(board: board,
                                           metrixIndex: MatrixIndex(row: i, column: j))
                            }
                        }
                    }
                }
            }
            Button("Restart") {
                board.restartGame()
            }
            .frame(width: 200, height: 35, alignment: .center)
            .background(Color.green, alignment: .center)
            .foregroundColor(Color.white)
            .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct TicTocCell: View {
    let matrixIndex: MatrixIndex
    @ObservedObject var board: Board
    
    init(board: Board,
         metrixIndex: MatrixIndex) {
        self.board = board
        self.matrixIndex = metrixIndex
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 50, height: 50, alignment: .top)
                .border(Color.gray, width: 5)
                .onTapGesture {
                    board.matrixIndex = matrixIndex
                    
                    board.playGame(row: matrixIndex.row, column: matrixIndex.column)
                }
            Text("\(board.game[matrixIndex.row][matrixIndex.column].rawValue)")
                .foregroundColor(.blue)
        }
    }
}

struct MatrixIndex {
    var row: Int
    var column: Int
}
