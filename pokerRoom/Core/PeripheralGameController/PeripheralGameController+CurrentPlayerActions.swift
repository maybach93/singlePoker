//
//  GameController+CurrentPlayerActions.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

extension PeripheralGameController {
//    
//    var currentMaxBet: Float {
//        get {
//            var maxBet: Float = 0
//            for player in self.players {
//                if player.bet >= maxBet {
//                    maxBet = player.bet
//                }
//            }
//            return maxBet
//        }
//    }
//    
//    var maxBetAvaliable: Float {
//        get {
//            var maxOpponentBalance:Float = 0
//            for player in self.activePlayers {
//                if player.name != self.currentActivePlayer.name {
//                    maxOpponentBalance = max(maxOpponentBalance, player.balance)
//                }
//            }
//            return maxOpponentBalance
//        }
//    }
//    
//    var allOpponentsAllIn: Bool {
//        get {
//            return self.activePlayers[self.nextActivePlayer(from: self.currentActivePlayer)].balance == 0
//        }
//    }
//    
//    var isCheckAvaliable: Bool {
//        get {
//            return self.currentActivePlayer.bet == self.currentMaxBet
//        }
//    }
//    
//    var isCallAvaliable: Bool {
//        get {
//            return self.currentActivePlayer.bet < self.currentMaxBet
//        }
//    }
//    
//    var isBetAvaliable: Bool {
//        get {
//            return self.currentMaxBet == 0
//        }
//    }
//    
//    var isRaiseAvaliable: Bool {
//        get {
//            return (self.currentActivePlayer.balance > self.currentMaxBet && self.currentActivePlayer.balance > 0 && !self.allOpponentsAllIn)
//        }
//    }
//    
//    var minimalBet: Float {
//        get {
//            return min(self.currentMaxBet + self.bigBlind - self.currentActivePlayer.bet, self.currentActivePlayer.balance)
//        }
//    }
//    
//    var maximumBet: Float {
//        get {
//            return min(self.currentActivePlayer.balance, self.maxBetAvaliable)
//        }
//    }
//    
//    //MARK: - actions
//    
//    func check() {
//        guard self.isCheckAvaliable else { return }
//        self.currentActivePlayer.isPlayed = true
//        self.delegate?.playerDidCheck(player: self.currentActivePlayer)
//        self.nextPlayerAction()
//    }
//    
//    func fold() {
//        self.currentActivePlayer.isPlayed = true
//        self.currentActivePlayer.isFold = true
//        self.delegate?.playerDidFold(player: self.currentActivePlayer)
//        self.nextPlayerAction()
//    }
//    
//    //func
//    
//    func bet(size: Float) {
//        guard size >= self.minimalBet && size <= self.maximumBet else { return }
//        if self.isBetAvaliable {
//            self.delegate?.playerDidBet(player: self.currentActivePlayer, bet: size)
//        } else {
//            self.delegate?.playerDidRaise(player: self.currentActivePlayer, raise: size)
//        }
//        self.currentActivePlayer.isPlayed = true
//        let currentBet = self.currentActivePlayer.bet
//        self.bet(size: size, playerIndex: self.currentPlayerIndex)
//        self.nextPlayerAction()
//    }
//    
//    func call() {
//        self.currentActivePlayer.isPlayed = true
//        let currentBet = self.currentActivePlayer.bet
//        let callSize = self.currentMaxBet - currentBet
//        self.delegate?.playerDidCall(player: self.currentActivePlayer, call: callSize)
//        self.bet(size: self.currentMaxBet - currentBet, playerIndex: self.currentPlayerIndex)
//        self.nextPlayerAction()
//    }
}
