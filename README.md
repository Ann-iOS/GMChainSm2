# GMChainSm2
国密 Sm2 与 区块链的结合, 包含生成 助记词, 私钥公钥, 加密解密, 签名与验签, 支持通过公钥生成不同链的地址,

结合 `DBChainSm2` 与 `HDWalletSDK` 封装可生成助记词,私钥,公钥,和地址. 并组装使用 `DBChain` 链时所需要排序数据与签名交易的方法. 自由定义网络请求和请求参数, 具体可打开并运行 `Example` 文件夹中的项目进行查看.

## 开始

``` swift
git clone https://github.com/Ann-iOS/GMChainSm2.git

cd GMChainSm2

pod install

open GMChainSm2
```

## 环境需求

- iOS 10.0 以上系统
- Swift 5.0 以上

## 集成

- 使用 Cocoapods

- 手动拖入项目源码 (依赖于 `DBChainSm2` 和 `HDWalletSDK`, 需一起手动下载拖入项目使用 )

  

  ### CocoaPods

  CocoaPods 是 最简单方便的集成方法,  编辑 Podfile 文件, 添加

  ```swift
  platform :ios, '10.0'
  
  pod 'GMChainSm2'
  ```

  然后执行 `pod install` 即可

  `GMChainSm2` 依赖的 `DBChainSm2` 同 `GMObjC` 一样 依赖 OpenSSL 1.1.1 以上版本，CocoaPods 不支持依赖同一静态库库的不同版本，如果遇到与三方库的 OpenSSL 冲突，例如百度地图（BaiduMapKit）依赖了低版本的 OpenSSL 静态库，会产生依赖冲突。 

  

  ### 可能遇到的编译错误

  不支持 armv7 架构, 请在 `Build Settings - Excluded Architectures` 下添加 `Any SDK` 输入 `armv7`, 将其排除. 

  

  ### 手动集成

  除 `GMChainSm2` 外, 还需下载 [DBChainSm2](https://github.com/Ann-iOS/DBChainSm2.git)  和 [HDWalletSDK](https://github.com/Ann-iOS/HDWalletSDK)  一并导入项目使用

## 用法

#### 注意:

<u>GMChainSm2 集成了生成Bip39助记词,通过助记词生成私钥和公钥, 通过公钥导出地址的功能, 该库生成公钥算法使用的是国密Sm2, 如需 secp256k1 算法, 可点击跳转查看 [DBChainKit](https://github.com/dbchaincloud/ios-client) 库,  如果项目并不需要助记词来生成私钥公钥,只需要Sm2的加密 解密, 签名与验签, 直接通过 cocoaPods 下载 DBChainSm2 即可. </u>



### 生成助记词

```swift
import GMChainSm2
let mnemonic = Sm2Mnemonic().createMnemonicString()
// 助记词由12个随机单词组成
print("助记词:\(mnemonic)")
```

### 通过助记词生成 Bip39 种子

```swift
let bip = Sm2Mnemonic().mnemonicSeedBipData(mnemonicStr: mnemonic)
```

### 通过 Bip39 种子导出秘钥

```swift
let privateKey = Sm2PrivateKey.init(seed: bip, coin: .bitcoin)
let privateKeyStr = privateKey.createSm2PrivateKey()
print("私钥:\(privateKeyStr)")
```

### 通过私钥导出公钥

```swift
// 公钥存在压缩与未压缩两种状态, 压缩公钥为 33 个字节, 未压缩公钥为完整的 64 个字节. 
let publickeyStr = privateKey.sm2PublickeyCompressStr
print("压缩公钥的字符串格式:\(publickeyStr)")

let publickeyStr = privateKey.sm2PublickeyUncompressStr
print("未压缩公钥的字符串格式:\(publickeyStr)")

let publickeyData = privateKey.sm2PublickeyCompressData
print("压缩公钥的 Data 格式:\(publickeyData)")

let publickeyData = privateKey.sm2PublickeyUncompressData
print("未压缩公钥的 Data 格式:\(publickeyData)")
```

### 通过公钥导出不同链的地址

```swift
let address = Sm2ChainAddress.shared.sm2GetPubToDpAddress(privateKey.sm2PublickeyCompressData, .DBCHAIN_MAIN)
print("地址:\(address)")
```

### 支持生成的链地址有:

```swift
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
```



### 提交交易时所需的 Token

```swift
let token = Sm2Token.shared.createAccessToken(privateKeyStr: privateKeyStr, publikeyStr: publickeyStr)
print("Token: \(token)")
```

### * Sm2 加密解密, 签名与验签, 可查看 DBChainSm2 库的 README文档

## 其他

- ChainUserModel 类 是使用DBChain 提交交易时所需要的用户模型

- 提交交易的参数在签名前需要进行排序, 以确保服务端在验签时不会发生错误
- Sm2ComposeSigner 提供数据组装 排序 和 签名服务, 在提交交易前, 必须先调用 `Sm2ComposeSigner` 中的 `composeSignMessage` 组装排序和签名交易数据,  再通过 `sortedSignStr` 方法排序最终提交给服务端的数据, 具体可查看 `Example` 中的例子.  





​	









 



