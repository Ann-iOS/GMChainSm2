//
//  Sm2ChainAddress.swift
//  GMChainSm2
//
//  Created by iOS on 2021/11/2.
//

import Foundation
import CommonCrypto

@objc public enum Sm2ChainType: Int {
    case COSMOS_MAIN
    case IRIS_MAIN
    case BINANCE_MAIN
    case KAVA_MAIN
    case IOV_MAIN
    case BAND_MAIN
    case SECRET_MAIN

    case DBCHAIN_MAIN

    case BINANCE_TEST
    case KAVA_TEST
    case IOV_TEST
    case OKEX_TEST
    case CERTIK_TEST

    static func SUPPRT_CHAIN() -> Array<Sm2ChainType> {
        var result = [Sm2ChainType]()
        result.append(COSMOS_MAIN)
        result.append(IRIS_MAIN)
        result.append(BINANCE_MAIN)
        result.append(IOV_MAIN)
        result.append(KAVA_MAIN)
        result.append(BAND_MAIN)
        result.append(SECRET_MAIN)

        result.append(DBCHAIN_MAIN)

        result.append(BINANCE_TEST)
        result.append(KAVA_TEST)
        result.append(IOV_TEST)
        result.append(OKEX_TEST)
        result.append(CERTIK_TEST)
        return result
    }
}

@objc
public class Sm2ChainAddress: NSObject {
    public static let shared = Sm2ChainAddress()
    private override init() {}

    public func sm2GetPubToDpAddress(_ pubHex:Data, _ chain:Sm2ChainType) -> String {
        var result = ""
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        let pubHexData = pubHex as NSData
        CC_SHA256(pubHexData.bytes, UInt32(pubHexData.length), &hash)
        let sha256 = NSData(bytes: hash, length: digestLength)

        let shaArr = sha256[0...19]
        let ripemd160 = Data(shaArr)
        if (chain == Sm2ChainType.COSMOS_MAIN) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "cosmos", program: ripemd160)
        } else if (chain == Sm2ChainType.DBCHAIN_MAIN) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "dbchain", program: ripemd160)
        } else if (chain == Sm2ChainType.IRIS_MAIN) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "iaa", program: ripemd160)
        } else if (chain == Sm2ChainType.BINANCE_MAIN) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "bnb", program: ripemd160)
        } else if (chain == Sm2ChainType.KAVA_MAIN || chain == Sm2ChainType.KAVA_TEST) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "kava", program: ripemd160)
        } else if (chain == Sm2ChainType.BAND_MAIN) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "band", program: ripemd160)
        } else if (chain == Sm2ChainType.SECRET_MAIN) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "secret", program: ripemd160)
        } else if (chain == Sm2ChainType.BINANCE_TEST) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "tbnb", program: ripemd160)
        } else if (chain == Sm2ChainType.IOV_MAIN || chain == Sm2ChainType.IOV_TEST) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "star", program: ripemd160)
        } else if (chain == Sm2ChainType.OKEX_TEST) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "okexchain", program: ripemd160)
        } else if (chain == Sm2ChainType.CERTIK_TEST) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "certik", program: ripemd160)
        }
       return result
    }
}
