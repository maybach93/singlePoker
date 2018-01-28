//
//  GameController+CurrentPlayerActions.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

extension GameController {
    
    //max bet made for now
    var currentMaxBet: Float {
        get {
            return self.activePlayers.map { $0.bet }.max()!
        }
    }
    
    var currentCallSize: Float {
        get {
            return self.currentMaxBet - self.currentActivePlayer.bet
        }
    }
    
    var maxBetAvaliable: Float {
        get {
            
            let minOpponentBalance = self.activePlayers.map { $0.balance }.min()
            guard let sMinOpponentBalance = minOpponentBalance else { return 0 }
            return sMinOpponentBalance
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
            return self.currentCallSize == 0
        }
    }
    
    var isCallAvaliable: Bool {
        get {
            return self.currentCallSize > 0
        }
    }
    
    var isBetAvaliable: Bool {
        get {
            return self.currentMaxBet == 0
        }
    }
    
    var isRaiseAvaliable: Bool {
        get {
            return ((self.currentActivePlayer.balance + self.currentActivePlayer.bet) > self.currentMaxBet && self.currentActivePlayer.balance > 0 && !self.allOpponentsAllIn)
        }
    }
    
    var minimalBet: Float {
        get {
            return min(self.currentCallSize + self.bigBlind, self.currentActivePlayer.balance, self.currentCallSize + self.maxBetAvaliable)
        }
    }
    
    var maximumBet: Float {
        get {
            return self.currentCallSize + self.maxBetAvaliable
        }
    }
    
  
}
