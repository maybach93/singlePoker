//
//  Message.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

enum MessageTypes: String {
    case gameConfiguration //Отправляется от хоста оппоненту, в ответ на это сообщение он возвращает свой ник
    case peripheralInfo //Отправляется оппонентом хосту (содержит имя), после этого хост запускает игру
    case startGameInfo //Отправляется перед началом партии хостом, информация о позиции и стеке игроков
    
    //HOST:
    case bankAmountChanged
    case streetChanged
    case currentPlayerChanged
    case commonCardsUpdated
    case blindsUpdated
    
    case gameEnded
    case gameFinished
    case gameFinishedSplit
    //case winnerHand Потом
    
    //BOTH
    case playerDidBet
    case playerDidRaise
    case playerDidCall
    case playerDidFold
    case playerDidCheck
    
    case unknown
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
        case .peripheralInfo:
            data = try values.decode(PlayerInfoData.self, forKey: .data)
        case .startGameInfo:
            data = try values.decode(StartGameInfoData.self, forKey: .data)
        case .bankAmountChanged, .streetChanged, .currentPlayerChanged, .commonCardsUpdated, .blindsUpdated:
            data = try values.decode(GameStateMessageData.self, forKey: .data)
        case .gameEnded, .gameFinished, .gameFinishedSplit:
            data = try values.decode(GameEndMessageData.self, forKey: .data)
        case .playerDidBet, .playerDidRaise, .playerDidCall, .playerDidFold, .playerDidCheck:
            data = try values.decode(PlayerActionMessageData.self, forKey: .data)
        default:
            data = MessageData()
            break
        }
    }
}
