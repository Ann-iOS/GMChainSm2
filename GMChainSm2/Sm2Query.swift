//
//  Sm2Query.swift
//  GMChainSm2
//
//  Created by iOS on 2021/11/19.
//

import Foundation
import HDWalletSDK
public class Sm2Query: NSObject {

    /// 查询整张表数据的封装
    /// - Parameter tableName: 需要查询的表名
    /// - Returns: 返回经过Base58编码后的字符串格式, 拼接在 查询的url 的最后
    public func assembleQueryTableListEncodeString(tableName: String) -> String {
        let methodDic: [[String: Any]] = [["method":"table","table":tableName]]
        let methodData = try? JSONSerialization.data(withJSONObject: methodDic, options: [])
        let methodBase58 = Base58.encode(methodData!)
        return methodBase58
    }

    /// 条件查询的封装 (可以 key-value 的形式进行多条件查询)
    /// - Parameters:
    ///   - tableName: 查询的表名
    ///   - fieldDic: 查询条件, key 对应待查询的字段名, value 对应查询的数据
    /// - Returns: 返回经过Base58编码后的字符串格式  拼接在 查询的url 的最后
    public func assembleConditionQueryEncodeString(tableName: String,fieldDic: [String: Any]) -> String {
        var methodArr : [[String:Any]] = [["method":"table","table":tableName]]
        for (key,value) in fieldDic {
            let arr = ["field":key,"method":"where","operator":"=","value":value]
            methodArr.append(arr)
        }
        let methodData : Data = try! JSONSerialization.data(withJSONObject: methodArr, options: [])
        let methodBase58 = Base58.encode(methodData)
        return methodBase58
    }

}
