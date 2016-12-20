//
//  main.swift
//  aoc-day18
//
//  Created by Frank Guchelaar on 18/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

let safe = Character(".")
let trap = Character("^")

var input = ".^^..^...^..^^.^^^.^^^.^^^^^^.^.^^^^.^^.^^^^^^.^...^......^...^^^..^^^.....^^^^^^^^^....^^...^^^^..^".characters.map { $0==trap }

func isTrap(at position: Int, andPreviousRow previousRow: [Bool]) -> Bool {
    
    if position < 0 || position >= previousRow.count {
        return false
    }
    
    return previousRow[position]
}

func tileForRow(at position: Int, andPreviousRow previousRow: [Bool]) -> Bool {
    let left = isTrap(at: position-1, andPreviousRow: previousRow)
    let center = isTrap(at: position, andPreviousRow: previousRow)
    let right = isTrap(at: position+1, andPreviousRow: previousRow)
    
    return (left && center && !right)
        || (!left && center && right)
        || (left && !center && !right)
        || (!left && !center && right)
}

func expandMap(firstRow: [Bool], rows: Int) -> [[Bool]] {
    
    let count = firstRow.count
    
    var map = [[Bool]]()
    map.append(firstRow)
    for r in 1..<rows { // row 0 is the starting row
        var newRow = [Bool]()
        let previousRow = map[r-1]
        for i in 0..<count {
            newRow.append(tileForRow(at: i, andPreviousRow: previousRow))
        }
        map.append(newRow)
    }
    return map
}

measure {
    print (expandMap(firstRow: input, rows: 40).joined().filter { !$0 }.count)
}

measure {
    print (expandMap(firstRow: input, rows: 400000).joined().filter { !$0 }.count)
}
