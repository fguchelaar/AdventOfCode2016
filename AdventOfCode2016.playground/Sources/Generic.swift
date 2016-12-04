import Foundation

extension String {
    public func rangeFromNSRange(aRange: NSRange) -> Range<String.Index> {
        let s = self.index(startIndex, offsetBy: aRange.location)
        let e = self.index(startIndex, offsetBy: aRange.location + aRange.length)
        return s..<e
    }
}
