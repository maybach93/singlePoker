//
//  GameController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

class GameController {
    
    weak var delegate: GameControllerDelegate?
    
    internal var myPlayerId: String = ""
    
    var myPlayer: Player {
        get {
            return self.players.filter { $0.id == self.myPlayerId }.first!
        }
    }
    
    var players: [Player] = []
    var activePlayers: [Player] {
        get {
            var activePlayers:[Player] = []
            for player in self.players {
                if !player.isFold {
                    activePlayers.append(player)
                }
            }
            return activePlayers
        }
    }
    
    var buttonPosition: Int = 0
    
    var currentActivePlayerIndex: Int = 0 
    var currentActivePlayer: Player {
        get {
            return self.players[self.currentActivePlayerIndex]
        }
    }
    
    var blindsUpdateTime: TimeInterval = 60
  
    var bigBlind: Float = 20 {
        didSet {
            self.delegate?.blindsUpdated()
        }
    }
    
    var currentBank: Float = 0 {
        didSet {
            self.delegate?.bankAmountChanged()
        }
    }
    
    var commonCards: [Card] = [] {
        didSet {
            self.delegate?.commonCardsUpdated()
        }
    }
    var street: Streets = .none {
        didSet {
            self.delegate?.streetChanged()
        }
    }
    
    //MARK: - Private
    
    internal func prepareNewGame() {
        self.commonCards = []
        self.street = .none

        self.delegate?.newGameStarted()
    }

    internal func bet(size: Float) {
        guard size >= self.minimalBet && size <= self.maximumBet else { return }
        guard self.myPlayer.balance >= size else { return }
        self.myPlayer.balance -= size
        self.myPlayer.bet += size
        self.myPlayer.isPlayed = true
        self.currentBank += size
        if self.isBetAvaliable {
            self.delegate?.playerDidBet(player: self.myPlayer, bet: size)
        } else {
            self.delegate?.playerDidRaise(player: self.myPlayer, raise: size)
        }
    }
    
    //MARK : - check
    
    //MARK: - Indexes
    
    internal func index(of player: Player) -> Int {
        return self.players.index(where: { (cPlayer) -> Bool in
            return cPlayer.name == player.name
        })!
    }
    
    
    //MARK: - actions
    
    func check() {
        guard self.isCheckAvaliable else { return }
        self.myPlayer.isPlayed = true
        self.delegate?.playerDidCheck(player: self.currentActivePlayer)
    }
    
    func fold() {
        self.myPlayer.isPlayed = true
        self.myPlayer.isFold = true
        self.delegate?.playerDidFold(player: self.currentActivePlayer)
    }
    
    //func
    
    func call() {
        self.currentActivePlayer.isPlayed = true
        let currentBet = self.currentActivePlayer.bet
        let callSize = self.currentMaxBet - currentBet
        self.delegate?.playerDidCall(player: self.currentActivePlayer, call: callSize)
        self.bet(size: self.currentMaxBet - currentBet)
    }
}

protocol GameControllerDelegate: class {
    func bankAmountChanged()
    func newGameStarted()
    func streetChanged()
    func currentPlayerChanged()
    func commonCardsUpdated()
    func gameEnded(winner: Player)
    func blindsUpdated()
    func gameFinished(winner: Player, amount: Float, showOpponentCards: Bool)
    func gameFinished(split: [Player], amount: Float)
    func winnerHand(hand: Hand)
    func playerDidBet(player: Player, bet: Float)
    func playerDidRaise(player: Player, raise: Float)
    func playerDidCall(player: Player, call: Float)
    func playerDidFold(player: Player)
    func playerDidCheck(player: Player)
}
