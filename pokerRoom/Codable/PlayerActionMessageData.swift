//
//  PlayerActionMessageData.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 21.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

class PlayerActionMessageData: MessageData {
    var amount: Float?
    var player: PlayerInfoData?
    
    override init() {
        super.init()
    }
    
    convenience init(amount: Float?, player: Player) {
        self.init()
        self.amount = amount
        self.player = PlayerInfoData(player: player)
    }
    
    //MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case amount
        case player
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(player, forKey: .player)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try values.decode(Float.self, forKey: .amount)
        player = try values.decode(PlayerInfoData.self, forKey: .player)
    }
}

