//
//  TicTocCell.swift
//  TicTocToeGame
//
//  Created by Shilpa Bansal on 05/12/21.
//

import SwiftUI
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
