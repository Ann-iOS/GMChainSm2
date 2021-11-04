//
//  Sm2Token.swift
//  GMChainSm2
//
//  Created by iOS on 2021/11/2.
//

import UIKit
import DBChainSm2
import HDWalletSDK

@objc
public class Sm2Token: NSObject {

    public static let shared = Sm2Token()
    private override init() {}

    /// 获取当前 毫秒级 时间戳 - 13位
    public  var milliStamp : String {
          let timeInterval: TimeInterval = Date().timeIntervalSince1970
          let millisecond = CLongLong(round(timeInterval*1000))
          return "\(millisecond)"
      }

    /// 获取Token
    /// - Parameters:
    ///   - privateKey: 秘钥
    ///   - publikeyData: 公钥
    ///   - signUserHex: Sm2 签名时的userID, 需要与服务端一致, 默认值为 "1234567812345678"
    /// - Returns: 成功则 返回Token. 错误返回空
    public func createAccessToken(privateKeyStr:String,publikeyStr:String,signUserHex:String? = "1234567812345678") -> String {
        let millisecond = self.milliStamp
        // sm2 签名
        let plainHex = DBChainGMUtils.string(toHex: millisecond)
        let userHex = DBChainGMUtils.string(toHex: signUserHex!)
        /// 对当前时间戳签名
        let signMilliSecond = DBChainGMSm2Utils.signHex(plainHex!, privateKey: privateKeyStr, userHex: userHex)
        let timeBase58 = Base58.encode(signMilliSecond!.hexaData)
        let publicKeyBase58 = Base58.encode(publikeyStr.hexaData)
        return "\(publicKeyBase58):" + "\(millisecond):" + "\(timeBase58)"
    }
}
