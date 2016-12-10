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
    
    func decompress(recurse: Bool) -> Int {

        var subCount : Int = 0
        
        var toDecompress = self
        
        var i = 0
        
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
                
                if recurse {
                    subCount += toCopy.decompress(recurse: recurse) * repeatCount
                }
                else {
                    subCount += numberOfCharacters * repeatCount
                }
                
                i += numberOfCharacters
                controlCode = nil
            default:
                if controlCode == nil {
                    subCount += 1
                }
                else {
                    controlCode!.append(character)
                }
            }
            i += 1
        }
        return subCount
    }
}

var input = try String(contentsOfFile: "day9/input.txt").trimmingCharacters(in: .whitespacesAndNewlines)


// Part One:
print(input.decompress(recurse: false))


// Part Two:
print(input.decompress(recurse: true))
