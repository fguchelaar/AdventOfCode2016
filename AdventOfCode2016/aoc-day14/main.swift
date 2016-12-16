//
//  main.swift
//  aoc-day14
//
//  Created by Frank Guchelaar on 14/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

extension String {
    
    func tripletCharacter() -> Character? {
        let lastIndex = self.index(self.endIndex, offsetBy: -2)
        for index in self.characters.indices {
            if index == lastIndex {
                break
            }
            if self.characters[index] == self.characters[self.index(index, offsetBy: 1)]
                && self.characters[index] == self.characters[self.index(index, offsetBy: 2)] {
                return characters[index]
            }
        }
        return nil
    }
}

struct Candidate {
    let index : Int
    let character : Character
    let hash : String
}

var hashDict = [Int : String]()

func hashFor(index: Int, or string: String, stretched stretchCount: Int) -> String {
    
    if let hash = hashDict[index] {
        return hash
    }
    else {
        var hash = string.md5_2()
        autoreleasepool {
            for _ in 0..<stretchCount {
                hash = hash.md5_2()
            }
        }
        hashDict[index] = hash
        return hash
    }
}

func findKeys(base: String, numberOfKeys: Int, stretchCount: Int) -> [Candidate] {
    var keys = [Candidate]()
    for salt in 0..<Int.max {
        let hash = hashFor(index: salt, or: "\(base)\(salt)", stretched: stretchCount)
        if let character = hash.tripletCharacter() {
            //            print ("\(salt): FOUND \(character) in \(hash)")
            let quintuple = String([Character](repeatElement(character, count: 5)))
            for i in 1...1000 {
                let checkHash = hashFor(index: salt+i, or: "\(base)\(salt+i)", stretched: stretchCount)
                
                if checkHash.contains(quintuple) {
                    let candidate = Candidate(index: salt, character: character, hash: hash)
                    keys.append(candidate)
                    if keys.count == numberOfKeys {
                        return keys
                    }
                    break
                }
            }
        }
    }
    return keys
}

let input = "ngcjuoqr"

// Part One
measure {
    for (index, candidate) in findKeys(base: input, numberOfKeys: 64, stretchCount: 0).sorted(by: { $0.index < $1.index }).enumerated() {
        print (String.init(format: "%02d [%@] %@", candidate.index, String(candidate.character), candidate.hash))
    }
}

// Part Two
hashDict.removeAll()
measure {
    for (index, candidate) in findKeys(base: input, numberOfKeys: 64, stretchCount: 2016).sorted(by: { $0.index < $1.index }).enumerated() {
        print (String.init(format: "%02d [%@] %@", candidate.index, String(candidate.character), candidate.hash))
    }
}
