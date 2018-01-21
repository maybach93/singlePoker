//
//  GameConstants.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 21.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

protocol TextRepresentable {
    var textRepresentation: String { get }
}

enum Streets: Int, TextRepresentable {
    internal var textRepresentation: String {
        get {
            switch self {
            case .preflop:
                return "Префлоп"
            case .flop:
                return "Флоп"
            case .turn:
                return "Терн"
            case .river:
                return "Ривер"
            default:
                return ""
            }
        }
    }
    
    case none = -1
    case preflop = 0
    case flop = 1
    case turn = 2
    case river = 3
}

