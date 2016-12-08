//
//  main.swift
//  aoc-day8
//
//  Created by Frank Guchelaar on 08/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day8/input.txt")
var instructions = input
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)

struct Display : CustomStringConvertible {
    
    var matrix : [[Bool]]
    
    init(width: Int, height: Int) {
        matrix = Array(repeating: Array(repeating: false, count: width), count: height)
    }
    
    mutating func turnOn(columns: Int, rows: Int) {
        for y in 0..<rows {
            for x in 0..<columns {
                matrix[y][x] = true
            }
        }
    }
    
    mutating func rotate(row: Int, by: Int) {
        let currentValues = matrix[row]
        for x in 0..<currentValues.count {
            matrix[row][x] = currentValues[(x - (by % currentValues.count) + currentValues.count) % currentValues.count]
        }
    }
    
    mutating func rotate(column: Int, by: Int) {
        let currentMatrix = matrix
        for y in 0..<matrix.count {
            matrix[y][column] = currentMatrix[(y - (by % matrix.count) + matrix.count) % matrix.count][column]
        }
    }
    
    var lightsOn : Int {
        return matrix.reduce(0, { (result, rows) -> Int in
            return rows.reduce(result, { (result, state) -> Int in
                return result + (state ? 1 : 0)
            })
        })
    }
    
    var description: String {
        return matrix.map { (column) -> String in
            return column.map { (state) -> String in
                return state ? "#" : "."
                }.joined(separator: " ")
            }.joined(separator: "\n").appending("\nLights on: \(lightsOn)")
    }
}

var display = Display(width: 50, height: 6)
print ("Inital state")
print (display)

for instruction in instructions {
    
    let rect = "rect "
    let rotateColumn = "rotate column x="
    let rotateRow = "rotate row y="
    
    if instruction.hasPrefix(rect) {
        let digits = instruction.replacingOccurrences(of: rect, with: "").components(separatedBy: "x")
        display.turnOn(columns: Int(digits[0])!, rows: Int(digits[1])!)
    }
    else if instruction.hasPrefix(rotateColumn) {
        let digits = instruction.replacingOccurrences(of: rotateColumn, with: "").components(separatedBy: " by ")
        display.rotate(column: Int(digits[0])!, by: Int(digits[1])!)
    }
    else if instruction.hasPrefix(rotateRow) {
        let digits = instruction.replacingOccurrences(of: rotateRow, with: "").components(separatedBy: " by ")
        display.rotate(row: Int(digits[0])!, by: Int(digits[1])!)
    }

    // Uncomment for mediocre animation
//    print ("After \(instruction)")
//    print (display)
//    usleep(250000)
}

print (display)
