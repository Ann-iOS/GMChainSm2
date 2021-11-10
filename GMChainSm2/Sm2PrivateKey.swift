//
//  Sm2PrivateKey.swift
//  GMChainSm2
//
//  Created by iOS on 2021/11/4.
//

import UIKit
import HDWalletSDK
import DBChainSm2

public class Sm2PrivateKey: NSObject {

    public let raw: Data
    public let coin: Coin

    public required init(seed: Data, coin: Coin) {
        let privatekey = PrivateKey(seed: seed, coin: coin)
        // 派生
        let purpose = privatekey.derived(at: .hardened(44))
        let coinType = purpose.derived(at: .hardened(118))
        let account = coinType.derived(at: .hardened(0))
        let change = account.derived(at: .notHardened(0))
        let firstPrivateKey = change.derived(at: .notHardened(0))

        self.raw = firstPrivateKey.raw
        self.coin = coin
    }

    ///  获取 私钥字符串
    /// - Parameters:
    /// - Returns: 返回 私钥的字符串形式
    public func createSm2PrivateKey() -> String {

        return raw.toHexString()
    }

    /// 获取 Sm2 压缩公钥
    public var sm2PublickeyCompressStr: String {
        let publickey = DBChainGMSm2Utils.adoptPrivatekeyGetPublicKey(raw.toHexString(), isCompress: true)
        return publickey
    }

    /// 获取 Sm2 未压缩公钥
    public var sm2PublickeyUncompressStr: String {
        let publickey = DBChainGMSm2Utils.adoptPrivatekeyGetPublicKey(raw.toHexString(), isCompress: false)
        return publickey
    }

    /// 获取 Sm2 压缩公钥 Data
    public var sm2PublickeyCompressData: Data {
        let publickey = DBChainGMSm2Utils.adoptPrivatekeyGetPublicKey(raw.toHexString(), isCompress: true)
        return publickey.hexaData
    }

    /// 获取 Sm2 未压缩公钥 Data
    public var sm2PublickeyUncompressData: Data {
        let publickey = DBChainGMSm2Utils.adoptPrivatekeyGetPublicKey(raw.toHexString(), isCompress: false)
        return publickey.hexaData
    }

}
