//
//  main.swift
//  AdventOfCode2016
//
//  Created by Frank Guchelaar on 05/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation


let input = "abbhdwsy"

//let range = 7777889...Int.max
let range = [1739529,
             1910966,
             1997199,
             2854555,
             2963716,
             3237361,
             4063427,
             7777889,
             8460345,
             9417946,
             12389322,
             12434824,
             12850790,
             12942170,
             12991290,
             13256331,
             14024976,
             15299586,
             17786793,
             17931630,
             19357601,
             19359925,
             19808330,
             20214395,
             22339420,
             23135423,
             24055333,
             24538150,
             25056365,
             25651067,
             25858460,
             25943617]

for salt in range {
    if let hash = input.appending("\(salt)").md5() {
        
        let hex = hash.hexString()
        if hex.hasPrefix("00000") {
            let key = hex.characters[hex.index(hex.startIndex, offsetBy: 5)]
            
            print ("PART ONE >> [\(salt)] - \(hex) \(key)")
            
            if let keyAsInt = Int("\(key)") {
                
                if keyAsInt < 8 {
                    let key2 = hex.characters[hex.index(hex.startIndex, offsetBy: 6)]
                    
                    print ("PART TWO >> [\(salt)] - \(hex) \(key) \(key2)")
                }
            }
        }
    }
}
