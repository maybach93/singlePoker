
//
//  CreateGameViewController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController {

    //MARK: - Variables
    
    public var player: Player?
    
    //MARK: - Outlets
    
    @IBOutlet weak var playerOneNameLabel: UITextField!
    @IBOutlet weak var startStackLabel: UITextField!
    @IBOutlet weak var startBlindsLabel: UITextField!
    @IBOutlet weak var refreshBlindsLabel: UITextField!

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let bigBlind = Float(self.startBlindsLabel.text!), let startStack = Float(self.startStackLabel.text!) else { return }
        let gameConfiguration = GameConfiguration(bigBlind: bigBlind, blindsUpdateTime: TimeInterval(60 * (Float(self.refreshBlindsLabel.text!)!)), startStack: startStack)
        
        guard let destinationVC = segue.destination as? FindGameViewController else { return }
        
        destinationVC.gameConfiguration = gameConfiguration
        player?.isGameHost = true
        destinationVC.player = player
    }
}
