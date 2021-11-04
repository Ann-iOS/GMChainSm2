//
//  DBChainGMSm2Bio.h
//  DBChainSm2
//
//  Created by iOS on 2021/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBChainGMSm2Bio : NSObject
///MARK: - 椭圆曲线类型
/// 常见椭圆曲线为 NID_sm2、NID_secp256k1、NID_X9_62_prime256v1
/// 默认 NID_sm2，参考 GMObjCDef.h 中说明，一般不需更改
/// 若需要更改，传入枚举 GMCurveType 枚举值即可，枚举定义在GMObjCDef.h
/// 若需要其他曲线，在 OpenSSL 源码 crypto/ec/ec_curve.c 查找
+ (int)ellipticCurveType;
+ (void)setEllipticCurveType:(int)curveType;

@end

NS_ASSUME_NONNULL_END
