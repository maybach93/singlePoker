//
//  RandomPokerMachine.swift
//  videopoker
//
//  Created by Vitalii Poponov on 02.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

class RandomPokerMachine {
    var outCards: [Int] = []
 
    
    func reset() {
        self.outCards = []
    }

    func getCards(count: Int) -> [Card] {
        var cards: [Card] = []
        for _ in 1...count {
            cards.append(Card.init(with: self.getCardNumber()))
        }
        return cards
    }
    
    //MARK: - Private

    private func getCardNumber() -> Int {
        var random: Int = 0
        repeat {
            random = Int(arc4random_uniform(52))
        }while( self.outCards.contains(random) )
        self.outCards.append(random)
        return random
    }
}
