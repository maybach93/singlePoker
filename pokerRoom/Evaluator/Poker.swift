//
//  Poker.swift
//  Poker
//
//  Created by Jorge Izquierdo on 9/22/15.
//  Copyright © 2015 Jorge Izquierdo. All rights reserved.
//

infix operator |*| {}
public func startGame() -> Deck {
    return Deck.newDeck().orderedDeck()
}