//
//  GameViewController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: - Top
    
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var opponentBalanceLabel: UILabel!
    @IBOutlet weak var opponentCardsLabel: UILabel!
    @IBOutlet weak var opponentBetLabel: UILabel!
    
    //MARK: - Middle
    
    @IBOutlet weak var logsTextView: UITextView!
    @IBOutlet weak var bankInfoLabel: UILabel!
    @IBOutlet weak var commonCardsLabel: UILabel!
    
    //MARK: - Bottom
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var cardsLabel: UILabel!
    
    @IBOutlet weak var betSizeLabel: UILabel!
    @IBOutlet weak var betSlider: UISlider!
    @IBOutlet weak var checkFoldButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var betRaiseButton: UIButton!
    
    //MARK: - Variables
    
    let gameController = GameController()
    let taskQueue = SerialTaskQueue.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskQueue.start()
        
        self.gameController.delegate = self
        self.gameController.start()
    }
    
    //MARK: - Actions
    
    @IBAction func showButtonPressed(_ sender: Any) {
        self.hideCurrentCards()
    }
    @IBAction func showButtonTouchDown(_ sender: Any) {
        self.showCurrentCards()
        self.markShownCards()
    }
    @IBAction func checkFoldButtonPressed(_ sender: Any) {
        if self.gameController.isCheckAvaliable {
            self.gameController.check()
        } else {
            self.gameController.fold()
        }
    }
    @IBAction func callButtonPressed(_ sender: Any) {
        self.gameController.call()
    }
    @IBAction func betRaiseButtonPressed(_ sender: Any) {
        self.gameController.bet(size: self.betSlider.value)
    }
    @IBAction func betSliderValueChanged(_ sender: Any) {
        let roundAmount = self.gameController.bigBlind / 2
        self.betSlider.value = roundAmount * round(self.betSlider.value / Float(roundAmount))
        self.updateBetsValue()
    }
    
    //MARK: - Internal
    
    func currentOpponent() -> Player {
        return self.gameController.players[self.gameController.currentPlayerIndex == 0 ? 1 : 0]
    }
    
    func addInfoLabel(text: String) {
        self.logsTextView.text.append("\n")
        self.logsTextView.text.append(text)
        let bottom = NSMakeRange(self.logsTextView.text.characters.count, 0)
        self.logsTextView.scrollRangeToVisible(bottom)
    }
}
