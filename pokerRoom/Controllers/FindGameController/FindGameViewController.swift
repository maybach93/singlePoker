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
    public var coordinator: GameCoordinator?
    
    //MARK - Lifecylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sPlayer = self.player {
            self.coordinator = isGameHost ? HostGameCoordinator(player: sPlayer, gameConfiguration: gameConfiguration) : PeripheralGameCoordinator(player: sPlayer)
            self.coordinator?.delegate = self
        }
    }
    
    
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameVC = segue.destination as? GameViewController {
            gameVC.coordinator = self.coordinator
        }
    }
}

extension FindGameViewController: GameCoordinatorDelegate {
    func newGameStarted() {
        self.performSegue(withIdentifier: Constants().gameControllerSegueIdentifier, sender: self)
        self.coordinator?.delegate = nil
    }
}
