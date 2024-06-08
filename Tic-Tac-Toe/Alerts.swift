//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by RPS on 08/06/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var msg: Text
    var btnTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                             msg: Text("You're Good"),
                             btnTitle: Text("Try again"))
    static let computerWin = AlertItem(title: Text("You Lost!"),
                                msg: Text("Your AI Beats you."),
                                btnTitle: Text("Try again"))
    static let draw = AlertItem(title: Text("Draw"), msg: Text("Draw match"), btnTitle: Text("Try again"))
    
}
