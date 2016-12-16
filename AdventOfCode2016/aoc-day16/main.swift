//
//  main.swift
//  aoc-day16
//
//  Created by Frank Guchelaar on 16/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

extension Collection where Iterator.Element == Bool {
    func dragonCurve(length: Int) -> Array<Bool> {
        let selfAsArray = (self as! [Bool])
        let dragonCurve = selfAsArray + [false] + selfAsArray.reversed().map{ !$0 }
        if dragonCurve.count < length {
            return dragonCurve.dragonCurve(length: length)
        }
        return [Bool](dragonCurve.prefix(length))
    }
    
    func checksum() -> Array<Bool> {
        let selfAsArray = (self as! [Bool])
        var checksum = [Bool](repeating: false, count: selfAsArray.count/2)
        for idx in stride(from: 0, to: selfAsArray.count, by: 2) {
            checksum[idx/2] = (selfAsArray[idx] == selfAsArray[idx.advanced(by: 1)])
        }
        if checksum.count % 2 == 0 {
            return checksum.checksum()
        }
        return checksum
    }
}

var input = "10001001100000001".characters.map { $0 == "1" }

// Part One
print("--- PART ONE ---")
measure {
    print ("Checksum: \(input.dragonCurve(length: 272).checksum().map { $0 ? "1" : "0" }.joined())")
}

// Part Two
print("--- PART TWO ---")
measure {
    print ("Checksum: \(input.dragonCurve(length: 35651584).checksum().map { $0 ? "1" : "0" }.joined())")
}
