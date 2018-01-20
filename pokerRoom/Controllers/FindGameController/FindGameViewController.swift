//
//  FindGameViewController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

class FindGameViewController: UIViewController {

    //MARK: - Constants
    
    struct Constants {
        let gameControllerSegueIdentifier = String(describing: GameViewController.self)
    }

    //MARK: - Variables
    
    public var isGameHost: Bool {
        get {
            return gameConfiguration != nil
        }
    }
    public var gameConfiguration: GameConfiguration?
    public var player: Player?
    public var communicator: GeneralCommunicator?
    
    //MARK - Lifecylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isGameHost {
            communicator = CentralCommunicator()
        } else {
            communicator = PeripheralCommunicator()
        }
    }
    
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? GameViewController {
//            let playerOne = Player()
//            playerOne.balance = Float(self.startStackLabel.text!)!
//            playerOne.name = self.playerOneNameLabel.text!
//            vc.gameController.players = [playerOne]
//            vc.gameController.bigBlind = Float(self.startBlindsLabel.text!)!
//            vc.gameController.blindsUpdateTime = TimeInterval(60 * Float(self.refreshBlindsLabel.text!)!)
//        }
//    }
}
