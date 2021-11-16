//
//  ViewController.swift
//  GMChainSm2Example
//
//  Created by iOS on 2021/11/4.
//

import UIKit
import GMChainSm2

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        let mnemonic = Sm2Mnemonic().createMnemonicString()
        let mnemonic = "enroll lab owner track cream vapor wealth fashion flock inject cram retreat"
        let bip = Sm2Mnemonic().mnemonicSeedBipData(mnemonicStr: mnemonic)
        print("助记词:\(mnemonic)")

        let privateKey = Sm2PrivateKey.init(seed: bip, coin: .bitcoin)
        let privateKeyStr = privateKey.createSm2PrivateKey()
        print("私钥:\(privateKeyStr)")

        print("私钥:\(privateKey.raw.toHexString())")

        let publickey = privateKey.sm2PublickeyCompressStr
        print("公钥:\(publickey)")

        let address = Sm2ChainAddress.shared.sm2GetPubToDpAddress(privateKey.sm2PublickeyCompressData, .DBCHAIN_MAIN)
        print("地址:\(address)")

        let token = Sm2Token.shared.createAccessToken(privateKeyStr: privateKey.createSm2PrivateKey(), publikeyStr: privateKey.sm2PublickeyCompressStr)
        print("Token: \(token)")

        /// 获取积分
        IPAProvider.request(NetworkAPI.getIntegralUrl(token: token)) { (result) in
            guard case .success(let response) = result else { return }
            do {
                let jsonDic = try response.mapJSON() as! NSDictionary
                if jsonDic.value(forKey: "result") != nil {
                    let stateStr = jsonDic["result"] as! String
                    guard stateStr == "success" else {  print("请求错误!!!!!"); return }
                    print("请求成功!! \(jsonDic["result"]!)")
                    /// 获取用户信息
                    IPAProvider.request(NetworkAPI.getUserModelUrl(address: address)) { (userinfoRebsult) in
                        guard case .success(let userinfoResponse) = userinfoRebsult else { return }
                        do {
                            let model = try JSONDecoder().decode(ChainUserModel.self, from: userinfoResponse.data)
                            /// 插入一条数据
                            let fieldsDic = ["name":"An",
                                             "age":"20",
                                             "dbchain_key":address,
                                             "sex":"0",
                                             "status":"",
                                             "photo":"",
                                             "motto":"这是一条测试"] as [String : Any]

                            IPAProvider.request(NetworkAPI.insertData(userModel: model, fields: fieldsDic, tableName: "user", publicKey: publickey, privateKey: privateKeyStr, address: address, msgType: "dbchain/InsertRow", sm2UserID: "1234567812345678")) { (insertResult) in
                                guard case .success(let insertResponse) = insertResult else { return }
                                do {
                                    let imodel = try JSONDecoder().decode(BaseInsertModel.self, from: insertResponse.data)
                                    guard imodel.txhash != nil else {return}
                                    print("插入数据的 Txhash: \(imodel.txhash!)")
                                    /// 定时器查询结果
                                    let itoken = Sm2Token.shared.createAccessToken(privateKeyStr: privateKey.createSm2PrivateKey(), publikeyStr: privateKey.sm2PublickeyCompressStr)

                                    var waitTime = 15
                                    Sm2GCDTimer.shared.scheduledDispatchTimer(WithTimerName: "VerificationHash", timeInterval: 1, queue: .init(label: "test"), repeats: true) {
                                        waitTime -= 1
                                        if waitTime > 0 {
                                            print("执行次数: \(waitTime) -- \(Thread.current)")
                                            IPAProvider.request(NetworkAPI.verificationHash(token: itoken, txhash: imodel.txhash!)) { (verificationData) in
                                                guard case .success(let verificationResponse) = verificationData else { return }
                                                do {
                                                    let verificationJson = try verificationResponse.mapJSON() as! NSDictionary
                                                    print("查询倒计时: \(waitTime) \n结果:\(verificationJson)\n")
                                                }
                                                catch {
                                                    print("查询倒计时解析json失败!!!")
                                                    Sm2GCDTimer.shared.cancleTimer(WithTimerName: "VerificationHash")
                                                }
                                            }
                                        } else {
                                            Sm2GCDTimer.shared.cancleTimer(WithTimerName: "VerificationHash")
                                            print("查询倒计时结束!!!! 无结果.")
                                        }
                                    }
                                } catch {
                                    print("插入信息错误")
                                }
                            }
                        } catch {
                            print("userinfo error")
                        }
                    }
                }
            } catch {
                print("请求错误!! \(result)")
            }
        }
    }
}

