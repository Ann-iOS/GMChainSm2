//
//  Sm2Mnemonic.swift
//  GMChainSm2
//
//  Created by iOS on 2021/11/4.
//

import UIKit
import HDWalletSDK

public class Sm2Mnemonic: NSObject {

    /// 随机生成助记词
    /// - Returns: 助记词
    public func createMnemonicString() -> String {
        return Mnemonic.create()
    }

    /// 通过助记词生成 Bip39 种子
    /// - Parameter mnemonicStr: 助记词
    /// - Returns: Bip39种子
    public func mnemonicSeedBipData(mnemonicStr: String) -> Data {
        return Mnemonic.createSeed(mnemonic: mnemonicStr)
    }

}
