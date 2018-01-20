//
//  MessageData.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

class MessageData: Codable {
    
}

class GameConfigurationMessageData: MessageData {
    var bigBlind: Float?
    var blindsUpdateTime: TimeInterval?
    var startStack: Float?
    var hostPlayer: PlayerInfo?
}


