//
//  GameViewController+Delegates.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 05.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import UIKit

extension GameViewController: GameControllerDelegate {
    func bankAmountChanged() {
        self.bankInfoLabel.text = "Банк: " + "\(self.gameController.currentBank)"
    }
    func newGameStarted() {
        self.addInfoLabel(text: "Приятной игры")
        self.updateUI()
        self.view.isUserInteractionEnabled = true
    }
    func commonCardsUpdated() {
        self.commonCardsLabel.text = Card.textRepresentation(cards: self.gameController.commonCards)
    }
    
    func streetChanged() {
        self.infoLabel.text = self.gameController.street.textRepresentation
    }
    
    func currentPlayerChanged() {
        self.updateUI()
    }

    func gameFinished(winner: Player, amount: Float, showOpponentCards: Bool) {
        if showOpponentCards {
            self.opponentCardsLabel.text = Card.textRepresentation(cards: self.currentOpponent().cards)
        }
        self.addInfoLabel(text: "Выиграл " + winner.name + " Выигрыш: " + "\(amount)")
        self.view.isUserInteractionEnabled = false
    }
    func gameEnded(winner: Player) {
        self.addInfoLabel(text: "Победитель: " + "\(winner.name)" + ", Поздравляем!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { 
            self.dismiss(animated: true, completion: nil)
        }
    }
    func blindsUpdated() {
        self.addInfoLabel(text: "Лимиты увеличены, блаинды: \(self.gameController.bigBlind)/\(self.gameController.bigBlind/2)")
    }
    
    func winnerHand(hand: Hand) {
        self.addInfoLabel(text: hand.valueHand().value.textRepresentation + " " + Number.textRepresentation(numbers: hand.valueHand().order))
    }
}
