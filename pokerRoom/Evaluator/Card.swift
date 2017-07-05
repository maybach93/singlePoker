//
//  Card.swift
//  Poker
//
//  Created by Jorge Izquierdo on 9/22/15.
//  Copyright © 2015 Jorge Izquierdo. All rights reserved.
//

public struct Card: CardProtocol {
    
    public let number: Number
    public let suit: Suit
    
    init(number: Number, suit: Suit) {
        self.number = number
        self.suit = suit
    }
    
    init(with value: Int) {
        
        if stride(from: Suit.hearts.rawValue, to: 51, by: 4).contains(value) {
            self.suit = .hearts
        }
        else if stride(from: Suit.diamonds.rawValue, to: 51, by: 4).contains(value) {
            self.suit = .diamonds
        }
        else if stride(from: Suit.clubs.rawValue, to: 51, by: 4).contains(value) {
            self.suit = .clubs
        }
        else {
            self.suit = .spades
        }
        switch value {
        case 0...3:
            self.number = .two
        case 4...7:
            self.number = .three
        case 8...11:
            self.number = .four
        case 12...15:
            self.number = .five
        case 16...19:
            self.number = .six
        case 20...23:
            self.number = .seven
        case 24...27:
            self.number = .eight
        case 28...31:
            self.number = .nine
        case 32...35:
            self.number = .ten
        case 36...39:
            self.number = .jack
        case 40...43:
            self.number = .queen
        case 44...47:
            self.number = .king
        default:
            self.number = .ace
        }
    }
    
    static func sortedCards(cards: [Card]) -> [Card] {
        return cards.sorted{ $0.suit.rawValue == $1.suit.rawValue ? $0.number.orderValue < $1.number.orderValue : $0.suit.rawValue < $1.suit.rawValue }
    }
    
    static func textRepresentation(cards: [Card]) -> String {
        var string = ""
        for card in cards {
            string += " \(card.emojiValue)"
        }
        return string
    }
}

protocol CardProtocol {
    var number: Number { get }
    var suit: Suit { get }
}

extension Card: Emojiable {
    var emojiValue: String {
         return self.number.emojiValue + self.suit.emojiValue
    }
}

extension Card: CustomStringConvertible {
    public var description: String {
        return self.emojiValue
    }
}

public func |*| (lhs: Number, rhs: Suit) -> Card {
    return Card(number: lhs, suit: rhs)
}

extension Card: Equatable {
}

public func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs.number == rhs.number && lhs.suit == rhs.suit
}
