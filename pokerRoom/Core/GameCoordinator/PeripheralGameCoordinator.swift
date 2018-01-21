//
//  PeripheralGameCoordinator.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

class PeripheralGameCoordinator: GameCoordinator {
    
    //MARK: - Variables
    
    var hostPlayer: Player?
    
    //MARK: - Lifecycle
    
    override init(player: Player) {
        super.init(player: player)
        self.communicator = PeripheralCommunicator()
        self.gameController = PeripheralGameController()
    }
    
    //MARK: - Override
    
    override func receiveMessage(message: Message) {
        switch message.type {
        case .gameConfiguration:
            if let gameConfigurationMessageData = message.data as? GameConfigurationMessageData {
                self.gameConfiguration = gameConfigurationMessageData.gameConfiguration
            }
            self.sendPeripheralInfo()
        case .startGameInfo:
            if let startGameInfoData = message.data as? StartGameInfoData {
                if let playersInfoData = startGameInfoData.playersInfoData {
                    gameController.players = playersInfoData.map { Player(playerInfoData: $0) }
                }
                if let buttonPosition = startGameInfoData.buttonPosition {
                    gameController.buttonPosition = buttonPosition
                }
            }
            self.delegate?.newGameStarted()
        default:
            break
        }
    }
    
    //MARK: - Private
    
    private func sendPeripheralInfo() {
        let message = Message(type: MessageTypes.peripheralInfo, data: PlayerInfoData(player: player))
        self.sendMessage(message: message)
    }
    
}

