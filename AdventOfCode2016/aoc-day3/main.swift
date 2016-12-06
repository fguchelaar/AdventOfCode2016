//
//  main.swift
//  aoc-day3
//
//  Created by Frank Guchelaar on 06/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day3/input.txt")

var sideLengths = input.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: CharacterSet.newlines)

//: ## Part One
let possibleTriangles = sideLengths.reduce(0, { (result, sideLength) in
    
    let sides = sideLength.components(separatedBy: CharacterSet.whitespaces)
        .filter{ !$0.isEmpty }
        .map { Int($0)! }
        .sorted(by: <)
    
    return sides[0] + sides[1] > sides[2] ? result + 1 : result
    
})

print ("1) There are \(possibleTriangles) possible triangles")

//: ## Part Two
let intValues = input
    .components(separatedBy: CharacterSet.whitespacesAndNewlines)
    .filter { !$0.isEmpty }
    .map { Int($0)! }

var possibleTriangles2 = 0

for column in 0...2 {
    
    for sidesIndex in stride(from: column, to: intValues.count, by: 9) {
        
        let sides = [intValues[sidesIndex + 0],
                     intValues[sidesIndex + 3],
                     intValues[sidesIndex + 6]]
            .sorted(by: <)
        
        possibleTriangles2 = sides[0] + sides[1] > sides[2] ? possibleTriangles2 + 1 : possibleTriangles2
    }
}

print ("2) There are \(possibleTriangles2) possible triangles")
