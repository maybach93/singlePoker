
//
//  Player.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

class Player {
    var isGameHost: Bool = false
    var id: String = ""
    var balance: Float = 0
    var position: Int = 0
    var name: String = ""
    var cards: [Card] = []
    
    var bet: Float = 0
    var isFold: Bool = false
    var isPlayed: Bool = false
    
    init() {
    }
    
    init(playerInfoData: PlayerInfoData) {
        self.isGameHost = playerInfoData.isGameHost ?? false
        self.name = playerInfoData.name ?? ""
        self.id = playerInfoData.id ?? ""
        self.balance = playerInfoData.balance ?? 0
        self.bet = playerInfoData.bet ?? 0
        self.isFold = playerInfoData.isFold ?? false
        self.isPlayed = playerInfoData.isPlayed ?? false
    }
}
