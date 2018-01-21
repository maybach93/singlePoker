//
//  GameController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 03.07.17.
//  Copyright © 2017 Vitalii Poponov. All rights reserved.
//

import Foundation

class PeripheralGameController: GameController {
    
    //MARK: - Private
    
    override func prepareNewGame() {
        super.prepareNewGame()
        self.delegate?.newGameStarted()
    }

    //MARK : - check

    
    override func bet(size: Float) {

    }
    
    //MARK: - Indexes
    
}

