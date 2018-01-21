//
//  GameStateMessageData.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 21.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

class GameStateMessageData: MessageData {
    var bankAmount: Float?
    var street: Int?
    var currentActivePlayerPosition: Int?
    var commonCards: [Int]?
    var bigBlind: Float?
    
    override init() {
        super.init()
    }
    
    //MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case bankAmount
        case street
        case currentActivePlayerPosition
        case commonCards
        case bigBlind
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bankAmount, forKey: .bankAmount)
        try container.encode(street, forKey: .street)
        try container.encode(currentActivePlayerPosition, forKey: .currentActivePlayerPosition)
        try container.encode(commonCards, forKey: .commonCards)
        try container.encode(bigBlind, forKey: .bigBlind)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        bankAmount = try values.decode(Float.self, forKey: .bankAmount)
        street = try values.decode(Int.self, forKey: .street)
        currentActivePlayerPosition = try values.decode(Int.self, forKey: .currentActivePlayerPosition)
        commonCards = try values.decode(Array<Int>.self, forKey: .commonCards)
        bigBlind = try values.decode(Float.self, forKey: .bigBlind)
    }
}
