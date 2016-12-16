//
//  main.swift
//  aoc-day16
//
//  Created by Frank Guchelaar on 16/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

extension String {
    
    func dragonCurve() -> String {
        var b = String(self.characters.reversed())
        b = b.replacingOccurrences(of: "0", with: "#")
        b = b.replacingOccurrences(of: "1", with: "0")
        b = b.replacingOccurrences(of: "#", with: "1")
        return "\(self)0\(b)"
    }
}

extension String {
    func checksum() -> String {
        
        var checksum = ""
        for start in stride(from: 0, to: self.characters.count, by: 2) {
            let startIdx = self.index(self.startIndex, offsetBy: start)
            let endIdx =  self.index(after: startIdx)
            if self.characters[startIdx] == self.characters[endIdx] {
                checksum.append("1")
            }
            else {
                checksum.append("0")
            }
        }
        
        if checksum.characters.count % 2 == 0 {
            return checksum.checksum()
        }
        return checksum
    }
}

// Part One
print("--- PART ONE ---")
var input = "10001001100000001"
var length = 272
measure {
    while input.characters.count < length {
        input = input.dragonCurve()
    }
}
measure {
    input = input.substring(to: input.index(input.startIndex, offsetBy: length))
    print ("Checksum: \(input.checksum())")
}

// Part Two
print("--- PART ONE ---")
length = 35651584
measure {
    while input.characters.count < length {
        input = input.dragonCurve()
    }
}
measure {
    input = input.substring(to: input.index(input.startIndex, offsetBy: length))
    print ("Checksum: \(input.checksum())")
}
