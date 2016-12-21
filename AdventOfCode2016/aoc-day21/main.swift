//
//  main.swift
//  aoc-day21
//
//  Created by Frank Guchelaar on 21/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day21/input.txt").trimmingCharacters(in: .whitespacesAndNewlines)

extension String {
    func swap(_ position: Int, with: Int) -> String {
        var chars = self.characters.map{ $0 }
        let tmp = chars[position]
        chars[position] = chars[with]
        chars[with] = tmp
        return String(chars)
    }
}

extension String {
    func swap(_ x: String, with y: String) ->String {
        var swapped = self.replacingOccurrences(of: x, with: "_")
        swapped = swapped.replacingOccurrences(of: y, with: x)
        return swapped.replacingOccurrences(of: "_", with: y)
    }
}

extension String {
    func reverse(_ from: Int, through: Int) -> String {
        let start = self.index(startIndex, offsetBy: from)
        let end = self.index(startIndex, offsetBy: through+1)
        let range = Range(uncheckedBounds: (start, end))
        let toReverse = self.substring(with: range)
        let reversed = String(toReverse.characters.reversed())
        return self.replacingCharacters(in: range, with: reversed)
    }
}

extension String {
    func rotate(by positions: Int) -> String {
        let chars = self.characters.map{ $0 }
        var rotated = chars
        for i in 0..<chars.count {
            rotated[i] = chars[(i + (positions % chars.count) + chars.count) % chars.count]
        }
        return String(rotated)
    }
    
    func rotateLeft(by positions: Int) -> String {
        return rotate(by: positions)
    }
    func rotateRight(by positions: Int) -> String {
        return rotate(by: -positions)
    }
}

extension String {
    func move(_ position: Int, to: Int) -> String {
        var string = self
        let char = string.remove(at: string.index(string.startIndex, offsetBy: position))
        string.insert(char, at: string.index(string.startIndex, offsetBy: to))
        return string
    }
}

extension String {
    func rotate(basedOn: String) -> String {
        let indexOfString = self.range(of: basedOn)
        var rotate = self.distance(from: startIndex, to: indexOfString!.lowerBound)
        rotate += rotate >= 4 ? 2 : 1
        return rotateRight(by: rotate)
    }
    func rotate2(basedOn: String) -> String {
        let indexOfString = self.range(of: basedOn)
        var rotate = self.distance(from: startIndex, to: indexOfString!.lowerBound)
        rotate += rotate >= 4 ? 2 : 1
        return rotateRight(by: rotate)
    }
}

func applyProcess(instructions: [String], on string: String) -> String {
    
    var password = string
    for instruction in instructions {
        
        let parts = instruction.components(separatedBy: .whitespaces)
        
        if instruction.hasPrefix("rotate left") {
            password = password.rotateLeft(by: Int(parts[2])!)
        }
        else if instruction.hasPrefix("rotate right") {
            password = password.rotateRight(by: Int(parts[2])!)
        }
        else if instruction.hasPrefix("rotate based") {
            password = password.rotate(basedOn: parts[6])
        }
        else if instruction.hasPrefix("swap letter") {
            password = password.swap(parts[2], with: parts[5])
        }
        else if instruction.hasPrefix("swap position") {
            password = password.swap(Int(parts[2])!, with: Int(parts[5])!)
        }
        else if instruction.hasPrefix("reverse positions") {
            password = password.reverse(Int(parts[2])!, through: Int(parts[4])!)
        }
        else if instruction.hasPrefix("move position") {
            password = password.move(Int(parts[2])!, to: Int(parts[5])!)
        }
    }
    return password
}

// Part One
measure {
    let password = applyProcess(instructions: input.components(separatedBy: .newlines), on: "abcdefgh")
    print ("1) \(password)")
}


// Part Two
let scrambled = "fbgdceah"

extension String {
    func permutations() -> [String] {
        var array = Array(self.characters)
        return permutations(array.count, &array)
    }
    
    private func permutations(_ n:Int, _ a:inout Array<Character>) -> [String] {
        var p = [String]()
        if n == 1 {
            p.append(String(a))
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
}

measure {
    
    let instructions = input.components(separatedBy: .newlines)
    for permutation in scrambled.permutations() {
        let password = applyProcess(instructions: instructions, on: permutation)
        
        if password == scrambled {
            print ("2) \(permutation)")
        }
    }
}
