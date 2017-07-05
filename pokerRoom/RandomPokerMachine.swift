//
//  RandomPokerMachine.swift
//  videopoker
//
//  Created by Vitalii Poponov on 02.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

class RandomPokerMachine {
    var outCards: [UInt] = []
 
    
    func reset() {
        self.outCards = []
    }

    func getCards(count: Int) -> [PokerCard] {
        var cards: [PokerCard] = []
        for _ in 0...count {
            cards.append(PokerCard.init(with: self.getCardNumber()))
        }
        return cards
    }
    
    //MARK: - Private

    private func getCardNumber() -> UInt {
        var random: UInt = 0
        repeat {
            random = UInt(arc4random_uniform(52))
        }while( self.outCards.contains(random) )
        self.outCards.append(random)
        return random
    }
}
