//
//  main.swift
//  aoc-day14
//
//  Created by Frank Guchelaar on 14/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

extension String {
    
    func firstCharacter(timesOccuring times: Int) -> Character? {
        
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

func findKeys(base: String, numberOfKeys: Int, stretchCount: Int) -> [Candidate] {
    
    var candidates = [Candidate]()
    var keys = [Candidate]()
    
   for salt in 0..<Int.max {
        
        var hash = ""
        autoreleasepool {
            
            hash = "\(base)\(salt)".md5_2()
            for _ in 0..<stretchCount {
                hash = hash.md5_2().lowercased()
            }
        }
        
        // 1. purge 'old' candidates and candidates already marked as one-time pad
        candidates = candidates
            .filter({ candidate -> Bool in
                return salt - candidate.index <= 1000 && !keys.contains{ $0.index == candidate.index }
            })
        
        // 2. search for one-time pads in candidates
        for candidate in candidates {
            
            // TODO: find nice way to generate the string of 5 repeating characters 
            if hash.contains("\(candidate.character)\(candidate.character)\(candidate.character)\(candidate.character)\(candidate.character)") {
                keys.append(candidate)
                print (String.init(format: "%02d [%@] %@", candidate.index, String(candidate.character), candidate.hash))
                if keys.count == numberOfKeys {
                    return keys
                }
            }
        }
        
        if let character = hash.firstCharacter(timesOccuring: 3) {
            candidates.append(Candidate(index: salt, character: character, hash: hash))
        }
    }
    return keys
}

let input = "ngcjuoqr"
//let input = "abc"

// Part One
//measure {
//    for (index, candidate) in findKeys(base: input, numberOfKeys: 64, stretchCount: 0).sorted(by: { $0.index < $1.index }).enumerated() {
//        print (String.init(format: "%02d [%@] %@", candidate.index, String(candidate.character), candidate.hash))
//    }
//}


// Part Two
measure {
    for (index, candidate) in findKeys(base: input, numberOfKeys: 80, stretchCount: 2016).sorted(by: { $0.index < $1.index }).enumerated() {
        print (String.init(format: "%02d [%@] %@", candidate.index, String(candidate.character), candidate.hash))
    }
}

// #1: 20219 x
// #2: 20199 x
// #3: 20092 √
