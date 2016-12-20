//
//  main.swift
//  aoc-day20
//
//  Created by Frank Guchelaar on 20/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day20/input.txt").trimmingCharacters(in: .whitespacesAndNewlines)

var ranges = input
    .components(separatedBy: .newlines)
    .map { (line) -> (low: Int, high: Int) in
        let parts = line.components(separatedBy: "-")
        return (Int(parts[0])!, Int(parts[1])!)
    }
    .sorted { $0.low < $1.low }

measure {
    
    // Part One
    
    var low = 0
    for range in ranges {
        
        if range.low > low+1 {
            print ("1) \(low + 1)");
            break
        }
        else {
            low = max(low, range.high)
        }
    }
}

measure {
    var low = 0
    var high = 4294967295
    
    var sum = 0
    for (idx, range) in ranges.enumerated() {

        if range.low > low+1 {
            sum += range.low - (low+1)
        }
        low = max(low, range.high)
    }
    // add difference between high and high of highest range
    let highest = ranges.sorted { $0.high > $1.high}.first!
    sum += high - highest.high
    
    print ("2) \(sum)")
}
