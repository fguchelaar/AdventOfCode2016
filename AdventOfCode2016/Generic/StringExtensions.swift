import Foundation

extension String {
    
    /*
     Returns a dictionary with all Characters of the string as keys and the number of
     occurences of that Character as value
     */
    public func characterMap() -> [Character : Int] {
        let characterMap = self.characters.reduce([Character : Int](), { (result, character) -> [Character : Int] in
            var newDict = result
            newDict[character] = (newDict[character] ?? 0) + 1
            return newDict
        })
        return characterMap
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy:r.lowerBound)
        let end = self.index(startIndex, offsetBy:r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}

extension String {
    
    public func rangeFromNSRange(aRange: NSRange) -> Range<String.Index> {
        let s = self.index(startIndex, offsetBy: aRange.location)
        let e = self.index(startIndex, offsetBy: aRange.location + aRange.length)
        return s..<e
    }
}
