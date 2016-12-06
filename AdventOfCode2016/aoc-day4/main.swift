//
//  main.swift
//  aoc-day4
//
//  Created by Frank Guchelaar on 06/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day4/input.txt")

var roomStrings = input
    .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    .components(separatedBy: CharacterSet.newlines)


extension String {
    
    func rollCharacters(by: Int) -> String {
        return self.unicodeScalars.reduce("", { (result, scalar) in
            
            // a == 97
            let newScalar = (((scalar.value + UInt32(by)) - 97) % 26) + 97
            return result + String(Character(UnicodeScalar(newScalar)!))
        })
    }
}

struct Room {
    
    var encryptedName : [String]
    let sectorId : Int
    let checksum : String
    
    init(withString string: String) {
        
        let charactersRegex = try! NSRegularExpression(pattern: "[a-z]+", options: .caseInsensitive)
        let matches = charactersRegex.matches(in: string, options: .reportCompletion, range: NSMakeRange(0, string.characters.count))
        
        self.encryptedName = matches.map({ (result) -> String in
            
            let range = string.rangeFromNSRange(aRange: result.range)
            let part = string.substring(with: range)
            return part
        })
        checksum = self.encryptedName.removeLast()
        
        let digitsRegex = try! NSRegularExpression(pattern: "\\d+", options: .caseInsensitive)
        let match = digitsRegex.firstMatch(in: string, options: .reportCompletion, range: NSMakeRange(0, string.characters.count))
        sectorId = Int(string.substring(with: string.rangeFromNSRange(aRange: match!.range)))!
    }
    
    func name() -> String {
        return self.encryptedName.map { $0.rollCharacters(by: self.sectorId) }.joined(separator: " ")
    }
    
    private func calculateChecksum() -> String {
        
        let characterMap = encryptedName.joined().characterMap()
        
        let sorted = characterMap.sorted {a,b in
            return (a.value > b.value) || (a.value == b.value && a.key < b.key)
        }
        
        var  cs = ""
        
        for idx in 0..<5 {
            cs.append(sorted[idx].0)
        }
        return cs
    }
    
    func isReal() -> Bool {
        let calculated = self.calculateChecksum()
        return checksum.localizedCaseInsensitiveCompare(calculated) == .orderedSame
    }
}


let rooms = roomStrings.map { (roomString) -> Room in
    return Room(withString: roomString)
}

//: ## Part One
let realRooms = rooms.reduce(0, { (result, room) in
    
    if room.isReal() {
        return result + room.sectorId
    }
    else {
        return result
    }
    
})
print (realRooms)

//: ## Part Two
//: I've checked the results to find the proper room name...
let room = rooms.first { (room) -> Bool in
    return room.name().localizedCaseInsensitiveCompare("northpole object storage") == .orderedSame
}
print (room!.sectorId)
