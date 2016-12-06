//
//  main.swift
//  aoc-day6
//
//  Created by Frank Guchelaar on 06/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day6/input.txt")

var codes = input
    .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    .components(separatedBy: .newlines)

var mostUsedCharacters = ""
var leastUsedCharacters = ""

for idx in 0..<8 {
    
    let charactersAtIndex = codes.reduce("") { $0 + $1[idx] }
    let sortedCharacterMap = charactersAtIndex.CharacterMap().sorted { $0.value > $1.value }

    mostUsedCharacters.append((sortedCharacterMap.first?.key)!)
    leastUsedCharacters.append((sortedCharacterMap.last?.key)!)
}

//: ## Part One
print (mostUsedCharacters)

//: ## Part Two
print (leastUsedCharacters)
