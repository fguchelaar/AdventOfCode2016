//
//  main.swift
//  aoc-day10
//
//  Created by Frank Guchelaar on 10/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

let lowAlert = 17
let highAlert = 61


class Output : CustomStringConvertible {
    var microchips = [Int]()
    
    var id : Int
    
    init(_ id: Int) {
        self.id = id
    }
    
    var description: String {
        return "\(id): \(microchips.description)"
    }
}

class Bot : CustomStringConvertible{
    
    var lowChip : Int?
    var highChip : Int?
    
    var lowBot : Bot?
    var highBot : Bot?
    
    var lowOutput : Output?
    var highOutput : Output?
    
    var id : Int
    
    init(_ id: Int) {
        self.id = id
    }
    
    func takeMicrochip(chip: Int) {
        
        if lowChip == nil && highChip == nil {
            lowChip = chip
        }
        else if lowChip != nil || highChip != nil {
            let temp = lowChip ?? highChip
            lowChip = min(chip, temp!)
            highChip = max(chip, temp!)
            
            // Part one
            if lowChip == lowAlert && highChip == highAlert {
                print ("ALERT \(id)")
            }

            if let bot = lowBot {
                bot.takeMicrochip(chip: lowChip!)
                lowChip = nil
            }
            else if let output = lowOutput {
                output.microchips.append(min(lowChip!, chip))
                lowChip = nil
            }
            
            if let bot = highBot {
                bot.takeMicrochip(chip: max(highChip!, chip))
                highChip = nil
            }
            else if let output = highOutput {
                output.microchips.append(max(highChip!, chip))
                highChip = nil
            }
            
        }
    }
    
    var description: String {
        return "\(id): \(lowChip ?? 0) <> \(highChip ?? 0)"
    }
    
}

var bots = [Int: Bot]()
func botWithId(id: Int) -> Bot {
    if let bot = bots[id] {
        return bot
    }
    else {
        bots[id] = Bot(id)
        return bots[id]!
    }
}

var outputs = [Int: Output]()
func outputWithId(id: Int) -> Output {
    if let output = outputs[id] {
        return output
    }
    else {
        outputs[id] = Output(id)
        return outputs[id]!
    }
}

var input = try String(contentsOfFile: "day10/input.txt").trimmingCharacters(in: .whitespacesAndNewlines)

var inputs = [(value: Int, toBot: Int)]()


var regex1 = try! NSRegularExpression(pattern: "bot (?<a>\\d+) gives low to (?<b>\\w+) (\\d+) and high to (\\w+) (\\d+)", options: .caseInsensitive)
var regex2 = try! NSRegularExpression(pattern: "value (\\d+) goes to bot (\\d+)", options: .caseInsensitive)

for instruction in input.components(separatedBy: .newlines) {
    
    let matches1 = regex1.matches(in: instruction, options: .reportCompletion, range: NSMakeRange(0, instruction.characters.count))
    if !matches1.isEmpty {
        let botId = Int(instruction.substring(with: instruction.rangeFromNSRange(aRange: matches1[0].rangeAt(1))))!
        let lowToType = instruction.substring(with: instruction.rangeFromNSRange(aRange: matches1[0].rangeAt(2)))
        let lowTo = Int(instruction.substring(with: instruction.rangeFromNSRange(aRange: matches1[0].rangeAt(3))))!
        let highToType = instruction.substring(with: instruction.rangeFromNSRange(aRange: matches1[0].rangeAt(4)))
        let highTo = Int(instruction.substring(with: instruction.rangeFromNSRange(aRange: matches1[0].rangeAt(5))))!
        
        let bot = botWithId(id: botId)
        
        if lowToType.localizedCaseInsensitiveCompare("output") == .orderedSame {
            bot.lowOutput = outputWithId(id: lowTo)
        }
        else {
            bot.lowBot = botWithId(id: lowTo)
        }
        
        if highToType.localizedCaseInsensitiveCompare("output") == .orderedSame {
            bot.highOutput = outputWithId(id: highTo)
        }
        else {
            bot.highBot = botWithId(id: highTo)
        }
        
    }

    let matches2 = regex2.matches(in: instruction, options: .reportCompletion, range: NSMakeRange(0, instruction.characters.count))
    if !matches2.isEmpty {
        let value = Int(instruction.substring(with: instruction.rangeFromNSRange(aRange: matches2[0].rangeAt(1))))!
        let goesToBot = Int(instruction.substring(with: instruction.rangeFromNSRange(aRange: matches2[0].rangeAt(2))))!
        
        inputs.append((value, goesToBot))
    }
}

for input in inputs {
    botWithId(id: input.toBot).takeMicrochip(chip: input.value)
}

// Part two
print (outputWithId(id: 0).microchips.first! * outputWithId(id: 1).microchips.first! * outputWithId(id: 2).microchips.first!)

