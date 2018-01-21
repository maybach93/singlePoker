//
//  GameController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

class PeripheralGameController {
    
    weak var delegate: GameControllerDelegate?
    
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
    
    var dealerIndex: Int = 0
    
    var currentPlayerIndex: Int = 0 
    var currentPlayer: Player {
        get {
            return self.players[self.currentPlayerIndex]
        }
    }
    
    var blindsUpdateTime: TimeInterval = 60
    var needsUpdateBigBlind: Bool = false {
        didSet {
            if !self.needsUpdateBigBlind {
                self.setNeedsUpdateBlindsAfterDelay()
            }
        }
    }
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
    
    let pokerMachine = RandomPokerMachine()
    func start() {
        self.setNeedsUpdateBlindsAfterDelay()
        self.prepareNewGame()
    }
    
    
    //MARK: - Private
    
    internal func prepareNewGame() {
        self.pokerMachine.reset()
        self.commonCards = []
        self.street = .none
        
        guard self.checkBankrotPlayers() else { return }
        self.updateBigBlindIfNeeded()
        self.moveDealer()
        self.resetPlayers()
        self.nextStreetIfPossible()
        self.placeBlinds()
        self.nextPlayerAction()
        self.delegate?.newGameStarted()
    }
    
    private func moveDealer() {
        self.dealerIndex = self.nextPlayer(from: self.dealerIndex)
    }
    
    private func resetPlayers() {
        for player in self.players {
            player.bet = 0
            player.cards = []
            player.isFold = false
            player.isPlayed = false
        }
    }
    
    internal func resetPlayersNextStreet() {
        for player in self.activePlayers {
            player.bet = 0
            player.isPlayed = false
        }
    }
    
    private func placeBlinds() {
        self.bet(size: self.bigBlind / 2, playerIndex: self.dealerIndex)
        let bigBlindIndex = self.nextPlayer(from: self.dealerIndex)
        self.bet(size: self.bigBlind, playerIndex: bigBlindIndex)
    }
    
    internal func nextPlayerAction() {
        guard !self.checkIfAllFold() else { return }
        let nextIndex = self.nextActivePlayer(from: self.currentPlayer)
        let nextPlayer = self.activePlayers[nextIndex]
        if self.checkIfPlayerShouldPlay(player: nextPlayer) {
            self.currentPlayerIndex = self.index(of: nextPlayer)
            self.delegate?.currentPlayerChanged()
        } else if self.nextStreetIfPossible() {
            self.delegate?.currentPlayerChanged()
        } else {
            self.finishWithShowdown()
        }
    }
    
    internal func bet(size: Float, playerIndex: Int) {
        let player = self.players[playerIndex]
        guard player.balance >= size else { return }
        player.balance -= size
        player.bet += size
        self.currentBank += size
    }
    
    //MARK : - check
    
    internal func checkIfAllFold() -> Bool {
        if self.activePlayers.count == 1 {
            self.finishWihoutShowdown(player: self.activePlayers.first!)
            return true
        }
        return false
    }
    
    internal func checkIfPlayerShouldPlay(player: Player) -> Bool {
        guard !player.isFold else { return false }
        if self.currentMaxBet == player.bet {
            return !player.isPlayed
        }
        return true
    }
    
    internal func checkBankrotPlayers() -> Bool {
        for player in self.players {
            if player.balance == 0 {
                let index = self.index(of: player)
                self.players.remove(at: index)
            }
        }
        
        if self.players.count == 1 {
            self.delegate?.gameEnded(winner: self.players.first!)
        }
        return self.players.count != 1
    }
    
    //MARK: - Indexes
    
    internal func nextPlayer(from index: Int) -> Int {
        if index <= 0 {
            return self.players.count - 1
        }
        return index - 1
    }
    
    internal func nextActivePlayer(from player: Player) -> Int {
        guard let index = self.activePlayers.index(where: { (cPlayer) -> Bool in
            return cPlayer.name == player.name
        }) else { return -1 }
        if index <= 0 {
            return self.activePlayers.count - 1
        }
        return index - 1
    }
    
    internal func index(of player: Player) -> Int {
        return self.players.index(where: { (cPlayer) -> Bool in
            return cPlayer.name == player.name
        })!
    }
}

