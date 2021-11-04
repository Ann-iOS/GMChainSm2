//
//  DBChainGMSm2Bio.m
//  DBChainSm2
//
//  Created by iOS on 2021/9/29.
//

#import "DBChainGMSm2Bio.h"
#import <openssl/bn.h>
#import <openssl/pem.h>
#import "DBChainGMUtils.h"
#import <openssl/sm2.h>

// 默认椭圆曲线类型 NID_sm2
static int kDefaultBioEllipticCurveType = NID_sm2;


@implementation DBChainGMSm2Bio
///MARK: - 椭圆曲线类型
+ (int)ellipticCurveType {
    return kDefaultBioEllipticCurveType;
}

+ (void)setEllipticCurveType:(int)curveType {
    kDefaultBioEllipticCurveType = curveType;
}

@end
