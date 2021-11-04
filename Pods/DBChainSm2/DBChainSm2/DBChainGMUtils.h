//
//  DBChainGMUtils.h
//  DBChainSm2
//
//  Created by iOS on 2021/9/29.
//

#import <Foundation/Foundation.h>
#import "DBChainGMObjcDef.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBChainGMUtils : NSObject

///MARK: - Hex 编码

/// 字符串 16 进制编码。返回值：16 进制编码的字符串
/// @param str 待编码的字符串
+ (nullable NSString *)stringToHex:(NSString *)str;

/// NSData 16 进制编码。返回值：16 进制编码的字符串
/// @param data 原数据（NSData 格式）
+ (nullable NSString *)dataToHex:(NSData *)data;

///MARK: - Hex 解码

/// 16 进制字符串解码。返回值：解码后的原文
/// @param hexStr 16 编码进制字符串
+ (nullable NSString *)hexToString:(NSString *)hexStr;

/// 16 进制字符串解码为 NSData。返回值：解码后的 NSData 对象
/// @param hexStr 16 编码进制字符串
+ (nullable NSData *)hexToData:(NSString *)hexStr;

///MARK: - Base64

/// base64 编码。返回值：编码后的 base64 字符串
/// @param data 待编码的数据
+ (nullable NSString *)base64Encode:(NSData *)data;

/// base64 解码。返回值：解码后的 NSData 对象
/// @param base64Str base64 编码格式字符串
+ (nullable NSData *)base64Decode:(NSString *)base64Str;

@end

NS_ASSUME_NONNULL_END
