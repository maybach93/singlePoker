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
    
    var hostGameController: HostGameController {
        get {
            return self.gameController as! HostGameController
        }
    }
    
    //MARK: - Lifecycle
    
    init(player: Player, gameConfiguration: GameConfiguration?) {
        super.init(player: player)
        self.player = player
        self.communicator = CentralCommunicator()
        self.centralCommunicator.centralDelegate = self
        self.gameConfiguration = gameConfiguration
        self.gameController = HostGameController()
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
        self.hostGameController.delegate = self
        self.hostGameController.players = players
        self.hostGameController.start()
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
    
    fileprivate func gameStateData() -> GameStateMessageData {
        let gameStateData = GameStateMessageData()
        gameStateData.bankAmount = self.hostGameController.currentBank
        gameStateData.bigBlind = self.hostGameController.bigBlind
        gameStateData.commonCards = self.hostGameController.commonCards.map { $0.value }
        gameStateData.currentActivePlayerPosition = self.hostGameController.currentActivePlayerPosition
        gameStateData.street = self.hostGameController.street.rawValue
        return gameStateData
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
        //only host
        let startGameInfoData = StartGameInfoData(buttonPosition: gameController.buttonPosition, playersInfoData: self.holeCard(for: self.opponent!))
        let message = Message(type: .startGameInfo, data: startGameInfoData)
        self.sendMessage(message: message)
        self.gameControllerDelegate?.newGameStarted()
    }
    
    func bankAmountChanged() {
        let message = Message(type: .bankAmountChanged, data: gameStateData())
        self.sendMessage(message: message)
        //only host
    }
    func streetChanged() {
        let message = Message(type: .streetChanged, data: gameStateData())
        self.sendMessage(message: message)
        //only host
    }
    func currentPlayerChanged() {
        let message = Message(type: .currentPlayerChanged, data: gameStateData())
        self.sendMessage(message: message)
        //only host
    }
    func commonCardsUpdated() {
        let message = Message(type: .commonCardsUpdated, data: gameStateData())
        self.sendMessage(message: message)
        //only host
    }
    func blindsUpdated() {
        let message = Message(type: .blindsUpdated, data: gameStateData())
        self.sendMessage(message: message)
        //only host
    }
    func gameEnded(winner: Player) {
        let gameEndMessageData = GameEndMessageData(amount: 0, playersInfoData: self.holeCard(for: self.opponent!), winners: [PlayerInfoData(player: winner)])
        let message = Message(type: .gameEnded, data: gameEndMessageData)
        self.sendMessage(message: message)
        //only host
    }
    
    func gameFinished(winner: Player, amount: Float, showOpponentCards: Bool) {
        let gameEndMessageData = GameEndMessageData(amount: amount, playersInfoData: self.holeCard(for: self.opponent!), winners: [PlayerInfoData(player: winner)])
        let message = Message(type: .gameFinished, data: gameEndMessageData)
        self.sendMessage(message: message)
        //only host
    }
    func gameFinished(split: [Player], amount: Float) {
        let gameEndMessageData = GameEndMessageData(amount: amount, playersInfoData: self.holeCard(for: self.opponent!), winners: split.map { PlayerInfoData(player: $0) })
        let message = Message(type: .gameFinishedSplit, data: gameEndMessageData)
        self.sendMessage(message: message)
        //only host
    }
    func winnerHand(hand: Hand) {
        //only host TO DO LATER
    }
    func playerDidBet(player: Player, bet: Float) {
        let playerActionMessageData = PlayerActionMessageData(amount: bet, player: player)
        let message = Message(type: .playerDidBet, data: playerActionMessageData)
        self.sendMessage(message: message)
        //both
    }
    func playerDidRaise(player: Player, raise: Float) {
        let playerActionMessageData = PlayerActionMessageData(amount: raise, player: player)
        let message = Message(type: .playerDidRaise, data: playerActionMessageData)
        self.sendMessage(message: message)
        //both
    }
    func playerDidCall(player: Player, call: Float) {
        let playerActionMessageData = PlayerActionMessageData(amount: call, player: player)
        let message = Message(type: .playerDidCall, data: playerActionMessageData)
        self.sendMessage(message: message)
        //both
    }
    func playerDidFold(player: Player) {
        let playerActionMessageData = PlayerActionMessageData(amount: 0, player: player)
        let message = Message(type: .playerDidFold, data: playerActionMessageData)
        self.sendMessage(message: message)
        //both
    }
    func playerDidCheck(player: Player) {
        let playerActionMessageData = PlayerActionMessageData(amount: 0, player: player)
        let message = Message(type: .playerDidCheck, data: playerActionMessageData)
        self.sendMessage(message: message)
        //both
    }

}
