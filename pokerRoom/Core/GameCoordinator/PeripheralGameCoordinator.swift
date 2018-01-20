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
    
    //MARK: - Lifecycle
    
    override init(player: Player) {
        super.init(player: player)
        self.communicator = PeripheralCommunicator()
    }
    
    //MARK: - Override
    
    override func receiveMessage(message: Message) {
        switch message.type {
        case .gameConfiguration:
            if let gameConfigurationMessageData = message.data as? GameConfigurationMessageData {
                self.gameConfiguration = gameConfigurationMessageData.gameConfiguration
            }
            self.sendPeripheralInfo()
        default:
            break
        }
    }
    
    //MARK: - Private
    
    private func sendPeripheralInfo() {
        let playerInfoMessageData = PlayerInfo()
        playerInfoMessageData.isGameHost = player.isGameHost
        playerInfoMessageData.name = player.name
        let message = Message(type: MessageTypes.peripheralInfo, data: playerInfoMessageData)
        self.sendMessage(message: message)
    }
    
}

