//
//  Sm2Extension.swift
//  GMChainSm2
//
//  Created by iOS on 2021/11/2.
//

import Foundation

extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return UInt8(self[start..<end], radix: 16)
        }
    }
}

extension Dictionary {
    public func dicValueString(_ dic:[String : Any]) -> String?{
        var jsonData = Data()
        var jsonStr = String()
        do {
            if #available(iOS 11.0, *) {
                jsonData = try JSONSerialization.data(withJSONObject: dic, options: .sortedKeys)
            } else {
                // Fallback on earlier versions
                return nil;
            }
            jsonStr = String(data: jsonData, encoding: .utf8)!
        } catch {
            return nil;
        }
        return jsonStr
    }
}

extension String {
    /// 是否为json字符串
    public func isjsonStyle() -> Bool {
        let jsondata = self.data(using: .utf8)
        do {
            try JSONSerialization.jsonObject(with: jsondata!, options: .mutableContainers)
            return true
        } catch {
            return false
        }
    }

    public func toDictionary() -> [String : Any] {
        var result = [String : Any]()
        guard !self.isEmpty else { return result }
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf,
                                                       options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
    }

    //  字符串是否为空
    public var isBlank: Bool {
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
}
