//
//  GameController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

enum Streets: Int {
    case none = -1
    case preflop = 0
    case flop = 1
    case turn = 2
    case river = 3
}
class GameController {
    
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
    
    var currentPlayerIndex: Int = 0 {
        didSet {
            //notificate new active player
        }
    }
    var currentPlayer: Player {
        get {
            return self.players[self.currentPlayerIndex]
        }
    }
    
    var bigBlind: Float = 20
    
    var currentBank: Float = 0
    var commonCards: [PokerCard] = []
    var street: Streets = .none
    
    let pokerMachine = RandomPokerMachine()
    func start() {
        self.prepareNewGame()
    }
    
    
    //MARK: - Private
    
    private func prepareNewGame() {
        self.pokerMachine.reset()
        self.commonCards = []
        self.currentBank = 0
        self.moveDealer()
        self.resetPlayers()
        self.placeBlinds()
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
    
    private func placeBlinds() {
        let smallBlindIndex = self.nextPlayer(from: self.dealerIndex)
        self.bet(size: self.bigBlind / 2, playerIndex: smallBlindIndex)
        let bigBlindIndex = self.nextPlayer(from: smallBlindIndex)
        self.bet(size: self.bigBlind, playerIndex: bigBlindIndex)
    }
    
    internal func nextPlayerAction() {
        guard !self.checkIfAllFold() else { return }
        let nextIndex = self.nextActivePlayer(from: self.currentPlayer)
        let nextPlayer = self.activePlayers[nextIndex]
        if self.checkIfPlayerShouldPlay(player: nextPlayer) {
            self.currentPlayerIndex = self.index(of: nextPlayer)
        } else if !self.nextStreetIfPossible() {
            self.finishWithShowdown()
        }
    }
    
    internal func bet(size: Float, playerIndex: Int) {
        let player = self.players[playerIndex]
        guard player.balance >= size else { return }
        player.balance -= size
        player.bet = size
        self.currentBank += size
    }
    
    //MARK : - check
    
    func checkIfAllFold() -> Bool {
        if self.activePlayers.count == 1 {
            self.finishWihoutShowdown(player: self.activePlayers.first!)
            return true
        }
        return false
    }
    
    func checkIfPlayerShouldPlay(player: Player) -> Bool {
        guard !player.isFold else { return false }
        if self.currentMaxBet == player.bet {
            return !player.isPlayed
        }
        return true
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

protocol GameControllerDelegate: class {
    
}
