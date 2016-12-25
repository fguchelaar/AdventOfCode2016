//
//  main.swift
//  aoc-day25
//
//  Created by Frank Guchelaar on 25/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day25/input.txt")
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)

class Computer {
    
    var registers : [String : Int]
    
    init (a: Int, b: Int, c: Int, d: Int) {
        registers = [
            "a": a,
            "b": b,
            "c": c,
            "d": d
        ]
    }
    
    func copy(value: Int, in register: String) {
        registers[register] = value
    }
    
    func copy(from: String, to: String) {
        registers[to]=registers[from]
    }
    
    func decrement(register: String) {
        registers[register] = (registers[register] ?? 0) - 1
    }
    
    func increment(register: String) {
        registers[register] = (registers[register] ?? 0) + 1
    }
}

class Solver {
    var computer: Computer
    var instructions: [String]
    
    init(computer: Computer, instructions: [String]) {
        self.computer = computer
        self.instructions = instructions
    }
    
    var output = [Int]()
    
    func solve() {
        
        var i = 0
        while i < instructions.count {
            autoreleasepool {
                let components = instructions[i].components(separatedBy: " ")
                
                switch components[0] {
                case "tgl":
                    let value = i + (Int(components[1]) ?? computer.registers[components[1]])!
                    
                    if value >= 0 && value < instructions.count {
                        let target = instructions[value]
                        let targetComponents = target.components(separatedBy: " ")
                        
                        if targetComponents[0] == "inc" {
                            instructions[value] = "dec \(targetComponents[1])"
                        }
                        else if targetComponents[0] == "dec" {
                            instructions[value] = "inc \(targetComponents[1])"
                        }
                        else if targetComponents[0] == "tgl" {
                            instructions[value] = "inc \(targetComponents[1])"
                        }
                        else if targetComponents[0] == "jnz" {
                            instructions[value] = "cpy \(targetComponents[1]) \(targetComponents[2])"
                        }
                        else if targetComponents[0] == "cpy" {
                            instructions[value] = "jnz \(targetComponents[1]) \(targetComponents[2])"
                        }
                    }
                case "cpy":
                    if let value = Int(components[1]) {
                        computer.copy(value: value, in: components[2])
                    }
                    else {
                        let value = computer.registers[components[1]]!
                        computer.copy(value: value, in: components[2])
                    }
                case "jnz":
                    let value = Int(components[1]) ?? computer.registers[components[1]]
                    if (value != 0) {
                        let jump = (Int(components[2]) ?? computer.registers[components[2]])!
                        i += jump - 1 // -1 to account for the +1 later on. I'd rather `continue`, but since we're in a `autorelease` block, that's not possible
                    }
                case "inc":
                    computer.increment(register: components[1])
                case "dec":
                    computer.decrement(register: components[1])
                case "out":
                    output.append(computer.registers[components[1]]!)
                default:
                    print ("skipping illegal instruction: \(instructions[i])")
                }
                i += 1
            }
        }
    }
}

// Part One
measure {
    
    // took out: jnz 1 -21, so the loop wil simply stop
    
    for a in 0..<Int.max {
        let computer1 = Computer(a: a, b: 0, c: 0, d: 0)
        let solver = Solver(computer: computer1, instructions: input)
        solver.solve()
        
        var bingo = true
        for (index, i) in solver.output.enumerated() {
            let expected = index % 2
            bingo = bingo && (i == expected)
        }
        if bingo  {
            print (String.init(format: "%05d\t gives %@", a, solver.output.map { "\($0)" }.joined(separator: ",")))
            break
        }
    }
}
