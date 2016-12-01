/*:
 # Advent of Code 2016 - [Day 1](http://adventofcode.com/2016/day/1)

 Not a very efficient way of doing things, but I wanted to try out the functions within an `Enum`.
 Perhaps some sort of `reduce` function might help.
 
 */
import Foundation

enum Direction : Int {
    case north = 0
    case east
    case south
    case west
    
    func turnLeft() -> Direction {
        return Direction(rawValue: (self.rawValue - 1 + 4) % 4)!
    }
    
    func turnRight() -> Direction {
        return Direction(rawValue: (self.rawValue + 1) % 4)!
    }
}

struct Location {
    var x : Int
    var y : Int
}

var direction : Direction = .north
var location = Location(x: 0, y: 0)
var visitedLocations = [location]

var location2 : Location?

var input = try String.init(contentsOf: #fileLiteral(resourceName: "input1a.txt"))

var instructions = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ", ")

for var instruction in instructions {
    let index = instruction.index(after: instruction.startIndex)
    let rotate = instruction.substring(to: index)
    let steps = Int(instruction.substring(from: index))!
    
    if rotate.localizedCaseInsensitiveCompare("R") == .orderedSame {
        direction = direction.turnRight()
    }
    else {
        direction = direction.turnLeft()
    }
    
    for _ in 0..<steps {
        
        switch direction {
        case .north:
            location = Location(x: location.x, y: location.y + 1)
        case .east:
            location = Location(x: location.x + 1, y: location.y)
        case .south:
            location = Location(x: location.x, y: location.y - 1)
        case .west:
            location = Location(x: location.x - 1, y: location.y)
        }
        
        if location2 == nil && visitedLocations.contains(where: { (visitedLocation) -> Bool in
            return visitedLocation.x == location.x && visitedLocation.y == location.y
        }) {
            location2 = location
        }
        visitedLocations.append(location)
    }
}

//: Part One
print ("After following \(instructions.count) instructions, we arrive at \(location)")
let distance1 = abs(location.x) + abs(location.y)
print ("The Easter Bunny HQ is \(distance1) blocks away.")

//: Part Two
if let actualLocation = location2 {
    print ("The first location visited twice, is \(actualLocation)")
    let distance2 = abs(actualLocation.x) + abs(actualLocation.y)
    print ("Which is \(distance2) blocks away.")
}

//: [Previous](@previous) - [Next](@next)
