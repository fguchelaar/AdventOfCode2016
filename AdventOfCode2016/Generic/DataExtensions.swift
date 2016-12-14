//
//  File.swift
//  AdventOfCode2016
//
//  Created by Frank Guchelaar on 14/12/2016.
//  Copyright © 2016 Awesomation. All rights reserved.
//

import Foundation

extension Data {
    func hexString() -> String {
        return self.map { String(format: "%02hhx", $0) }.joined()
    }
}
