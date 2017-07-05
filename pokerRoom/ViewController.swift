//
//  ViewController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playerOneNameLabel: UITextField!
    @IBOutlet weak var playerTwoNameLabel: UITextField!
    @IBOutlet weak var startStackLabel: UITextField!
    @IBOutlet weak var startBlindsLabel: UITextField!
    @IBOutlet weak var refreshBlindsLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameViewController {
            let playerOne = Player()
            playerOne.balance = Float(self.startStackLabel.text!)!
            playerOne.name = self.playerOneNameLabel.text!
            let playerTwo = Player()
            playerTwo.balance = Float(self.startStackLabel.text!)!
            playerTwo.name = self.playerTwoNameLabel.text!
            vc.gameController.players = [playerOne, playerTwo]
            vc.gameController.bigBlind = Float(self.startBlindsLabel.text!)!
            vc.gameController.blindsUpdateTime = TimeInterval(60 * Float(self.refreshBlindsLabel.text!)!)
        }
    }
}

