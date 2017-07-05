//
//  GameController+CurrentPlayerActions.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

extension GameController {
    
    var currentMaxBet: Float {
        get {
            var maxBet: Float = 0
            for player in self.players {
                if player.bet >= maxBet {
                    maxBet = player.bet
                }
            }
            return maxBet
        }
    }
    
    var isCheckAvaliable: Bool {
        get {
            for player in self.players {
                if player.bet != 0 {
                    return false
                }
            }
            return true
        }
    }
    
    var isCallAvaliable: Bool {
        get {
            return self.currentPlayer.bet < self.currentMaxBet
        }
    }
    
    var isBetAvaliable: Bool {
        get {
            return self.currentMaxBet == 0
        }
    }
    
    var minimalBet: Float {
        get {
            return self.currentMaxBet + self.bigBlind
        }
    }
    
    var maximumBet: Float {
        get {
            return self.currentPlayer.balance
        }
    }
    
    //MARK: - actions
    
    func check() {
        guard self.isCheckAvaliable else { return }
        self.currentPlayer.isPlayed = true
        self.nextPlayerAction()
    }
    
    func fold() {
        self.currentPlayer.isPlayed = true
        self.currentPlayer.isFold = true
        self.nextPlayerAction()
    }
    
    func bet(size: Float) {
        guard size >= self.minimalBet && size <= self.maximumBet else { return }
        self.currentPlayer.isPlayed = true
        let currentBet = self.currentPlayer.bet
        self.bet(size: size - currentBet, playerIndex: self.currentPlayerIndex)
        self.nextPlayerAction()
    }
    
    func call() {
        self.currentPlayer.isPlayed = true
        let currentBet = self.currentPlayer.bet
        self.bet(size: self.currentMaxBet - currentBet, playerIndex: self.currentPlayerIndex)
        self.nextPlayerAction()
    }
}
