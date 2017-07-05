//
//  GameController+Stages.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 04.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

extension GameController {
    
    //MARK: - Stage
    
    func nextStreetIfPossible() -> Bool {
        guard self.street != .river else { return false }
        let nextStreet = self.street.rawValue + 1
        self.run(street: Streets(rawValue: nextStreet)!)
        return true
    }
    
    func run(street: Streets) {
        self.street = street
        switch self.street {
        case .preflop:
            self.giveGards()
            break
        case .flop:
            self.commonCards.append(contentsOf: self.pokerMachine.getCards(count: 3))
        case .turn:
            self.commonCards.append(contentsOf: self.pokerMachine.getCards(count: 1))
        case .river:
            self.commonCards.append(contentsOf: self.pokerMachine.getCards(count: 1))
        default:
            break
        }
        self.resetPlayersNextStreet()
        self.setFirstActivePlayer()
    }
    func finishWihoutShowdown(player: Player) {
        //уведомить о победителе
        player.balance += self.currentBank
        
        self.delegate?.gameFinished(winner: player, amount: self.currentBank, showOpponentCards: false)
        self.startNewGameAfterDelay()
    }
    
    func finishWithShowdown() {
        
        let t = Table(cards: self.commonCards)
        let firstPlayer = self.activePlayers[0]
        let secondPlayer = self.activePlayers[1]
        let b1 = t.bestHandWithCards(cards: firstPlayer.cards)!
        let b2 = t.bestHandWithCards(cards: secondPlayer.cards)!
        
        if let bestHand = bestHand(hand1: b1, b2) {
            if bestHand == b1 {
                //first won
                firstPlayer.balance += self.currentBank
                self.delegate?.gameFinished(winner: firstPlayer, amount: self.currentBank, showOpponentCards: true)
            } else {
                //second won
                secondPlayer.balance += self.currentBank
                self.delegate?.gameFinished(winner: secondPlayer, amount: self.currentBank, showOpponentCards: true)
            }
        } else {
            firstPlayer.balance += self.currentBank / 2
            secondPlayer.balance += self.currentBank / 2
            //tie
        }
        self.startNewGameAfterDelay()
    }
    
    //MARK: - Work
    
    func setNeedsUpdateBlindsAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + self.blindsUpdateTime, execute: {
            self.needsUpdateBigBlind = true
        })
    }
    
    func updateBigBlindIfNeeded() {
        if self.needsUpdateBigBlind {
            self.needsUpdateBigBlind = false
            self.bigBlind *= 2
        }
    }
    
    func startNewGameAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            self.prepareNewGame()
        }
    }
    
    func giveGards() {
        for player in self.players {
            player.cards = self.pokerMachine.getCards(count: 2)
        }
    }
    
    func setFirstActivePlayer() {
        let dealer = self.players[self.dealerIndex]
        self.currentPlayerIndex = self.nextActivePlayer(from: dealer)
    }
}
