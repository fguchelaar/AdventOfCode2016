//
//  main.swift
//  aoc-day13
//
//  Created by Frank Guchelaar on 13/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

struct Location : Equatable, Hashable {
    var x : Int
    var y : Int
    
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    var hashValue: Int {
        return "\(x)x\(y)".hashValue
    }
}

extension Location {
    func up() -> Location {
        return Location(x: self.x, y: self.y - 1)
    }
    func down() -> Location {
        return Location(x: self.x, y: self.y + 1)
    }
    func left() -> Location {
        return Location(x: self.x - 1, y: self.y)
    }
    func right() -> Location {
        return Location(x: self.x + 1, y: self.y)
    }
}

extension Location {
    
    func isWall() -> Bool {
        
        // Find x*x + 3*x + 2*x*y + y + y*y.
        let multiplied = (self.x*self.x) + (3*self.x) + (2*self.x*self.y) + self.y + (self.y*self.y)
        
        // Add the office designer's favorite number
        let sum = multiplied + input
        
        // Find the binary representation of that sum; count the number of bits that are 1.
        //    If the number of bits that are 1 is even, it's an open space.
        //    If the number of bits that are 1 is odd, it's a wall.
        
        // can probably be a lot more efficient, by not converting to String, but simply a bit array
        // or likewise
        
        let asBitString = String(sum, radix: 2)
        let count1s = asBitString.characters.reduce(0) { (result, character) -> Int in
            return result + (Int(String(character)) ?? 0)
        }
        return count1s % 2 == 1
    }
}

extension Location {
    func withinBounds() -> Bool {
        return self.x >= 0 && self.y >= 0
    }
}

// I'm using Dijkstra's algorithm to calculate the shortest path, escaping when we're at the target location, or scipping new locations if we've reached a max distance. Since the grid is potentially infinite, I'm building op the Unvisited set as we traverse the maze
func Dijkstra(source: Location, target: Location?, maxDistance: Int) -> [Location : Int] {
    
    func neighborsOf(location: Location) -> [Location] {
        return [ location.up(), location.down(), location.left(), location.right()]
            .filter { $0.withinBounds() && !$0.isWall() }
    }
    
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
        
        if current == target {
            break
        }
        
        visited.insert(unvisited.remove(current)!)
        
        if distance[current]! == maxDistance {
            continue
        }
        
        for neighbor in neighborsOf(location: current) {
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
        
        // uncomment to animate
        //        displayDistanceGrid(distance: distance)
        //        usleep(50000)
    }
    
    return distance
}

func displayDistanceGrid(distance: [Location : Int]) {
    let width = distance.keys.reduce(0) { (result, location) -> Int in
        return max (result, location.x)
    }
    let height = distance.keys.reduce(0) { (result, location) -> Int in
        return max (result, location.y)
    }
    
    var grid = ""
    for row in 0...height+1 {
        for col in 0...width+1 {
            let loc = Location(x: col, y: row)
            
            if loc.isWall() {
                grid.append("◦◦ ")
            }
            else if let dist = distance[loc] {
                grid.append(String.init(format: "%02d ", dist))
            }
            else {
                grid.append("   ")
            }
        }
        grid.append("\n")
    }
    print (grid.trimmingCharacters(in: .newlines))
}


let input = 1358

// Part One
let target = Location(x: 31, y: 39)
var distance1 = [Location : Int]()
measure {
    distance1 = Dijkstra(source: Location(x: 1, y: 1), target: target, maxDistance: Int.max)
}
displayDistanceGrid(distance: distance1)
print ("Arrived at \(target), after \(distance1[target]!) steps\n")

// Part Two
let maxDistance = 50
var distance2 = [Location : Int]()
measure {
    distance2 = Dijkstra(source: Location(x: 1, y: 1), target: nil, maxDistance: maxDistance)
}
displayDistanceGrid(distance: distance2)
print ("Found \(distance2.count) locations with max \(maxDistance) steps")

