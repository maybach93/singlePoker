//
//  GameViewController+Delegates.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 05.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import UIKit

extension GameViewController: GameControllerDelegate {
    
    func playerDidCheck(player: Player) {
        self.addInfoLabel(text: player.name + " сделал чек")
    }
    
    func gameFinished(split: [Player], amount: Float) {
        self.opponentCardsLabel.text = Card.textRepresentation(cards: self.opponent().cards)
        self.showCurrentCards()
        
        self.addInfoLabel(text: "Ничья, банк разделен между " + split[0].name + " и " + split[1].name + " Выигрыш: " + "\(amount)")
        self.view.isUserInteractionEnabled = false
    }
    
    func playerDidBet(player: Player, bet: Float) {
        self.addInfoLabel(text: player.name + " сделал бэт: " + "\(bet)")
    }
    func playerDidRaise(player: Player, raise: Float) {
        self.addInfoLabel(text: player.name + " сделал рэйз: " + "\(raise)")
    }
    func playerDidCall(player: Player, call: Float) {
        self.addInfoLabel(text: player.name + " сделал колл: " + "\(call)")
    }
    func playerDidFold(player: Player) {
        self.addInfoLabel(text: player.name + " сделал фолд")
    }
    func bankAmountChanged() {
        self.bankInfoLabel.text = "Банк: " + "\(self.gameController.currentBank)"
    }
    func newGameStarted() {
        self.addInfoLabel(text: "Приятной игры")
        self.updateUI()
        self.view.isUserInteractionEnabled = true
    }
    func commonCardsUpdated() {
        let cards = Card.textRepresentation(cards: self.gameController.commonCards)
        self.commonCardsLabel.text = cards
        self.addInfoLabel(text: "Доска: " + cards)
    }
    
    func streetChanged() {
        self.taskQueue.flushQueue()
        self.addInfoLabel(text: self.gameController.street.textRepresentation)
    }
    
    func currentPlayerChanged() {
        self.updateUI()
        self.view.isUserInteractionEnabled = false

        self.addInfoLabel(text: self.gameController.currentActivePlayer.name + ", ваш ход!")
    }

    func gameFinished(winner: Player, amount: Float, showOpponentCards: Bool) {
        self.addInfoLabel(text: "Выиграл " + winner.name + " Выигрыш: " + "\(amount)")
        if showOpponentCards {
            self.opponentCardsLabel.text = Card.textRepresentation(cards: self.opponent().cards)
            self.showCurrentCards()
            self.addInfoLabel(text: "Карты победителя: " + Card.textRepresentation(cards: winner.cards))
        }
        self.view.isUserInteractionEnabled = false
    }
    func gameEnded(winner: Player) {
        self.addInfoLabel(text: "Победитель: " + "\(winner.name)" + ", Поздравляем!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    func blindsUpdated() {
        self.addInfoLabel(text: "Лимиты увеличены, блаинды: \(self.gameController.bigBlind)/\(self.gameController.bigBlind/2)")
    }
    
    func winnerHand(hand: Hand) {
        self.addInfoLabel(text: hand.valueHand().value.textRepresentation + " " + Number.textRepresentation(numbers: hand.valueHand().order))
    }
}
