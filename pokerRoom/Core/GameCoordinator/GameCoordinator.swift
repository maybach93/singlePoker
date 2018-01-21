//
//  GameCoordinator.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

protocol GameCoordinatorDelegate: class {
    func newGameStarted()
}

class GameCoordinator {
    
    //MARK: - Variables
    
    weak var delegate: GameCoordinatorDelegate?
    
    var gameConfiguration: GameConfiguration? {
        didSet {
            guard let sGameConfiguration = gameConfiguration else { return }
            self.gameController.bigBlind = sGameConfiguration.bigBlind
            self.gameController.blindsUpdateTime = sGameConfiguration.blindsUpdateTime
        }
    }
    
    var communicator: GeneralCommunicator? {
        didSet {
            if let sCommunicator = communicator {
                sCommunicator.delegate = self
            }
        }
    }
    var player: Player = Player()
    var gameController = GameController()

    weak var gameControllerDelegate: GameControllerDelegate?
    
    //MARK: - Lifecycle
    
    init(player: Player) {
        self.player = player
    }
    
    //MARK: - Messaging
    
    func sendMessage(message: Message) {
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(message) {
            communicator?.send(data: jsonData)
        }
    }
    
    func receiveMessage(message: Message) {
        
    }
}

extension GameCoordinator: CommunicatorDelegate {
    func didReceiveData(data: Data) {

        let jsonDecoder = JSONDecoder()
        let message = try? jsonDecoder.decode(Message.self, from: data)
        if let sMessage = message {
            receiveMessage(message: sMessage)
        }
    }
}

