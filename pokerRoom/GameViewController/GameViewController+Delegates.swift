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
        self.infoLabel.text = "Приятной игры"
        self.updateUI()
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
        self.infoLabel.text = "Выиграл " + winner.name + " Выигрыш: " + "\(amount)"
    }
}
