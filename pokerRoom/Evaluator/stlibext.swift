//
//  stlibext.swift
//  Poker
//
//  Created by Jorge Izquierdo on 9/22/15.
//  Copyright © 2015 Jorge Izquierdo. All rights reserved.
//

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substring(with: Range.init(uncheckedBounds: (lower: self.index(startIndex, offsetBy: r.lowerBound), upper: self.index(startIndex, offsetBy: r.upperBound))))
    }
}
