//
//  GameConfigurationMessageData.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 21.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

class GameConfigurationMessageData: MessageData {
    var bigBlind: Float?
    var blindsUpdateTime: TimeInterval?
    var startStack: Float?
    var hostPlayer: PlayerInfo?

    var gameConfiguration: GameConfiguration? {
        get {
            guard let bigBlind = bigBlind, let blindsUpdateTime = blindsUpdateTime, let startStack = startStack else { return nil }
            return GameConfiguration(bigBlind: bigBlind, blindsUpdateTime: blindsUpdateTime, startStack: startStack)
        }
    }
    
    override init() {
        super.init()
    }
    
    convenience init(gameConfiguration: GameConfiguration, hostPlayer: Player) {
        self.init()
        self.bigBlind = gameConfiguration.bigBlind
        self.blindsUpdateTime = gameConfiguration.blindsUpdateTime
        self.startStack = gameConfiguration.startStack

        let playerInfo = PlayerInfo()
        playerInfo.isGameHost = hostPlayer.isGameHost
        playerInfo.name = hostPlayer.name
        self.hostPlayer = playerInfo
    }
    
    //MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case bigBlind
        case blindsUpdateTime
        case startStack
        case hostPlayer
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bigBlind, forKey: .bigBlind)
        try container.encode(blindsUpdateTime, forKey: .blindsUpdateTime)
        try container.encode(startStack, forKey: .startStack)
        try container.encode(hostPlayer, forKey: .hostPlayer)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        bigBlind = try values.decode(Float.self, forKey: .bigBlind)
        blindsUpdateTime = try values.decode(TimeInterval.self, forKey: .blindsUpdateTime)
        startStack = try values.decode(Float.self, forKey: .startStack)
        hostPlayer = try values.decode(PlayerInfo.self, forKey: .hostPlayer)
    }
}
