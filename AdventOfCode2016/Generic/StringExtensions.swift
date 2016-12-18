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
    
//    subscript (i: Int) -> String {
//        return String(self[i] as Character)
//    }
    
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

extension String {
    
    func md5() -> Data? {
        guard let messageData = self.data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }
    
    func md5_2() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = self.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        return digest.map { String.init(format: "%02x", $0) }.joined()
    }
}
