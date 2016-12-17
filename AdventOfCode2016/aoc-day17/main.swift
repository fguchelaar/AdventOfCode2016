//
//  main.swift
//  aoc-day17
//
//  Created by Frank Guchelaar on 17/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

struct Location : Equatable, Hashable {
    var x : Int
    var y : Int
    var path : String
    
    func neighborsUsing(passcode: String) -> [Location] {
        
        return autoreleasepool { () -> [Location] in
            let hash = (passcode + path).md5_2()[0..<4]
            
            var neighbors = [Location]()
            
            var index = hash.startIndex
            if isValidDirection(character: hash.characters[index]) {
                if up().withinBounds() {
                    neighbors.append(up())
                }
            }
            index = hash.index(after: index)
            if isValidDirection(character: hash.characters[index]) {
                if down().withinBounds() {
                    neighbors.append(down())
                }
            }
            index = hash.index(after: index)
            if isValidDirection(character: hash.characters[index]) {
                if left().withinBounds() {
                    neighbors.append(left())
                }
            }
            index = hash.index(after: index)
            if isValidDirection(character: hash.characters[index]) {
                if right().withinBounds() {
                    neighbors.append(right())
                }
            }
            return neighbors
        }
    }
    
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.path == rhs.path
    }
    
    var hashValue: Int {
        return "\(x)x\(y)_\(path)".hashValue
    }
}

extension Location {
    func up() -> Location {
        return Location(x: self.x, y: self.y - 1, path: self.path+"U")
    }
    func down() -> Location {
        return Location(x: self.x, y: self.y + 1, path: self.path+"D")
    }
    func left() -> Location {
        return Location(x: self.x - 1, y: self.y, path: self.path+"L")
    }
    func right() -> Location {
        return Location(x: self.x + 1, y: self.y, path: self.path+"R")
    }
}

extension Location {
    
    func isValidDirection(character: Character) -> Bool {
        
        return (Int(String(character), radix: 16))! > 10
    }
}

extension Location {
    func withinBounds() -> Bool {
        return self.x >= 0 && self.y >= 0 && self.x < 4 && self.y < 4
    }
}

// Reusing the algorithm of day 14, with some adjustments
func Dijkstra(source: Location, target: Location, passcode: String, breakOnTarget: Bool) -> [Location : Int] {
    
    var distance = [Location: Int]()
    var previous = [Location: Location]()
    var unvisited = Set<Location>()
    var visited = Set<Location>()
    
    distance[source] = 0
    unvisited.insert(source)
    
    while !unvisited.isEmpty {
        
        let current = distance
            .filter { unvisited.contains($0.key) }
            .sorted { $0.value < $1.value }
            .first!.key
        
        visited.insert(unvisited.remove(current)!)
        
        if current.x == target.x && current.y == target.y {
            if breakOnTarget {
                break
            }
            else {
                continue
            }
        }
        
        
        for neighbor in current.neighborsUsing(passcode: passcode) {
            if !visited.contains(neighbor) {
                unvisited.insert(neighbor) // unvisited is a set, so no harm is done here by adding a location twice
            }
            let currentDistance = distance[current]!
            
            if let neighborDistance = distance[neighbor] {
                if currentDistance + 1 < neighborDistance {
                    distance[neighbor] = currentDistance + 1
                    previous[neighbor] = current
                }
            }
            else {
                distance[neighbor] = currentDistance + 1
                previous[neighbor] = current
            }
            
        }
    }
    return distance
}

// Part One
let target = Location(x: 3, y: 3, path: "XX")
var distance1 = [Location : Int]()
measure {
    distance1 = Dijkstra(source: Location(x: 0, y: 0, path: ""), target: target, passcode: "pxxbnzuo", breakOnTarget: true)
}
print (distance1.filter { $0.key.x == target.x && $0.key.y == target.y }
    .sorted { $0.value > $1.value }.first)

// Part Two
var distance2 = [Location : Int]()
measure {
    distance2 = Dijkstra(source: Location(x: 0, y: 0, path: ""), target: target, passcode: "pxxbnzuo", breakOnTarget: false)
}

print (distance2.filter { $0.key.x == target.x && $0.key.y == target.y }
    .sorted { $0.value > $1.value }.first)
