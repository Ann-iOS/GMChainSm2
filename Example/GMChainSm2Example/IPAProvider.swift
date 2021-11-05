//
//  IPAProvider.swift
//  GMChainSm2Example
//
//  Created by iOS on 2021/11/5.
//

import Foundation
import Moya

let BASEURL : String = "https://controlpanel.dbchain.cloud/relay/"
var Chainid : String = "testnet"
var APPCODE : String = "5APTSCPSF7"


/// 获取用户信息
var GetUserDataURL = "auth/accounts/"
/// 插入信息
var InsertDataURL = "txs"
/// 查询
var QueryDataUrl = "dbchain/querier/"
/// 上传数据
var UploadFileURL = "dbchain/upload/"
/// 图片下载地址
var DownloadFileURL = "ipfs/"
/// 新注册账号获取权限
var GetIntegralUrl = "dbchain/oracle/new_app_user/"


//设置请求超时时间
let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<NetworkAPI>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 30
        done(.success(request))
    } catch {
        print("请求超时")
        return
    }
}

let IPAProvider = MoyaProvider<NetworkAPI>(requestClosure: requestTimeoutClosure)

enum NetworkAPI {
    case getIntegralUrl(token: String)
}

extension NetworkAPI: TargetType {
    var baseURL: URL {
        return URL(string: BASEURL)!
    }

    var path: String {
        switch self {
        case .getIntegralUrl(let token):
            print("传递的token:\(token) ---- \(GetIntegralUrl + "\(token)")")
            return GetIntegralUrl + "\(token)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getIntegralUrl(_):
            return .get
//        default:
//            return .post
        }
    }

    var task: Task {
//        var parmeters: [String : Any] = [:]
        switch self {
        case .getIntegralUrl:
            break
        }
        return .requestPlain
    }

    var headers: [String : String]? {
        return nil
    }


    // 是否执行Alamofire验证
    var validate: Bool {
        return false
    }

    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

}
