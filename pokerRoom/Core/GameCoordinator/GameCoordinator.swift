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

extension GameCoordinator {
    func _playerDidBet(player: Player, bet: Float) {
        let playerActionMessageData = PlayerActionMessageData(amount: bet, player: player)
        let message = Message(type: .playerDidBet, data: playerActionMessageData)
        self.sendMessage(message: message)
        self.gameControllerDelegate?.playerDidBet(player: player, bet: bet)
    }
    func _playerDidRaise(player: Player, raise: Float) {
        let playerActionMessageData = PlayerActionMessageData(amount: raise, player: player)
        let message = Message(type: .playerDidRaise, data: playerActionMessageData)
        self.sendMessage(message: message)
        self.gameControllerDelegate?.playerDidRaise(player: player, raise: raise)
    }
    func _playerDidCall(player: Player, call: Float) {
        let playerActionMessageData = PlayerActionMessageData(amount: call, player: player)
        let message = Message(type: .playerDidCall, data: playerActionMessageData)
        self.sendMessage(message: message)
        self.gameControllerDelegate?.playerDidCall(player: player, call: call)
    }
    func _playerDidFold(player: Player) {
        let playerActionMessageData = PlayerActionMessageData(amount: 0, player: player)
        let message = Message(type: .playerDidFold, data: playerActionMessageData)
        self.sendMessage(message: message)
        self.gameControllerDelegate?.playerDidFold(player: player)
    }
    func _playerDidCheck(player: Player) {
        let playerActionMessageData = PlayerActionMessageData(amount: 0, player: player)
        let message = Message(type: .playerDidCheck, data: playerActionMessageData)
        self.sendMessage(message: message)
        self.gameControllerDelegate?.playerDidCheck(player: player)
    }
}

