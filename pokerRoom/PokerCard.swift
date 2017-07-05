//
//  PokerCard.swift
//  videopoker
//
//  Created by Vitalii Poponov on 02.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

class PokerCard {
    
    let value: UInt
    
//    var suit: Suit {
//        get {
//            if stride(from: Suit.heart.rawValue, to: 51, by: 4).contains(self.value) {
//                return .heart
//            }
//            else if stride(from: Suit.diamond.rawValue, to: 51, by: 4).contains(self.value) {
//                return .diamond
//            }
//            else if stride(from: Suit.club.rawValue, to: 51, by: 4).contains(self.value) {
//                return .club
//            }
//            else {
//                return .spade
//            }
//        }
//    }
//    
//    var textRepresentation: String {
//        get {
//            var suit = ""
//            var name = ""
//            switch self.suit {
//            case .heart:
//                suit = "♥"
//            case .diamond:
//                suit = "♦"
//            case .club:
//                suit = "♣"
//            case .spade:
//                suit = "♠"
//            }
//            switch self.name.rawValue {
//            case 0...8:
//                name = "\(self.name.rawValue + 2)"
//            case 9:
//                name = "J"
//            case 10:
//                name = "Q"
//            case 11:
//                name = "K"
//            case 12:
//                name = "A"
//            default:
//                break
//            }
//            return suit + name
//        }
//    }
    
    var name: Names {
        get {
            switch value {
            case 0...3:
                return .two
            case 4...7:
                return .three
            case 8...11:
                return .four
            case 12...15:
                return .five
            case 16...19:
                return .six
            case 20...23:
                return .seven
            case 24...27:
                return .eight
            case 28...31:
                return .nine
            case 32...35:
                return .ten
            case 36...39:
                return .jack
            case 40...43:
                return .queen
            case 44...47:
                return .king
            default:
                return .ace
            }
        }
    }
    
    init(with value: UInt) {
        self.value = value
    }
}


enum Names: UInt {
    case aceZero = 0
    case two = 1
    case three = 2
    case four = 3
    case five = 4
    case six = 5
    case seven = 6
    case eight = 7
    case nine = 8
    case ten = 9
    case jack = 10
    case queen = 11
    case king = 12
    case ace = 13
}
