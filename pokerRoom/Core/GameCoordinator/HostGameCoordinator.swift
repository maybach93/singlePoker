//
//  HostGameCoordinator.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

class HostGameCoordinator: GameCoordinator {
    
    //MARK: - Variables
    
    var centralCommunicator: CentralCommunicator {
        get {
            return self.communicator as! CentralCommunicator
        }
    }
    
    //MARK: - Lifecycle
    
    init(player: Player, gameConfiguration: GameConfiguration?) {
        super.init(player: player)
        self.player = player
        self.communicator = CentralCommunicator()
        self.centralCommunicator.centralDelegate = self
        self.gameConfiguration = gameConfiguration
    }
    
    //MARK: - Override
    
    override func receiveMessage(message: Message) {
        switch message.type {
        case .peripheralInfo:
            
        default:
            break
        }
    }
    
    //MARK: - Messaging
    
    //MARK: - Private
    
    
}

extension HostGameCoordinator: CentralCommunicatorDelegate {
    func didFoundPeripheral() {
        guard let sGameConfiguration = self.gameConfiguration else { return }
        let gameConfigurationMessageData = GameConfigurationMessageData(gameConfiguration: sGameConfiguration, hostPlayer: player)
        let message = Message(type: MessageTypes.gameConfiguration, data: gameConfigurationMessageData)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.sendMessage(message: message)
        }
    }
}
