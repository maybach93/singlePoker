//
//  PeripheralGameCoordinator.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

class PeripheralGameCoordinator: GameCoordinator {
    
    //MARK: - Variables
    
    var hostPlayer: Player?
    
    //MARK: - Lifecycle
    
    override init(player: Player) {
        super.init(player: player)
        self.communicator = PeripheralCommunicator()
        self.gameController = PeripheralGameController()
        self.gameController.myPlayerId = self.player.id
        self.gameController.delegate = self
    }
    
    //MARK: - Override
    
    override func receiveMessage(message: Message) {
        
        func updateGameStateData(messageData: MessageData) {
            if let stateData = messageData as? GameStateMessageData {
                updateGameController(stateData: stateData)
            }
        }
        
        switch message.type {
        case .gameConfiguration:
            if let gameConfigurationMessageData = message.data as? GameConfigurationMessageData {
                self.gameConfiguration = gameConfigurationMessageData.gameConfiguration
            }
            self.sendPeripheralInfo()
        case .startGameInfo:
            if let startGameInfoData = message.data as? StartGameInfoData {
                if let playersInfoData = startGameInfoData.playersInfoData {
                    gameController.players = playersInfoData.map { Player(playerInfoData: $0) }
                }
                if let buttonPosition = startGameInfoData.buttonPosition {
                    gameController.buttonPosition = buttonPosition
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.gameControllerDelegate?.newGameStarted()
            }
            self.delegate?.newGameStarted()
            
        case .bankAmountChanged, .blindsUpdated, .commonCardsUpdated, .streetChanged, .currentPlayerChanged:
            updateGameStateData(messageData: message.data)
        case .gameEnded:
            if let gameEndMessageData = message.data as? GameEndMessageData {
                guard let winner = gameEndMessageData.winners?.first?.player else { return }
                self.gameControllerDelegate?.gameEnded(winner: winner)
            }
        case .gameFinished:
            if let gameEndMessageData = message.data as? GameEndMessageData {
                guard let winner = gameEndMessageData.winners?.first?.player, let amount = gameEndMessageData.amount else { return }
                self.gameControllerDelegate?.gameFinished(winner: winner, amount: amount, showOpponentCards: false) //TO DO show cards
            }
        case .gameFinishedSplit:
            if let gameEndMessageData = message.data as? GameEndMessageData {
                guard let winners = gameEndMessageData.winners?.map({ $0.player! }), let amount = gameEndMessageData.amount else { return }
                self.gameControllerDelegate?.gameFinished(split: winners, amount: amount)
            }
        case .playerDidBet:
            if let playerActionMessageData = message.data as? PlayerActionMessageData {
                guard let player = playerActionMessageData.player?.player, let amount = playerActionMessageData.amount else { return }
                 self.gameControllerDelegate?.playerDidBet(player: player, bet: amount)
            }
        case .playerDidCall:
            if let playerActionMessageData = message.data as? PlayerActionMessageData {
                guard let player = playerActionMessageData.player?.player, let amount = playerActionMessageData.amount else { return }
                self.gameControllerDelegate?.playerDidCall(player: player, call: amount)
            }
        case .playerDidFold:
            if let playerActionMessageData = message.data as? PlayerActionMessageData {
                guard let player = playerActionMessageData.player?.player, let _ = playerActionMessageData.amount else { return }
                self.gameControllerDelegate?.playerDidFold(player: player)
            }
        case .playerDidCheck:
            if let playerActionMessageData = message.data as? PlayerActionMessageData {
                guard let player = playerActionMessageData.player?.player, let _ = playerActionMessageData.amount else { return }
                self.gameControllerDelegate?.playerDidCheck(player: player)
            }
        case .playerDidRaise:
            if let playerActionMessageData = message.data as? PlayerActionMessageData {
                guard let player = playerActionMessageData.player?.player, let amount = playerActionMessageData.amount else { return }
                self.gameControllerDelegate?.playerDidRaise(player: player, raise: amount)
            }
        default:
            break
        }
    }
    var winners: [PlayerInfoData]?
    var playersInfoData: [PlayerInfoData]?
    var amount: Float?
    //MARK: - Private
    
    private func updateGameController(stateData: GameStateMessageData) {
        guard let bankAmount = stateData.bankAmount, let street = stateData.street, let commonCards = stateData.commonCards, let bigBlind = stateData.bigBlind, let currentActivePlayerPosition = stateData.currentActivePlayerPosition,
            let players = stateData.playersInfoData?.map ({ Player.init(playerInfoData: $0) }) else { return }
        self.gameController.currentBank = bankAmount
        self.gameController.street = Streets(rawValue: street)!
        self.gameController.commonCards = commonCards.map { Card(with: $0) }
        self.gameController.bigBlind = bigBlind
        self.gameController.currentActivePlayerPosition = currentActivePlayerPosition
        self.gameController.players = players
    }
    
    private func sendPeripheralInfo() {
        let message = Message(type: MessageTypes.peripheralInfo, data: PlayerInfoData(player: player))
        self.sendMessage(message: message)
    }
}


extension PeripheralGameCoordinator: GameControllerDelegate {
    
    func newGameStarted() {
        //only host
        self.gameControllerDelegate?.newGameStarted()
    }
    
    func bankAmountChanged() {
        self.gameControllerDelegate?.bankAmountChanged()
    }
    func streetChanged() {
        self.gameControllerDelegate?.streetChanged()
    }
    func currentPlayerChanged() {
        self.gameControllerDelegate?.currentPlayerChanged()
    }
    func commonCardsUpdated() {
        self.gameControllerDelegate?.commonCardsUpdated()
    }
    func blindsUpdated() {
        self.gameControllerDelegate?.blindsUpdated()
    }
    func gameEnded(winner: Player) {
        self.gameControllerDelegate?.gameEnded(winner: winner)
    }
    
    func gameFinished(winner: Player, amount: Float, showOpponentCards: Bool) {
        self.gameControllerDelegate?.gameFinished(winner: winner, amount: amount, showOpponentCards: showOpponentCards)
    }
    func gameFinished(split: [Player], amount: Float) {
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
