//
//  Sm2ComposeSigner.swift
//  GMChainSm2
//
//  Created by iOS on 2021/11/5.
//

import UIKit
import DBChainSm2

public class Sm2ComposeSigner: NSObject {

    public static let shared = Sm2ComposeSigner()
    private override init() {}
    
    public var userModel :ChainUserModel?
    var signMsgArr = [Dictionary<String, Any>]()
    let fee: [String: Any] = ["amount":[],"gas":"99999999"]


    /// 组装插入数据的签名数据
    /// - Parameters:
    ///   - usermodel: ChainUserModel 模型
    ///   - fields: 待插入的信息字典
    ///   - appcode: appcode
    ///   - chainid: chainid
    ///   - address: 地址
    ///   - tableName: 待插入数据的表名
    ///   - sm2SignUserID: sm2 签名时需要与服务端一致的UserID, 可不传, 默认为 : 1234567812345678
    ///   - privateKey: 私钥
    ///   - msgType: 消息体需要执行的操作类型. 默认是插入操作 "dbchain/InsertRow"
    /// - Returns: 返回组装并已签名的数据

    public func composeSignMessage(usermodel: ChainUserModel,
                                   fields: [String: Any],
                                   appcode: String,
                                   chainid: String,
                                   address: String,
                                   tableName: String,
                                   privateKey: String,
                                   sm2SignUserID: String = "1234567812345678",
                                   msgType: String = "dbchain/InsertRow" ) -> String {

        let fieldsStr = fields.dicValueString(fields)
        let fieldsData = Data(fieldsStr!.utf8)
        let fieldBase = fieldsData.base64EncodedString()
        let valueDic:[String:Any] = ["app_code":appcode,
                                     "owner":address,
                                     "fields":fieldBase,
                                     "table_name":tableName]
        let msgDic:[String:Any] = ["type":msgType,
                                   "value":valueDic]

        signMsgArr.append(msgDic)

        let signDic : [String:Any] = ["account_number":usermodel.result.value.account_number,
                                      "chain_id":chainid,
                                      "fee":fee,
                                      "memo":"",
                                      "msgs":signMsgArr,
                                      "sequence":usermodel.result.value.sequence]
        let signDicStr = signDic.dicValueString(signDic)
        let replacStr = signDicStr!.replacingOccurrences(of: "\\/", with: "/")
        print("签名数据字典字符串:\(replacStr)")
        /// sm2 签名
        let plainHex = DBChainGMUtils.string(toHex: replacStr)
        let userHex = DBChainGMUtils.string(toHex: sm2SignUserID)
        let signStr = DBChainGMSm2Utils.signHex(plainHex!, privateKey: privateKey, userHex: userHex)
        let signBaseStr = signStr!.hexaData.base64EncodedString()
        return signBaseStr
    }


    /// 排序最终提交的数据
    /// - Parameters:
    ///   - signType: 签名类型, 默认是 tendermint/PubKeySm2.  如 secp256k1曲线, 可填写  tendermint/PubKeySecp256k1
    ///   - publickBaseStr: 公钥的Base64字符串
    ///   - signature: 签名的数据
    /// - Returns: 排序后的字典
    public func sortedSignStr(signType: String = "tendermint/PubKeySm2",publickStr: String,signature:String) -> [String:Any] {

        let publickBaseStr = publickStr.hexaData.base64EncodedString()
        let signDivSorted = ["key":["type":signType,
                                    "value":publickBaseStr]]

        let typeSignDiv = sortedDictionarybyLowercaseString(dic: signDivSorted)

        let signDic = ["key":["pub_key":typeSignDiv[0],
                              "signature":signature]]

        let signDiv = sortedDictionarybyLowercaseString(dic: signDic)

        let tx = ["key":["memo":"",
                         "fee":fee,
                         "msg":signMsgArr,
                         "signatures":[signDiv[0]]]]

        let sortTX = sortedDictionarybyLowercaseString(dic: tx)

        let dataSort = sortedDictionarybyLowercaseString(dic: ["key": ["mode":"async","tx":sortTX[0]]])

        return dataSort[0]
    }

    /// 字典排序
    private func sortedDictionarybyLowercaseString(dic:Dictionary<String, Any>) -> [[String:Any]] {
        let allkeyArray  = dic.keys
        let afterSortKeyArray = allkeyArray.sorted(by: {$0 < $1})
        var valueArray = [[String:Any]]()
        afterSortKeyArray.forEach { (sortString) in
            let valuestring = dic[sortString]
            valueArray.append(valuestring as! [String:Any])
        }
        return valueArray
    }
}
