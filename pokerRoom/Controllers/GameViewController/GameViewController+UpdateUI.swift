//
//  GameViewController+UpdateUI.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 05.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import UIKit

extension GameViewController {
    
    func updateUI() {
        self.updatePlayer(player: self.gameController.myPlayer)
        self.updateOpponent(player: self.opponent())
    }
    
    func updateOpponent(player: Player) {
        self.opponentNameLabel.text = player.name
        self.opponentBalanceLabel.text = "Баланс: " + "\(player.balance)"
        self.opponentCardsLabel.text = "🎴🎴"
        self.opponentBetLabel.text = "Текущая ставка: " + "\(player.bet)"
    }
    
    func updatePlayer(player: Player) {
        self.balanceLabel.text = "Ваш баланс: " + "\(player.balance)"
        self.nameLabel.text = player.name
        self.betLabel.text = "Ваша ставка: " + "\(player.bet)"
        self.showCurrentCards()
        self.betSizeLabel.isHidden = (!self.gameController.isRaiseAvaliable || !self.gameController.isMeActivePlayer)
        self.betSlider.isHidden = (!self.gameController.isRaiseAvaliable || !self.gameController.isMeActivePlayer)
        self.betRaiseButton.isHidden = (!self.gameController.isRaiseAvaliable || !self.gameController.isMeActivePlayer)
        self.callButton.isHidden = (!self.gameController.isCallAvaliable || !self.gameController.isMeActivePlayer)
        self.betSizeLabel.text = "\(self.gameController.minimalBet)"
        self.betSlider.minimumValue = self.gameController.minimalBet
        self.betSlider.maximumValue = self.gameController.maximumBet
        self.betSlider.value = self.gameController.minimalBet
        self.checkFoldButton.setTitle(self.gameController.isCheckAvaliable ? "Чек" : "Фолд", for: .normal)
        self.betRaiseButton.setTitle(self.gameController.isBetAvaliable ? "Бэт" : "Рэйз", for: .normal)
        
        self.betRaiseButton.alpha = self.gameController.isMeActivePlayer ? 1 : 0
        self.checkFoldButton.alpha = self.gameController.isMeActivePlayer ? 1 : 0 //TO DO LAYOUT

    }
    
    func set(view: UIView, visible: Bool) {
        view.alpha = visible ? 1 : 0
    }
    func updateBetsValue() {
        self.betSizeLabel.text = "\(self.betSlider.value)"
    }
    
    func showCurrentCards() {
        self.cardsLabel.text = Card.textRepresentation(cards: self.gameController.myPlayer.cards)
    }
}
