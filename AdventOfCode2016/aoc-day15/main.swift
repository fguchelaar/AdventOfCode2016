//
//  main.swift
//  aoc-day15
//
//  Created by Frank Guchelaar on 15/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

class Disc {
    
    let numberOfPositions: Int
    let positionAtTime0: Int
    var currentPosition: Int
    
    init(numberOfPositions: Int, positionAtTime0: Int) {
        self.numberOfPositions = numberOfPositions
        self.positionAtTime0 = positionAtTime0
        self.currentPosition = positionAtTime0
    }
    
    func rotateFromPosition0(steps: Int) {
        currentPosition = (positionAtTime0 + steps) % numberOfPositions
    }
}

/*
 Disc #1 has 5 positions; at time=0, it is at position 2.
 Disc #2 has 13 positions; at time=0, it is at position 7.
 Disc #3 has 17 positions; at time=0, it is at position 10.
 Disc #4 has 3 positions; at time=0, it is at position 2.
 Disc #5 has 19 positions; at time=0, it is at position 9.
 Disc #6 has 7 positions; at time=0, it is at position 0.
 */

let discs = [
    Disc(numberOfPositions: 5, positionAtTime0: 2),
    Disc(numberOfPositions: 13, positionAtTime0: 7),
    Disc(numberOfPositions: 17, positionAtTime0: 10),
    Disc(numberOfPositions: 3, positionAtTime0: 2),
    Disc(numberOfPositions: 19, positionAtTime0: 9),
    Disc(numberOfPositions: 7, positionAtTime0: 0),
    // Uncomment for Part Two
    Disc(numberOfPositions: 11, positionAtTime0: 0)
]

var time = -1
repeat {
    time += 1
    for (index, disc) in discs.enumerated() {
        for _ in 0...index {
            disc.rotateFromPosition0(steps: time + 1 + index)
        }
    }
} while !discs.reduce(true, { $0 && $1.currentPosition==0 })
print (time)
