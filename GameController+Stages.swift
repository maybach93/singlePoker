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
        self.setFirstActivePlayer()
    }
    func finishWihoutShowdown(player: Player) {
        //уведомить о победителе
        player.balance += self.currentBank
        
        //после задержки новая игра
    }
    
    func finishWithShowdown() {
        
    }
    
    //MARK: - Work
    
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
