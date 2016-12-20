//
//  main.swift
//  aoc-day19
//
//  Created by Frank Guchelaar on 19/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

let input = 3012210


// Part One
var array = [Int](repeatElement(1, count: input))

func nextIndex(from start: Int) -> Int? {
    
    var candidate = (start + 1) % array.count
    for _ in 0..<array.count-1 {
        if array[candidate] != 0 {
            return candidate
        }
        candidate = (candidate + 1) % array.count
    }
    return nil
}

measure {
    
    if var index = nextIndex(from: -1) {
        while true {
            if let next = nextIndex(from: index) {
                array[index] += array[next]
                array[next] = 0
            }
            
            if let nextNext = nextIndex(from: index) {
                index = nextNext
            }
            else {
                print ("1) Elf #\(index+1) has al the presents (\(array[index])]")
                break
            }
        }
    }
}

// Part Two

var circle = [Int]()
for i in 0..<input {
    circle.append(i+1)
}

func accrossTable(from start: Int) -> Int? {
    
    if (circle.count > 1) {
        return (start + (circle.count/2)) % circle.count
    }
    return nil
}

measure {
    
    var index = 0
    
    while true {
        
        if circle.count % 10000 == 0 {
            print ("\(Date()) - \(circle.count)")
        }
        
        if let accross = accrossTable(from: index) {
            circle.remove(at: accross)
            circle.append(circle.removeFirst())
        }
        else {
            print ("2) Elf #\(circle[0]) has all the presents")
            break
        }
    }
}
