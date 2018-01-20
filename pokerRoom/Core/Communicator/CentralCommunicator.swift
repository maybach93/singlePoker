//
//  CentralCommunicator.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation
import BluetoothKit

protocol CentralCommunicatorDelegate: class {
    func didFoundPeripheral()
}


class CentralCommunicator: GeneralCommunicator {
    
    //MARK: - Variables
    
    private var remotePeripheral: BKRemotePeripheral? {
        didSet {
            guard let sRemotePeripheral = remotePeripheral else { return }
            sRemotePeripheral.delegate = self
            sRemotePeripheral.peripheralDelegate = self
        }
    }
    fileprivate let central = BKCentral()
    weak var centralDelegate: CentralCommunicatorDelegate?
    
    //MARK: - Lifecycle
    
    override init() {
        super.init()
        startCentral()
        //scan()
    }
    
    deinit {
        _ = try? central.stop()
    }
    
    //MARK: - Private
    
    fileprivate func startCentral() {
        do {
            central.delegate = self
            central.addAvailabilityObserver(self)
            let configuration = BKConfiguration(dataServiceUUID: Constants().dataServiceUUID, dataServiceCharacteristicUUID: Constants().dataServiceCharacteristicUUID)
            try central.startWithConfiguration(configuration)
        } catch let error {
            print("Error while starting: \(error)")
        }
    }
    
    fileprivate func scan() {
        central.scanContinuouslyWithChangeHandler({ [weak self] changes, discoveries in
            guard let sSelf = self else { return }
            if discoveries.count > 0 {
                let discovery = discoveries.first
                sSelf.central.connect(remotePeripheral: discovery!.remotePeripheral) { remotePeripheral, error in
                    guard error == nil else {
                        print("Error connecting peripheral: \(String(describing: error))")
                        return
                    }
                    sSelf.remotePeripheral = remotePeripheral
                    sSelf.central.interruptScan()
                    sSelf.centralDelegate?.didFoundPeripheral()
                }
            }
        }, stateHandler: { newState in
            if newState == .scanning {
                //self.activityIndicator?.startAnimating()
                return
            } else if newState == .stopped {
                //self.discoveries.removeAll()
                //self.discoveriesTableView.reloadData()
            }
            //self.activityIndicator?.stopAnimating()
        }, errorHandler: { error in
            
        })
    }
    
    //MARK: - Override
    
    override func send(data: Data) {
        super.send(data: data)
        guard let sRemotePeripheral = self.remotePeripheral else { return }
        
        central.sendData(data, toRemotePeer: sRemotePeripheral) { _, remotePeripheral, error in
            guard error == nil else {
                //Logger.log("Failed sending to \(remotePeripheral)")
                return
            }
            //Logger.log("Sent to \(remotePeripheral)")
        }
    }
}

extension CentralCommunicator: BKAvailabilityObserver {
    
    func availabilityObserver(_ availabilityObservable: BKAvailabilityObservable, unavailabilityCauseDidChange unavailabilityCause: BKUnavailabilityCause) {
        
    }
    
    internal func availabilityObserver(_ availabilityObservable: BKAvailabilityObservable, availabilityDidChange availability: BKAvailability) {
        //availabilityView.availabilityObserver(availabilityObservable, availabilityDidChange: availability)
        if availability == .available {
            scan()
        } else {
            central.interruptScan()
        }
    }
}

extension CentralCommunicator: BKCentralDelegate, BKRemotePeripheralDelegate, BKRemotePeerDelegate {
    
    // MARK: BKRemotePeripheralDelegate
    
    internal func remotePeripheral(_ remotePeripheral: BKRemotePeripheral, didUpdateName name: String) {
    }
    
    internal func remotePeer(_ remotePeer: BKRemotePeer, didSendArbitraryData data: Data) {
        self.delegate?.didReceiveData(data: data)
    }
    
    internal func remotePeripheralIsReady(_ remotePeripheral: BKRemotePeripheral) {
    }
    
    func central(_ central: BKCentral, remotePeripheralDidDisconnect remotePeripheral: BKRemotePeripheral) {
    }
    
}
