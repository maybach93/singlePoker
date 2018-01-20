//
//  PeripheralCommunicator.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation
import BluetoothKit

class PeripheralCommunicator: GeneralCommunicator {
    
    //MARK: - Variables
    
    private let peripheral = BKPeripheral()
    
    //MARK: - Lifecycle
    
    override init() {
        super.init()
        startPeripheral()
    }
    
    deinit {
        _ = try? peripheral.stop()
    }
    
    //MARK: - Private
    
    private func startPeripheral() {
        do {
            peripheral.delegate = self
            peripheral.addAvailabilityObserver(self)
            let localName = Bundle.main.infoDictionary!["CFBundleName"] as? String
            let configuration = BKPeripheralConfiguration(dataServiceUUID: Constants().dataServiceUUID, dataServiceCharacteristicUUID: Constants().dataServiceCharacteristicUUID, localName: localName)
            try peripheral.startWithConfiguration(configuration)
        } catch let error {
            print("Error starting: \(error)")
        }
    }
    
    //MARK: - Override
    
    override func send(data: Data) {
        super.send(data: data)

        for remoteCentral in peripheral.connectedRemoteCentrals {
            //Logger.log("Sending to \(remoteCentral)")
            peripheral.sendData(data, toRemotePeer: remoteCentral) { _, remoteCentral, error in
                guard error == nil else {
                    //Logger.log("Failed sending to \(remoteCentral)")
                    return
                }
                //Logger.log("Sent to \(remoteCentral)")
            }
        }
    }
}

extension PeripheralCommunicator: BKAvailabilityObserver {
    
    func availabilityObserver(_ availabilityObservable: BKAvailabilityObservable, unavailabilityCauseDidChange unavailabilityCause: BKUnavailabilityCause) {
        
    }
    
    internal func availabilityObserver(_ availabilityObservable: BKAvailabilityObservable, availabilityDidChange availability: BKAvailability) {

    }
}

extension PeripheralCommunicator: BKRemotePeerDelegate {
    func remotePeer(_ remotePeer: BKRemotePeer, didSendArbitraryData data: Data) {
        self.delegate?.didReceiveData(data: data)
    }
}

extension PeripheralCommunicator: BKPeripheralDelegate {
    
    internal func peripheral(_ peripheral: BKPeripheral, remoteCentralDidConnect remoteCentral: BKRemoteCentral) {
        //Logger.log("Remote central did connect: \(remoteCentral)")
        remoteCentral.delegate = self
        //refreshControls()
    }
    
    internal func peripheral(_ peripheral: BKPeripheral, remoteCentralDidDisconnect remoteCentral: BKRemoteCentral) {
        //Logger.log("Remote central did disconnect: \(remoteCentral)")
        //refreshControls()
    }
}

