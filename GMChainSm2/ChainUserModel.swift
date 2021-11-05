//
//  ChainUserModel.swift
//  GMChainSm2
//
//  Created by iOS on 2021/11/5.
//

import UIKit

public class ChainUserModel: NSObject, Codable {
    public var height: String
    public var result: resultModel

    public struct resultModel: Codable {
        public var type: String
        public var value: valueData
    }

    public struct valueData: Codable {
        public var address: String
        public var coins: [coinData]?
        public var public_key: publicData?
        public var account_number: String
        public var sequence: String
    }

    public struct publicData: Codable {
        public var type: String
        public var value: String
    }

    public struct coinData: Codable {
        public var denom: String
        public var amount: String
    }
}
