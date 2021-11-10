//
//  BaseInsertModel.swift
//  GMChainSm2Example
//
//  Created by iOS on 2021/11/10.
//

import Foundation

public struct BaseInsertModel: Codable {
    public var height: String?
    public var txhash: String?

    public enum CodingKeys: String, CodingKey {
        case height
        case txhash
    }
}
