//
//  ViewController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let deck = Poker.startGame()
        
        let cards = [.ace |*| .spades, .two |*| .hearts, .three |*| .spades, .four |*| .hearts, .ten |*| .spades]
        let hand = Hand(cards: cards).valueHand()
        
        let t = Table(cards: cards)
        let b1 = t.bestHandWithCards(cards: [.five |*| .clubs, .jack |*| .diamonds])!
        let b2 = t.bestHandWithCards(cards: [.five |*| .clubs, .seven |*| .diamonds])!
        
        
        let bool = bestHand(hand1: b1, b2)

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

