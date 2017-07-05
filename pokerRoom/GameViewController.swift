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
    
    //MARK: - Actions
    
    @IBAction func readyButtonPressed(_ sender: Any) {
    }
    @IBAction func checkFoldButtonPressed(_ sender: Any) {
    }
    @IBAction func callButtonPressed(_ sender: Any) {
    }
    @IBAction func betRaiseButtonPressed(_ sender: Any) {
    }
    @IBAction func betSliderValueChanged(_ sender: Any) {
    }
}
