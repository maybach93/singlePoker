//
//  Message.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

enum MessageTypes: String {
    case gameConfiguration = "gameConfiguration" //Отправляется от хоста оппоненту, в ответ на это сообщение он возвращает свой ник
    case peripheralInfo = "peripheralInfo" //Отправляется оппонентом хосту (содержит имя), после этого хост запускает игру
    case unknown = "unknown"
}

struct Message: Codable {
    let type: MessageTypes
    let data: MessageData
    
    enum CodingKeys: String, CodingKey {
        case type
        case data
    }
}


extension Message {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(data, forKey: .data)
    }
}

extension Message {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawType = try values.decode(String.self, forKey: .type)
        
        if let type = MessageTypes(rawValue: rawType) {
            self.type = type
        } else {
            self.type = .unknown
        }
       
        switch type {
        case .gameConfiguration:
            data = try values.decode(GameConfigurationMessageData.self, forKey: .data)
        
            //data = try values.decode(PlayerInfo.self, forKey: .data)
        default:
            data = MessageData()
            break
        }
    }
}

