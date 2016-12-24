//
//  main.swift
//  aoc-day24
//
//  Created by Frank Guchelaar on 24/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day24/input.txt")
    .trimmingCharacters(in: .whitespacesAndNewlines)

enum LocationType {
    case wall
    case open
    case waypoint
}

struct Location : Equatable, Hashable {
    let x: Int
    let y: Int
    let type: LocationType
    
    let id: Int?
    
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    var hashValue: Int {
        return (x * 1000 + y).hashValue
    }
}

extension Location {
    func up(in grid:[[Location]]) -> Location {
        return grid[self.y-1][self.x]
    }
    func down(in grid:[[Location]]) -> Location {
        return grid[self.y+1][self.x]
    }
    func left(in grid:[[Location]]) -> Location {
        return grid[self.y][self.x-1]
    }
    func right(in grid:[[Location]]) -> Location {
        return grid[self.y][self.x+1]
    }
}

func parseInput() -> [[Location]] {
    var grid = [[Location]]()
    for (rowIndex, row) in input.components(separatedBy: .newlines).enumerated() {
        var gridRow = [Location]()
        for (colIndex, col) in row.characters.enumerated() {
            switch col {
            case "#":
                gridRow.append(Location(x: colIndex, y: rowIndex, type: .wall, id: nil))
            case ".":
                gridRow.append(Location(x: colIndex, y: rowIndex, type: .open, id: nil))
            default:
                gridRow.append(Location(x: colIndex, y: rowIndex, type: .waypoint, id: Int(String(col))))
            }
        }
        grid.append(gridRow)
    }
    return grid
}

func displayGrid(grid: [[Location]], distance: [Location: Int]) {
    
    var output = ""
    for row in 0..<grid.count {
        for col in 0..<grid[row].count {
            let location = grid[row][col]
            switch location.type {
            case .wall:
                output.append("⏹")
            case .open:
                if let _ = distance[location] {
                    output.append("🚶🏽")
                }
                else {
                    output.append("◽️")
                }
            case .waypoint:
                output.append("🅰️")
                // output.append(String(location.id!))
            }
        }
        output.append("\n")
    }
    print (output.trimmingCharacters(in: .newlines))
}


// I'm using Dijkstra's algorithm to calculate the shortest path, escaping when we're at the target location, or scipping new locations if we've reached a max distance. Since the grid is potentially infinite, I'm building op the Unvisited set as we traverse the maze
func Dijkstra(grid: [[Location]], source: Location, targets: [Location]) -> [Location : Int] {
    
    func neighborsOf(location: Location) -> [Location] {
        return [ location.up(in: grid), location.down(in: grid), location.left(in: grid), location.right(in: grid)]
            .filter { !($0.type == .wall) }
    }
    
    var distance = [Location: Int]()
    var previous = [Location: Location]()
    var unvisited = Set<Location>()
    var visited = Set<Location>()
    
    var targetWaypoints = targets
    
    distance[source] = 0
    unvisited.insert(source)
    
    while !unvisited.isEmpty {
        let current = distance
            .filter { unvisited.contains($0.key) }
            .sorted { $0.value < $1.value }
            .first!.key
        
        if let wp = targetWaypoints.index(of: current) {
            print ("Distance from \(source.id!) to \(current.id!): \(distance[current]!)")
            targetWaypoints.remove(at: wp)
            if targetWaypoints.isEmpty {
                break
            }
        }
        
        visited.insert(unvisited.remove(current)!)
        
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
    }
    
    return distance
}


func permutations(array: [Location]) -> [[Location]] {
    var arr = array
    return permutations(arr.count, &arr)
}

private func permutations(_ n:Int, _ a:inout Array<Location>) -> [[Location]] {
    var p = [[Location]]()
    if n == 1 {
        p.append(a)
    }
    else {
        for i in 0..<n-1 {
            p.append(contentsOf: permutations(n-1,&a))
            Swift.swap(&a[n-1], &a[(n%2 == 1) ? 0 : i])
        }
        p.append(contentsOf: permutations(n-1,&a))
    }
    return p
}

let grid = parseInput()
let waypoints = grid.flatMap { $0 }.filter { $0.type == .waypoint }.sorted { $0.id! < $1.id! }

measure {
    var distances = [Location: [Location: Int]]()
    
    for wp in waypoints {
        distances[wp] = [Location: Int]()
    }
    
    for (sourceIndex, source) in Array(waypoints[0..<waypoints.count-1]).enumerated() {
        let targets = Array(waypoints[sourceIndex+1..<waypoints.count])
        let distance = Dijkstra(grid: grid, source: source, targets: targets)
        
        for target in targets {
            // add both ways, for convienence
            distances[source]![target] = distance[target]!
            distances[target]![source] = distance[target]!
        }
    }
    
    var minPath = Int.max
    for permutation in permutations(array: Array(waypoints.suffix(from: 1))) {
        
        var previous = waypoints[0]
        var sum = (permutation + [waypoints[0]]).reduce(0, { (result, wp) -> Int in
            let r = result + distances[previous]![wp]!
            previous = wp
            return r
        })
        
        if sum < minPath {
            minPath = sum
            print("Found new shortest path with length \(sum)")
            print(([waypoints[0]] + permutation + [waypoints[0]]).map { "\($0.id!)" }.joined(separator: " -> "))
        }
    }
    
    //    displayGrid(grid: grid, distance: distance)
}

/* Pseudo
 
 for all sorted waypoint {
 use Dijkstra to calculate distance from current to following wp. (nb: a->b == b->a)
 }
 
 for each wp [0] + permutations of [1,2,3,4,5,6,7] {
 sum distances
 }
 
 sum with smallest distance = winner
 
 */

