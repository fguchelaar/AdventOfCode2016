//
//  main.swift
//  aoc-day12
//
//  Created by Frank Guchelaar on 12/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day12/input.txt")
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
    
    func solve() {
        var i = 0
        while i < instructions.count {
            
            let components = instructions[i].components(separatedBy: " ")
            
            if instructions[i].hasPrefix("cpy") {
                if let value = Int(components[1]) {
                    computer.copy(value: value, in: components[2])
                }
                else {
                    let value = computer.registers[components[1]]!
                    computer.copy(value: value, in: components[2])
                }
            }
            else if instructions[i].hasPrefix("jnz") {
                
                let value = Int(components[1]) ?? computer.registers[components[1]]
                if (value != 0) {
                    let jump = Int(components[2])!
                    i += jump
                    continue
                }
            }
            else if instructions[i].hasPrefix("inc") {
                computer.increment(register: components[1])
            }
            else if instructions[i].hasPrefix("dec") {
                computer.decrement(register: components[1])
            }
            else {
                fatalError("illegal instruction: \(input[i])")
            }
            i += 1
        }
    }
}

// Part One
let computer1 = Computer(a: 0, b: 0, c: 0, d: 0)
Solver(computer: computer1, instructions: input).solve()
print (computer1.registers.sorted { $0.key < $1.key} )

// Part One
let computer2 = Computer(a: 0, b: 0, c: 1, d: 0)
Solver(computer: computer2, instructions: input).solve()
print (computer2.registers.sorted { $0.key < $1.key} )
