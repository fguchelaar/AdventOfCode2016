//
//  main.swift
//  aoc-day6
//
//  Created by Frank Guchelaar on 06/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy:r.lowerBound)
        let end = self.index(startIndex, offsetBy:r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}

var input = try String(contentsOfFile: "day6/input.txt")

var codes = input
    .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    .components(separatedBy: .newlines)

var mostUsedCharacters = ""
var leastUsedCharacters = ""

for idx in 0..<8 {
    
    let charactersAtIndex = codes.reduce("") { $0 + $1[idx] }
    let characterMap = charactersAtIndex.characters.reduce([Character : Int](), { (result, character) -> [Character : Int] in
        var newDict = result
        newDict[character] = (newDict[character] ?? 0) + 1
        return newDict
    })

    let sortedMap = characterMap.sorted { $0.value > $1.value }
    mostUsedCharacters.append((sortedMap.first?.key)!)
    leastUsedCharacters.append((sortedMap.last?.key)!)
}

//: ## Part One
print (mostUsedCharacters)

//: ## Part Two
print (leastUsedCharacters)
