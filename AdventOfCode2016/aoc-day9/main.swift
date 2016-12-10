//
//  main.swift
//  aoc-day9
//
//  Created by Frank Guchelaar on 09/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

extension String {
    
    func stringByRepeating(times: Int) -> String {
        return (0..<times-1).reduce(self, { (result, index) -> String in
            return result + self
        })
    }
}

extension String {
    
    func isCompressed() -> Bool {
        return self.contains("(")
    }
    
    func decompress() -> (Int, String) {
        var subCount : Int = 0
        var toDecompress = self
        var i = 0
        
        if let startAt = self.range(of: "(") {
            subCount = self.distance(from: self.startIndex, to: startAt.lowerBound)
            toDecompress = self.substring(from: startAt.lowerBound)
        }
        
        var decompressed = ""
        var controlCode : String? = nil
        while i < toDecompress.characters.count {
            
            let index = toDecompress.index(toDecompress.startIndex, offsetBy: i)
            let character = self[index]
            switch character {
            case Character("(") :
                controlCode = ""
            case Character(")") :
                
                let codes = controlCode!.components(separatedBy: "x")
                let numberOfCharacters = Int(codes[0])!
                let repeatCount = Int(codes[1])!
                
                let start = toDecompress.index(index, offsetBy: 1)
                let end = toDecompress.index(start, offsetBy: numberOfCharacters)
                let toCopy = toDecompress.substring(with: Range(uncheckedBounds: (start, end)))
                decompressed.append(toCopy.stringByRepeating(times: repeatCount))
                i += numberOfCharacters
                controlCode = nil
            default:
                if controlCode == nil {
                    decompressed.append(character)
                }
                else {
                    controlCode!.append(character)
                }
            }
            i += 1
        }
        return (subCount,decompressed)
    }
}

var input = try String(contentsOfFile: "day9/input.txt").trimmingCharacters(in: .whitespacesAndNewlines)

// Part One:
let part1 = input.decompress()
print(part1.1.characters.count)

// Part Two:
var compressed = (0,input)
var taly = 0
while compressed.1.isCompressed() {
    compressed = compressed.1.decompress()
    taly += compressed.0
    print (taly)
    
}
print(taly + compressed.1.characters.count)
