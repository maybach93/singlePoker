//
//  HostGameCoordinator.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

class HostGameCoordinator: GameCoordinator {
    
    //MARK: - Variables
    
    var opponent: Player? {
        get {
            return gameController.players.filter { $0.id != player.id }.first
        }
    }
    var centralCommunicator: CentralCommunicator {
        get {
            return self.communicator as! CentralCommunicator
        }
    }
    
    //MARK: - Lifecycle
    
    init(player: Player, gameConfiguration: GameConfiguration?) {
        super.init(player: player)
        self.player = player
        self.communicator = CentralCommunicator()
        self.centralCommunicator.centralDelegate = self
        self.gameConfiguration = gameConfiguration
    }
    
    //MARK: - Override
    
    override func receiveMessage(message: Message) {
        switch message.type {
        case .peripheralInfo:
            if let playerInfoData = message.data as? PlayerInfoData {
                self.startGame(peripheralInfoData: playerInfoData)
            }
        default:
            break
        }
    }
    
    //MARK: - Messaging
    
    //MARK: - Private
    
    private func startGame(peripheralInfoData: PlayerInfoData) {
        guard let sGameConfiguration = self.gameConfiguration else { return }
        let peripheralPlayer = Player(playerInfoData: peripheralInfoData)
        let players = [player, peripheralPlayer]
        for (index, player) in players.enumerated() {
            player.balance = sGameConfiguration.startStack
            player.position = index
        }
        
        gameController.players = players
        gameController.bigBlind = sGameConfiguration.bigBlind
        gameController.blindsUpdateTime = sGameConfiguration.blindsUpdateTime
        gameController.start()
        self.delegate?.newGameStarted()
    }
    
    fileprivate func holeCard(for player: Player) -> [PlayerInfoData] {
        var playersInfoData = [PlayerInfoData]()
        
        for currentPlayer in gameController.players {
            let playerInfoData = PlayerInfoData(player: currentPlayer)
            if currentPlayer.id == player.id {
                playerInfoData.cards = currentPlayer.cards.map { $0.value }
            }
            playersInfoData.append(playerInfoData)
        }
        return playersInfoData
    }
}

extension HostGameCoordinator: CentralCommunicatorDelegate {
    func didFoundPeripheral() {
        guard let sGameConfiguration = self.gameConfiguration else { return }
        let gameConfigurationMessageData = GameConfigurationMessageData(gameConfiguration: sGameConfiguration, hostPlayer: player)
        let message = Message(type: MessageTypes.gameConfiguration, data: gameConfigurationMessageData)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.sendMessage(message: message)
        }
    }
}

extension HostGameCoordinator: GameControllerDelegate {
    
    func newGameStarted() {
        let startGameInfoData = StartGameInfoData(buttonPosition: gameController.buttonPosition, playersInfoData: self.holeCard(for: self.opponent!))
        let message = Message(type: .startGameInfo, data: startGameInfoData)
        self.sendMessage(message: message)
        
    }
    
    func bankAmountChanged() {
        
    }
    func streetChanged() {
        
    }
    func currentPlayerChanged() {
        
    }
    func commonCardsUpdated() {
        
    }
    func gameEnded(winner: Player) {
        
    }
    func blindsUpdated() {
        
    }
    func gameFinished(winner: Player, amount: Float, showOpponentCards: Bool) {
        
    }
    func gameFinished(split: [Player], amount: Float) {
        
    }
    func winnerHand(hand: Hand) {
        
    }
    func playerDidBet(player: Player, bet: Float) {
        
    }
    func playerDidRaise(player: Player, raise: Float) {
        
    }
    func playerDidCall(player: Player, call: Float) {
        
    }
    func playerDidFold(player: Player) {
        
    }
    func playerDidCheck(player: Player) {
        
    }

}
