//
//  main.swift
//  aoc-day7
//
//  Created by Frank Guchelaar on 06/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

var input = try String(contentsOfFile: "day7/input.txt")
var ipAddress = input
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)

// The regex to capture both the ABBA and HYPERNET: (?<ABBA>\w+)(\[(?<HYPERNET>\w+)\])?
// It kinda s*cks, that Capture Groups are not supported. We can however map every even match to ABBA and the uneven ones to HYPERNET
extension String {
    func containsABBA() -> Bool {
        if self.characters.count < 4{
            return false
        }
        
        let lastIndex = self.index(self.endIndex, offsetBy: -3)
        for index in self.characters.indices {
            if index == lastIndex {
                break
            }
            
            if self.characters[index] != self.characters[self.index(index, offsetBy: 1)]
                && self.characters[index] == self.characters[self.index(index, offsetBy: 3)]
                && self.characters[self.index(index, offsetBy: 1)] == self.characters[self.index(index, offsetBy: 2)]{
                return true
            }
            
        }
        
        return false
    }
    
    func abas() -> [String]? {
        if self.characters.count < 3 {
            return nil
        }
        let lastIndex = self.index(self.endIndex, offsetBy: -2)
        
        var abas = [String]()
        for index in self.characters.indices {
            if index == lastIndex {
                break
            }
            
            if self.characters[index] != self.characters[self.index(index, offsetBy: 1)]
                && self.characters[index] == self.characters[self.index(index, offsetBy: 2)] {
                abas.append(String([self.characters[index], self.characters[self.index(index, offsetBy: 1)], self.characters[index]]))
            }
        }
        return abas.isEmpty ? nil : abas
    }
    
    func toBAB() -> String {
        let a = self.characters[self.startIndex]
        let b = self.characters[self.index(self.startIndex, offsetBy: 1)]
        return String([b,a,b])
    }
}

let pattern = "(?<SUPERNET>\\w+)([(?<HYPERNET>\\w+)])?"
let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)

var supportsTLS = [String]()
var supportsSSL = Set<String>()
for address in ipAddress {
    
    let matches = regex.matches(in: address, options: .reportCompletion, range: NSMakeRange(0, address.characters.count))
    var supernets = [String]()
    var hypernets = [String]()
    
    for (index, match) in matches.enumerated() {
        if index % 2 == 0 {
            supernets.append(address.substring(with: address.rangeFromNSRange(aRange: match.range)))
        }
        else {
            hypernets.append(address.substring(with: address.rangeFromNSRange(aRange: match.range)))
        }
    }
    
    // part one
    let supernetWithABBA = supernets.reduce(false, { (result, supernet) -> Bool in
        return result || supernet.containsABBA()
    })
    
    let hypernetWithABBA = hypernets.reduce(false, { (result, hypernet) -> Bool in
        return result || hypernet.containsABBA()
    })
    
    if supernetWithABBA && !hypernetWithABBA {
        supportsTLS.append(address)
    }
    
    // part two
    for supernet in supernets {
        if let abas = supernet.abas() {
            for aba in abas {
                for hypernet in hypernets {
                    if hypernet.contains(aba.toBAB()) {
                        supportsSSL.insert(address)
                    }
                }
            }
        }
    }
}

// Part One
print ("\(supportsTLS.count) out of \(ipAddress.count) support TLS")

// Part One
print ("\(supportsSSL.count) out of \(ipAddress.count) support SSL")
