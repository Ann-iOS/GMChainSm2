# DBChainSm2
![image](https://img.shields.io/badge/Apple-MacBook_Pro_2012-999999?style=for-the-badge&logo=apple&logoColor=white)
![image](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![image](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![image](https://img.shields.io/badge/C%2B%2B-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white)
![image](http://ForTheBadge.com/images/badges/built-with-love.svg)

国密Sm2封装, 生成公私钥对.加解密, 签名验签, 可生成未压缩与压缩版公钥. 传入私钥生成公钥 参考 [GMObjc](https://github.com/muzipiao/GMObjC) 库根据自己需要对SM2进行另外的封装

## 开始

```ruby
git clone https://github.com/Ann-iOS/DBChainSm2.git

cd DBChainSm2

pod install

open DBChainSm2
```

## 环境需求

依赖 OpenSSL 1.1.1 以上版本，已打包为 Framework，并上传 cocoapods，可拖入项目直接安装，或使用 cocoapods 配置  Podfile 文件`pod GMOpenSSL`安装；并导入系统框架 Security.framework。
* iOS 9.0 以上系统
* [GMOpenSSL.framework](https://github.com/muzipiao/GMOpenSSL)(openssl.framework)
* Security.framework

## 集成
* 使用 CocoaPods
* 拖入项目源码直接使用

### CocoaPods
CocoaPods 是最简单方便的集成方法，编辑 Podfile 文件，添加

```ruby
pod 'DBChainSm2'
```

然后执行 `pod install` 即可。
DBChainSm2 同 GMObjC 一样 依赖 OpenSSL 1.1.1 以上版本，CocoaPods 不支持依赖同一静态库库的不同版本，如果遇到与三方库的 OpenSSL 冲突，例如百度地图（BaiduMapKit）依赖了低版本的 OpenSSL 静态库，会产生依赖冲突。

### Swift Package Manager

`DBChainSm2`   `dev` 分支 支持 SPM。要使用SPM，您应该使用Xcode 11打开项目。单击文件->Swift程序包->添加程序包依赖项，输入DBChainSm2 repo的URL。或者，您可以使用GitHub帐户登录Xcode，只需键入`DBChainSm2`即可进行搜索。
选择包后，`Rules` 必须选择 `Branch` ,然后输入 `dev` 的方式引入。SPM 暂不支持版本号 `version` 的方式引入 , 然后Xcode会为你设置所有的东西。
如果您是框架作者并使用 `DBChainSm2` 作为依赖项，请更新您的Package.swift文件：
```ruby
dependencies: [
    .package(name: "DBChainSm2", url: "https://github.com/Ann-iOS/DBChainSm2.git", .branch("dev")),
    ],
```

OpenSSL 冲突常见解决办法：

将三方库使用 OpenSSL 升级为 1.1.1 以上版本，DBChainSm2 同 [GMObjC](https://github.com/muzipiao/GMObjC) 直接共用此 OpenSSL 库，不需要再为 DBChainSm2 单独增加 OpenSSL 依赖库，手动集成 DBChainSm2 或者  [GMObjC](https://github.com/muzipiao/GMObjC)  即可；

方法2：将 DBChainSm2 或者 GMObjC 编译为动态库可解决此类冲突。通过 Carthage 自动将 GMObjC 编译动态库，具体操作需移步[GMObjC](https://github.com/muzipiao/GMObjC) 。DBChainSm2 暂时只实现 pod 与 SPM --> Branch -> dev 的导入方式

### 直接集成

从 Git 下载最新代码，找到和 README 同级的 DBChainSm2 文件夹，将 DBChainSm2 文件夹拖入项目即可，在需要使用的地方导入头文件 `DBChainSm2.h` 即可使用 SM2 加解密，签名验签等。

## 用法

### SM2 生成随机 未压缩公钥的公私钥对
```objc
// 获取随机的未压缩的公私钥对
NSArray *keyPair = [DBChainGMSm2Utils createKeyPair];
NSString *pubKey = keyPair[0]; // 04 开头公钥，Hex 编码格式
NSString *priKey = keyPair[1]; // 私钥，Hex 编码格式
```

### SM2 生成随机的压缩公钥的公私钥对
```objc

// 获取压缩公钥的公私钥对
NSArray *arrCompress = [DBChainGMSm2Utils createKeyPairCompress:YES];
/// 压缩的公钥
NSString *compressPubKey = arrCompress[0];  // 02 或 03 开头的压缩公钥. Hex编码格式
///  私钥
NSString *cpirKey = arrCompress[1];

NSLog(@"压缩的公私钥对: %@",arrCompress);

```

### SM2 通过指定的私钥得出 压缩 或 未压缩的 公钥
```objc
// 已知的私钥. 必须为 64 位
NSString *privateKey = @"A4AA6213F7C4ADD493FA6DD6E7A909223D053E8F0F21D6C0EAED4D211F6EC014";
// isCompress: 是否需要返回压缩公钥
NSString *pubkey = [DBChainGMSm2Utils adoptPrivatekeyGetPublicKey:privateKey isCompress:YES];
```

### SM2 通过公钥算出不同链的地址
需要手动将示例代码中的 三个 Swift 类导入项目.  `ChainType.swift`,`SegwitAddrCoder.swift `, `Bech32.swift`  不包含在 `DBChainSm2` 库中. 如有需要, 请手动导入.

**注意: **
如项目原始语言为 OC, 请先添加一个 Swift 类, 自动添加桥接文件

```objc
// 原始语言为 OC 时. 需先导入 "项目名-Swift.h"
#import "xxx-Swift.h"
/// 获取地址
Address *address = [[Address alloc]init];
/// 传入公钥
NSData *publicData = [DBChainGMUtils hexToData:pubkey];
/// ChainType: 是一个枚举. 选择需要的类型
NSString *addressStr = [address sm2GetPubToDpAddress:publicData :ChainTypeCOSMOS_MAIN];
NSLog(@"固定私钥得出公钥:%@,\n地址:%@",pubkey,addressStr);
```

### SM2 加密解密

```objc

// *******   加密  *************
NSString *plainStr = @"Hello,word";
// 转Hex
NSString *plainHex = [DBChainGMUtils stringToHex:plainStr];
//  sm2 加密  Hex 格式明文
NSString *enResult2 = [DBChainGMSm2Utils encryptHex:plainHex publicKey:pubKey]; // 加密 Hex 编码格式字符串
// sm2 解密
NSString *deResult2 = [DBChainGMSm2Utils decryptToHex:enResult2 privateKey:privateKey]; // 解密为 Hex 格式明文
NSLog(@"加密-Hex字符串: %@",enResult2);

// 判断 sm2 加解密结果
if ([deResult2 isEqualToString:plainHex]) {
    NSLog(@"sm2 加密解密成功");
}else{
    NSLog(@"sm2 加密解密失败");
}

```

### SM2 签名与验签
```objc
//   ********   签名   *******
// userID 传入 nil 或空时默认 1234567812345678；不为空时，签名和验签需要相同 ID
NSString *userID = @"1234567812345678";
NSString *userHex = [DBChainGMUtils stringToHex:userID]; // Hex 格式的 userID
NSString *signStr2 = [DBChainGMSm2Utils signHex:plainHex privateKey:privateKey userHex:userHex];
NSLog(@"签名验签 签名-Hex: %@",signStr2);
// 验证签名
BOOL isOK2 = [DBChainGMSm2Utils verifyHex:plainHex signRS:signStr2 publicKey:pubKey userHex:userHex];

if ( isOK2 ) {
    NSLog(@"SM2 签名验签成功");
} else {
    NSLog(@"SM2 签名验签失败");
}
```


## SM2 曲线

1. GM/T 0003-2012 标准推荐参数  sm2p256v1（NID_sm2）；
2. SM2 如果需要使用其他曲线，调用`[DBChainGMSm2Utils setEllipticCurveType:*]`，传入 int 类型即可；
3. 如何查找到需要的曲线，GMSm2Utils 头文件枚举中列出最常见 3 种曲线 sm2p256v1、secp256k1，secp256r1；
4. 如果是其他曲线，可在 OpenSSL 源码 crypto/ec/ec_curve.c 中查找，传入 int 类型即可。

DBChainGMSm2Utils.h 文件中 GMCurveType 对应曲线参数：

```text
ECC推荐参数：sm2p256v1（对应 OpenSSL 中 NID_sm2）
p   = FFFFFFFE FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF 00000000 FFFFFFFF FFFFFFFF
a   = FFFFFFFE FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF 00000000 FFFFFFFF FFFFFFFC
b   = 28E9FA9E 9D9F5E34 4D5A9E4B CF6509A7 F39789F5 15AB8F92 DDBCBD41 4D940E93
n   = FFFFFFFE FFFFFFFF FFFFFFFF FFFFFFFF 7203DF6B 21C6052B 53BBF409 39D54123
Gx =  32C4AE2C 1F198119 5F990446 6A39C994 8FE30BBF F2660BE1 715A4589 334C74C7
Gy =  BC3736A2 F4F6779C 59BDCEE3 6B692153 D0A9877C C62A4740 02DF32E5 2139F0A0

ECC推荐参数：secp256k1（对应 OpenSSL 中 NID_secp256k1）
p   = FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE FFFFFC2F
a   = 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
b   = 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000007
n   = FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE BAAEDCE6 AF48A03B BFD25E8C D0364141
Gx =  79BE667E F9DCBBAC 55A06295 CE870B07 029BFCDB 2DCE28D9 59F2815B 16F81798
Gy =  483ADA77 26A3C465 5DA4FBFC 0E1108A8 FD17B448 A6855419 9C47D08F FB10D4B8

ECC推荐参数：secp256r1（对应 OpenSSL 中 NID_X9_62_prime256v1）
p   = FFFFFFFF 00000001 00000000 00000000 00000000 FFFFFFFF FFFFFFFF FFFFFFFF
a   = FFFFFFFF 00000001 00000000 00000000 00000000 FFFFFFFF FFFFFFFF FFFFFFFC
b   = 5AC635D8 AA3A93E7 B3EBBD55 769886BC 651D06B0 CC53B0F6 3BCE3C3E 27D2604B
n   = FFFFFFFF 00000000 FFFFFFFF FFFFFFFF BCE6FAAD A7179E84 F3B9CAC2 FC632551
Gx  = 6B17D1F2 E12C4247 F8BCE6E5 63A440F2 77037D81 2DEB33A0 F4A13945 D898C296
Gy  = 4FE342E2 FE1A7F9B 8EE7EB4A 7C0F9E16 2BCE3357 6B315ECE CBB64068 37BF51F5
```

## 其他
借鉴  [GMObjC](https://github.com/muzipiao/GMObjC) 项目 单独整理出 SM2 生成公私钥到签名的整体流程, 添加了可压缩公钥和通过已知私钥生成公钥的方法, 
[GMObjC](https://github.com/muzipiao/GMObjC) 还包含了 ECDH 密钥协商、SM3 摘要算法、SM4 对称加密 等更多关于国密算法的封装, 如有需要可自行跳转查看源码
