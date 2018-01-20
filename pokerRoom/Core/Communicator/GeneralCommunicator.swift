//
//  GeneralCommunicator.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation
import BluetoothKit

protocol CommunicatorDelegate: class {
    func didReceiveData(data: Data)
}

class GeneralCommunicator {
    
    //MARK: - Variables
    
    weak var delegate: CommunicatorDelegate?
    
    //MARK: - Constants
    
    struct Constants {
        let dataServiceUUID = UUID(uuidString: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B23")!
        let dataServiceCharacteristicUUID = UUID(uuidString: "477A2967-1FAB-4DC5-920A-DEE5DE685A3D")!
    }
    
    //MARK: - Abstract
    
    public func send(data: Data) {
        
    }
}


