//
//  GameCoordinator.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

class GameCoordinator {
    
    //MARK: - Variables
    
    var communicator: GeneralCommunicator? {
        didSet {
            if let sCommunicator = communicator {
                sCommunicator.delegate = self
            }
        }
    }
    
    var isGameHost: Bool {
        get {
            return self.communicator is CentralCommunicator
        }
    }
    
    func sendMessage(message: Message) {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(message)
        communicator?.sendData()
    }
    
    func receiveMessage() {
        
    }
}

extension GameCoordinator: CommunicatorDelegate {
    func didReceiveData(data: Data) {

        let jsonDecoder = JSONDecoder()
        let message = try? jsonDecoder.decode(Message.self, from: data)
        print(message)
    }
}

//func bankAmountChanged()
//func newGameStarted()
//func streetChanged()
//func currentPlayerChanged()
//func commonCardsUpdated()
//func gameEnded(winner: Player)
//func blindsUpdated()
//func gameFinished(winner: Player, amount: Float, showOpponentCards: Bool)
//func gameFinished(split: [Player], amount: Float)
//func winnerHand(hand: Hand)
//func playerDidBet(player: Player, bet: Float)
//func playerDidRaise(player: Player, raise: Float)
//func playerDidCall(player: Player, call: Float)
//func playerDidFold(player: Player)
//func playerDidCheck(player: Player)

