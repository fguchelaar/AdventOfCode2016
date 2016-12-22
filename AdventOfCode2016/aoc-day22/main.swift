//
//  main.swift
//  aoc-day22
//
//  Created by Frank Guchelaar on 22/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day22/input.txt").trimmingCharacters(in: .whitespacesAndNewlines)

struct Node {
    let path : String
    let size: Int
    let used: Int
    let avail: Int
    let percentageUsed: Int
    
}

let regex = try! NSRegularExpression(pattern: "(?<path>[a-zA-Z\\/\\-0-9]+)\\s+(?<size>\\d+)T\\s+(?<used>\\d+)T\\s+(?<avail>\\d+)T\\s+(?<percentageUsed>\\d+)%", options: .caseInsensitive)

var nodes = [Node]()
let lines = input.components(separatedBy: .newlines)
for line in lines[2..<lines.count] {
    
    let matches = regex.matches(in: line, options: .reportCompletion, range: NSMakeRange(0, line.characters.count))
    
    let path = line.substring(with: line.rangeFromNSRange(aRange: matches[0].rangeAt(1)))
    let size = Int(line.substring(with: line.rangeFromNSRange(aRange: matches[0].rangeAt(2))))!
    let used = Int(line.substring(with: line.rangeFromNSRange(aRange: matches[0].rangeAt(3))))!
    let avail = Int(line.substring(with: line.rangeFromNSRange(aRange: matches[0].rangeAt(4))))!
    let percentageUsed = Int(line.substring(with: line.rangeFromNSRange(aRange: matches[0].rangeAt(5))))!
    
    nodes.append(Node(path: path, size: size, used: used, avail: avail, percentageUsed: percentageUsed))
    
}
// Part One
var sum = 0
for a in nodes {
    for b in nodes{
        if a.path != b.path
            && a.used != 0
            && a.used <= b.avail {
            sum += 1
        }
    }
}

print ("1) \(sum)")

// Part Two

var grid = [[Node]](repeatElement([Node](), count: 28))

// build the grid. The input seems to be nicely sorted
for x in 0...31 {
    for y in 0...27 {
        grid[y].append(nodes[ x * 28 + y])
    }
}

var description = grid.map { (column) -> String in
    return column.map { (node) -> String in
        return String(format: "%02dT/%02dT", node.used, node.size)
        }.joined(separator: "\t")
    }.joined(separator: "\n")

print (description)

// copied the output to Numbers and hand-counted the solution
