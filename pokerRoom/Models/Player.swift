
//
//  Player.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

class Player {
    var balance: Float = 0
    var name: String = ""
    var cards: [PokerCard] = []
    
    var bet: Float = 0
    var isFold: Bool = false
    var isPlayed: Bool = false
}
