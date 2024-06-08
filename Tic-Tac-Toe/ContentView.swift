//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by RPS on 08/06/24.
//

import SwiftUI

struct ContentView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible())]
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9){ i in
                        ZStack{
                            Circle()
                                .foregroundColor(.red).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15,
                                       height: geometry.size.width/3 - 15)
                            Text(moves[i]?.indicator ?? "").font(.system(size: 50)).foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquareOcupied(in: moves, forIndex: i) { return }
                            moves[i] = Move(player: .human, boardIndex: i)
                            
                            if checkWinCondition(for: .human, in: moves){
                                alertItem = AlertContext.humanWin
                                return
                            }
                            
                            if checkForDraw(in: moves){
                                alertItem = AlertContext.draw
                                return
                            }
                            isGameboardDisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determainComuterMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves){
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                
                                if checkForDraw(in: moves){
                                    alertItem = AlertContext.draw
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameboardDisabled)
            .padding()
            .alert(item: $alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.msg,
                      dismissButton: .default(alertItem.btnTitle, action: { restartGame() }))
            })
        }
    }
    func isSquareOcupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    func determainComuterMovePosition(in moves: [Move?]) -> Int {
        
        let winPattrens: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        //If AI can win, then win
        let computerMoves = moves.compactMap{ $0 }.filter{ $0.player == .computer }
        let computerPostion = Set(computerMoves.map{ $0.boardIndex })
        
        for pattren in winPattrens {
            let winPositions = pattren.subtracting(computerPostion)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOcupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first!}
            }
        }
        // If AI can't win, then block
        let humanMoves = moves.compactMap{ $0 }.filter{ $0.player == .human }
        let humanPositions = Set(humanMoves.map{ $0.boardIndex })
        
        for pattren in winPattrens {
            let winPosintions = pattren.subtracting(humanPositions)
            
            if winPosintions.count == 1 {
                let isAvailable = !isSquareOcupied(in: moves, forIndex: winPosintions.first!)
                if isAvailable { return winPosintions.first!}
            }
        }
        //if AI can't block, take middle square
        let center = 4
        if !isSquareOcupied(in: moves, forIndex: center){ return center}
        
        //if AI can't take middlle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOcupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    func restartGame(){
        moves = Array(repeating: nil, count: 9)
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "X" : "0"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
