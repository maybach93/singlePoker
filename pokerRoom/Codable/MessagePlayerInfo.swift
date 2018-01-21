//
//  Player.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation


class PlayerInfoData: MessageData {
    
    //MARK: - Variables
    
    var isGameHost: Bool?
    var name: String?
    var id: String?
    var position: Int?
    var cards: [Int]?
    
    var player: Player? {
        get {
            return Player(playerInfoData: self)
        }
    }
    
    //MARK: - Lifecycle
    
    override init() {
        super.init()
    }
    
    convenience init(player: Player) {
        self.init()
        self.isGameHost = player.isGameHost
        self.name = player.name
        self.id = player.id
        self.position = player.position
    }
    
    //MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case isGameHost
        case name
        case id
        case position
        case cards
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isGameHost, forKey: .isGameHost)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(position, forKey: .position)
        try container.encode(cards, forKey: .cards)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        //isGameHost = try values.decode(Bool.self, forKey: .isGameHost)
        name = try values.decode(String.self, forKey: .name)
        //id = try values.decode(String.self, forKey: .id)
        //position = try values.decode(Int.self, forKey: .position)
        //cards = try values.decode(Array<Int>.self, forKey: .cards)
    }
}
