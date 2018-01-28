//
//  GameController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

class HostGameController: GameController {

    var needsUpdateBigBlind: Bool = false {
        didSet {
            if !self.needsUpdateBigBlind {
                self.setNeedsUpdateBlindsAfterDelay()
            }
        }
    }
    
    let pokerMachine = RandomPokerMachine()
    func start() {
        self.setNeedsUpdateBlindsAfterDelay()
        self.prepareNewGame()
    }
    
    //MARK: - Private
    
    override func prepareNewGame() {
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
        self.buttonPosition = self.nextPlayer(from: self.buttonPosition)
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
        let maxBetAvaliable = self.maxBetAvaliable;
        self.bet(size: min(maxBetAvaliable, self.bigBlind / 2), playerPosition: self.buttonPosition)
        let bigBlindIndex = self.nextPlayer(from: self.buttonPosition)
        self.bet(size: min(maxBetAvaliable, self.bigBlind), playerPosition: bigBlindIndex)
    }
    
    internal func nextPlayerAction() {
        guard !self.checkIfAllFold() else { return }
        let nextIndex = self.nextActivePlayer(from: self.currentActivePlayer)
        let nextPlayer = self.activePlayers[nextIndex]
        if self.checkIfPlayerShouldPlay(player: nextPlayer) {
            self.currentActivePlayerPosition = self.index(of: nextPlayer)
            self.delegate?.currentPlayerChanged()
        } else if self.nextStreetIfPossible() {
            self.delegate?.currentPlayerChanged()
        } else {
            self.finishWithShowdown()
        }
    }
    
    
    //Bet any player
    internal func bet(size: Float, playerPosition: Int) {
        guard let player = self.player(with: playerPosition) else { return }
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
    
    //MARK: - actions
    
    override func check() {
        super.check()
        self.check(player: self.myPlayer)
    }
    
    override func fold() {
        super.fold()
        self.fold(player: self.myPlayer)
    }
    
    override func call() {
        super.call()
        self.call(player: self.myPlayer)
    }
    
    //Bet or raise
    override func bet(size: Float) {
        super.bet(size: size)
        self.bet(player: self.myPlayer, size: size)
    }
    
    func check(player: Player) {
        guard self.isCheckAvaliable else { return }
        self.currentActivePlayer.isPlayed = true
        self.nextPlayerAction()
    }
    
    func fold(player: Player) {
        self.currentActivePlayer.isPlayed = true
        self.currentActivePlayer.isFold = true
        self.nextPlayerAction()
    }

    func call(player: Player) {
        self.currentActivePlayer.isPlayed = true
        let currentBet = self.currentActivePlayer.bet
        let callSize = self.currentMaxBet - currentBet
        self.bet(size: callSize, playerPosition: self.currentActivePlayer.position)
        self.nextPlayerAction()
    }
    
    func bet(player: Player, size: Float) {
        guard self.currentActivePlayer.balance >= size else { return }
        self.currentActivePlayer.isPlayed = true
        self.bet(size: size, playerPosition: self.currentActivePlayer.position)
        self.nextPlayerAction()
    }
    
    //MARK: - Indexes
    
    internal func nextPlayer(from position: Int) -> Int {
        if position <= 0 {
            return self.players.count - 1
        }
        return position - 1
    }
    
    internal func player(with id: String) -> Player? {
        return self.players.filter { $0.id == id }.first
    }
    internal func player(with position: Int) -> Player? {
        return self.players.filter { $0.position == position }.first
    }
    
    internal func nextActivePlayer(from player: Player) -> Int {
        guard let index = self.activePlayers.index(where: { (cPlayer) -> Bool in
            return cPlayer.id == player.id
        }) else { return -1 }
        if index <= 0 {
            return self.activePlayers.count - 1
        }
        return index - 1
    }
    
    
}

