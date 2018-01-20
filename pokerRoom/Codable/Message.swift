//
//  Message.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

enum MessageTypes: String {
    case playerUpdate = "playerUpdate"
    case gameConfiguration = "gameConfiguration"
    case unknown = "unknown"
}

struct Message: Codable {
    let rawType: String
    
    var type: MessageTypes {
        get {
            if let messageType =  MessageTypes(rawValue: rawType) {
                return messageType
            }
            return .unknown
        }
    }
    
    let data: MessageData
}

