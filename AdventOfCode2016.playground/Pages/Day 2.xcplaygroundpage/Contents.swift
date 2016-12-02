/*:
 # Advent of Code 2016 - [Day 2](http://adventofcode.com/2016/day/2)
 
 Decided to create a matrix of `String`s, where an empty string is an illegal position.
 
 */

import Foundation

struct Position {
    var x : Int
    var y : Int
}

func followInstructions(instructionSets: [String], forKeypad keypad: [[String]], startingAt startPosition: Position) -> String {
    
    var code = ""
    var currentPosition = startPosition
    
    for instructionSet in instructionSets {
        
        for instruction in instructionSet.uppercased().characters {
            
            var newPosition = currentPosition
            switch instruction {
            case "U":
                newPosition.y = max(0, newPosition.y-1)
            case "D":
                newPosition.y = min(keypad.count-1, newPosition.y+1)
            case "L":
                newPosition.x = max(0, newPosition.x - 1)
            case "R":
                newPosition.x = min(keypad[currentPosition.y].count-1, newPosition.x + 1)
            default:
                print("Illegal instruction: \(instruction)")
            }
            
            // is there a value at the new position?
            if !keypad[newPosition.y][newPosition.x].isEmpty {
                currentPosition = newPosition
            }
        }
        
        let key = keypad[currentPosition.y][currentPosition.x]
        code.append(key)
    }
    
    return code
}


var input = try String.init(contentsOf: #fileLiteral(resourceName: "input.txt"))

let sets = input.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: CharacterSet.newlines)

//: ## Part One
let keypadPartOne = [
    
    [ "1" , "2" , "3" ],
    [ "4" , "5" , "6" ],
    [ "7" , "8" , "9" ]
    
]

print (followInstructions(instructionSets: sets, forKeypad: keypadPartOne, startingAt: Position(x: 1, y: 1)))

//: ## Part Two
let keypadPartTwo = [
    
    [ ""  , ""  , "1" , ""  , "" ],
    [ ""  , "2" , "3" , "4" , "" ],
    [ "5" , "6" , "7" , "8" , "9"],
    [ ""  , "A" , "B" , "C" , "" ],
    [ ""  , ""  , "D" , ""  , "" ]
    
]

print (followInstructions(instructionSets: sets, forKeypad: keypadPartTwo, startingAt: Position(x: 0, y: 2)))
