//
//  Player.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

class PlayerInfo: MessageData {
    var isGameHost: Bool?
    var name: String?
    
    //MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case isGameHost
        case name
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isGameHost, forKey: .isGameHost)
        try container.encode(name, forKey: .name)
    }
}
