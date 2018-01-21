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
    
    var maxBetAvaliable: Float {
        get {
            var maxOpponentBalance:Float = 0
            for player in self.activePlayers {
                if player.id != self.myPlayerId {
                    maxOpponentBalance = max(maxOpponentBalance, player.balance)
                }
            }
            return maxOpponentBalance
        }
    }
    
    var allOpponentsAllIn: Bool {
        get {
            let allActiveOpponents = self.activePlayers.filter { $0.id != self.myPlayerId }
            return allActiveOpponents.filter { $0.balance == 0 }.count == allActiveOpponents.count
        }
    }
    
    var isCheckAvaliable: Bool {
        get {
            return self.myPlayer.bet == self.currentMaxBet
        }
    }
    
    var isCallAvaliable: Bool {
        get {
            return self.myPlayer.bet < self.currentMaxBet
        }
    }
    
    var isBetAvaliable: Bool {
        get {
            return self.currentMaxBet == 0
        }
    }
    
    var isRaiseAvaliable: Bool {
        get {
            return (self.myPlayer.balance > self.currentMaxBet && self.myPlayer.balance > 0 && !self.allOpponentsAllIn)
        }
    }
    
    var minimalBet: Float {
        get {
            return min(self.currentMaxBet + self.bigBlind - self.myPlayer.bet, self.myPlayer.balance)
        }
    }
    
    var maximumBet: Float {
        get {
            return min(self.myPlayer.balance, self.maxBetAvaliable)
        }
    }
    
  
}
