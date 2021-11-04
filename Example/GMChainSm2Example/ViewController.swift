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

        let mnemonic = Sm2Mnemonic().createMnemonicString()
        let bip = Sm2Mnemonic().mnemonicSeedBipData(mnemonicStr: mnemonic)
        print(mnemonic)
        let privateKey = Sm2PrivateKey.init(seed: bip, coin: .bitcoin)
        print("私钥:\(privateKey.createSm2PrivateKey())")
        print(privateKey.raw)
        print(privateKey.sm2PublickeyCompressStr)

        let address = Sm2ChainAddress.shared.sm2GetPubToDpAddress(privateKey.sm2PublickeyCompressData, .DBCHAIN_MAIN)
        print("地址:\(address)")

        let token = Sm2Token.shared.createAccessToken(privateKeyStr: privateKey.createSm2PrivateKey(), publikeyStr: privateKey.sm2PublickeyCompressStr)
        print("Token: \(token)")
    }
}

