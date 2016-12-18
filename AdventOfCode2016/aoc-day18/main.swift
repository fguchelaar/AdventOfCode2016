//
//  main.swift
//  aoc-day18
//
//  Created by Frank Guchelaar on 18/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = ".^^..^...^..^^.^^^.^^^.^^^^^^.^.^^^^.^^.^^^^^^.^...^......^...^^^..^^^.....^^^^^^^^^....^^...^^^^..^"

let safe = Character(".")
let trap = Character("^")

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
}

func isTrap(at position: Int, andPreviousRow previousRow: String) -> Bool {
    
    if position < 0 || position >= previousRow.characters.count {
        return false
    }
    
    return previousRow[position] == trap
}

func tileForRow(at position: Int, andPreviousRow previousRow: String) -> Character {
    let left = isTrap(at: position-1, andPreviousRow: previousRow)
    let center = isTrap(at: position, andPreviousRow: previousRow)
    let right = isTrap(at: position+1, andPreviousRow: previousRow)
    
    return (left && center && !right)
        || (!left && center && right)
        || (left && !center && !right)
        || (!left && !center && right) ? trap : safe
}

func expandMap(firstRow: String, rows: Int) -> [String] {
    
    let count = firstRow.characters.count
    
    var map = Array<String>(repeating: "", count: rows)
    map[0] = firstRow
    for r in 1..<rows { // row 0 is the starting row
        var newRow = ""
        let previousRow = map[r-1]
        for i in 0..<count {
            newRow.append(tileForRow(at: i, andPreviousRow: previousRow))
        }
        map[r] = newRow
    }
    return map
}

measure {
    print (expandMap(firstRow: input, rows: 40).joined().characters.filter { $0 == safe }.count)
}

measure {
    print (expandMap(firstRow: input, rows: 400000).joined().characters.filter { $0 == safe }.count)
}
