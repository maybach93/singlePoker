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
    
    var opponent: Player?
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
        self.hostGameController.delegate = self
        self.hostGameController.myPlayerId = self.player.id
    }
    
    //MARK: - Override
    
    override func receiveMessage(message: Message) {
        switch message.type {
        case .peripheralInfo:
            if let playerInfoData = message.data as? PlayerInfoData {
                self.startGame(peripheralInfoData: playerInfoData)
            }
            
        case .playerDidBet:
            if let playerActionMessageData = message.data as? PlayerActionMessageData {
                guard let player = playerActionMessageData.player?.player, let amount = playerActionMessageData.amount else { return }
                self.hostGameController.bet(player: player, size: amount)
            }
        case .playerDidCall:
            if let playerActionMessageData = message.data as? PlayerActionMessageData {
                guard let player = playerActionMessageData.player?.player, let _ = playerActionMessageData.amount else { return }
                self.hostGameController.call(player: player)
            }
        case .playerDidFold:
            if let playerActionMessageData = message.data as? PlayerActionMessageData {
                guard let player = playerActionMessageData.player?.player, let _ = playerActionMessageData.amount else { return }
                self.hostGameController.fold(player: player)
            }
        case .playerDidCheck:
            if let playerActionMessageData = message.data as? PlayerActionMessageData {
                guard let player = playerActionMessageData.player?.player, let _ = playerActionMessageData.amount else { return }
                self.hostGameController.check(player: player)
            }
        case .playerDidRaise:
            if let playerActionMessageData = message.data as? PlayerActionMessageData {
                guard let player = playerActionMessageData.player?.player, let amount = playerActionMessageData.amount else { return }
                self.hostGameController.bet(player: player, size: amount)
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
        self.opponent = peripheralPlayer
        let players = [player, peripheralPlayer]
        for (index, player) in players.enumerated() {
            player.balance = sGameConfiguration.startStack
            player.position = index
        }
        self.hostGameController.players = players
        self.hostGameController.bigBlind = sGameConfiguration.bigBlind;
        self.hostGameController.blindsUpdateTime = sGameConfiguration.blindsUpdateTime;
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hostGameController.start()
        }
    
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
        gameStateData.playersInfoData = self.holeCard(for: self.opponent!)
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
        self.gameControllerDelegate?.bankAmountChanged()
    }
    func streetChanged() {
        let message = Message(type: .streetChanged, data: gameStateData())
        self.sendMessage(message: message)
        self.gameControllerDelegate?.streetChanged()
    }
    func currentPlayerChanged() {
        let message = Message(type: .currentPlayerChanged, data: gameStateData())
        self.sendMessage(message: message)
        self.gameControllerDelegate?.currentPlayerChanged()
    }
    func commonCardsUpdated() {
        let message = Message(type: .commonCardsUpdated, data: gameStateData())
        self.sendMessage(message: message)
        self.gameControllerDelegate?.commonCardsUpdated()
    }
    func blindsUpdated() {
        let message = Message(type: .blindsUpdated, data: gameStateData())
        self.sendMessage(message: message)
        self.gameControllerDelegate?.blindsUpdated()
    }
    func gameEnded(winner: Player) {
        let gameEndMessageData = GameEndMessageData(amount: 0, playersInfoData: self.holeCard(for: self.opponent!), winners: [PlayerInfoData(player: winner)])
        let message = Message(type: .gameEnded, data: gameEndMessageData)
        self.sendMessage(message: message)
        self.gameControllerDelegate?.gameEnded(winner: winner)
    }
    
    func gameFinished(winner: Player, amount: Float, showOpponentCards: Bool) {
        let gameEndMessageData = GameEndMessageData(amount: amount, playersInfoData: self.holeCard(for: self.opponent!), winners: [PlayerInfoData(player: winner)])
        let message = Message(type: .gameFinished, data: gameEndMessageData)
        self.sendMessage(message: message)
        self.gameControllerDelegate?.gameFinished(winner: winner, amount: amount, showOpponentCards: showOpponentCards)
    }
    func gameFinished(split: [Player], amount: Float) {
        let gameEndMessageData = GameEndMessageData(amount: amount, playersInfoData: self.holeCard(for: self.opponent!), winners: split.map { PlayerInfoData(player: $0) })
        let message = Message(type: .gameFinishedSplit, data: gameEndMessageData)
        self.sendMessage(message: message)
        self.gameControllerDelegate?.gameFinished(split: split, amount: amount)
    }
    func winnerHand(hand: Hand) {
        //only host TO DO LATER
        self.gameControllerDelegate?.winnerHand(hand: hand)
    }
    func playerDidBet(player: Player, bet: Float) {
        _playerDidBet(player: player, bet: bet)
    }
    func playerDidRaise(player: Player, raise: Float) {
        _playerDidRaise(player: player, raise: raise)
    }
    func playerDidCall(player: Player, call: Float) {
        _playerDidCall(player: player, call: call)
    }
    func playerDidFold(player: Player) {
        _playerDidFold(player: player)
    }
    func playerDidCheck(player: Player) {
        _playerDidCheck(player: player)
    }
}
