/*:
 # Advent of Code 2016 - [Day 4](http://adventofcode.com/2016/day/4)
 
 hacked it together... Sinterklaas weekend, so not enough time (or spirit) to come up with something decent.
 
 */

import Foundation

var input = try String.init(contentsOf: #fileLiteral(resourceName: "input.txt"))

var roomStrings = input
    .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    .components(separatedBy: CharacterSet.newlines)

extension String {
    func rangeFromNSRange(aRange: NSRange) -> Range<String.Index> {
        let s = self.index(startIndex, offsetBy: aRange.location)
        let e = self.index(startIndex, offsetBy: aRange.location + aRange.length)
        return s..<e
    }
}

extension String {
    func characterMap() -> [String : Int] {
        var dict = [String : Int]()
        for c in self.characters {
            let cString = String(c)
            let currentValue = dict[cString] ?? 0
            dict[cString] = currentValue + 1
        }
        return dict
    }
}

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
            
            if (a.value > b.value) {
                return true
            }
            if (a.value == b.value && a.key < b.key) {
                return true
            }
            else {
                return false
            }
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

//: ## Part Two
//: I've checked the results to find the proper room name...
let room = rooms.first { (room) -> Bool in
    return room.name().localizedCaseInsensitiveCompare("northpole object storage") == .orderedSame
}