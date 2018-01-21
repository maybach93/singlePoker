//
//  GameEndMessageData.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 21.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation


class GameEndMessageData: MessageData {
    
    //MARK: - Variables
    
    var winners: [PlayerInfoData]?
    var playersInfoData: [PlayerInfoData]?
    var amount: Float?
    
    //MARK: - Lifecycle
    
    override init() {
        super.init()
    }
    
    convenience init(amount: Float, playersInfoData: [PlayerInfoData], winners: [PlayerInfoData]) {
        self.init()
        self.amount = amount
        self.playersInfoData = playersInfoData
        self.winners = winners
    }
    
    //MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case amount
        case playersInfoData
        case winners
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(playersInfoData, forKey: .playersInfoData)
        try container.encode(winners, forKey: .winners)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try values.decode(Float.self, forKey: .amount)
        playersInfoData = try values.decode(Array<PlayerInfoData>.self, forKey: .playersInfoData)
        winners = try values.decode(Array<PlayerInfoData>.self, forKey: .winners)
    }
}
