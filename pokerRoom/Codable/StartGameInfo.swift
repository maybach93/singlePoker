//
//  StartGameInfo.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 21.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation


class StartGameInfoData: MessageData {
    
    //MARK: - Variables
    
    var buttonPosition: Int?
    var playersInfoData: [PlayerInfoData]?
    
    //MARK: - Lifecycle
    
    override init() {
        super.init()
    }
    
    convenience init(buttonPosition: Int, playersInfoData: [PlayerInfoData]) {
        self.init()
        self.buttonPosition = buttonPosition
        self.playersInfoData = playersInfoData

    }
    
    //MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case buttonPosition
        case playersInfoData
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(buttonPosition, forKey: .buttonPosition)
        try container.encode(playersInfoData, forKey: .playersInfoData)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        buttonPosition = try values.decode(Int.self, forKey: .buttonPosition)
        playersInfoData = try values.decode(Array<PlayerInfoData>.self, forKey: .playersInfoData)
    }
}
