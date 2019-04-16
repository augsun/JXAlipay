//
//  JXAliPayManager.h
//  JXAlipay
//
//  Created by augsun on 8/30/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 支付结果 */
typedef NS_ENUM(NSUInteger, JXAlipayResult) {
    JXAlipayResultSuccess, ///< 支付成功
    JXAlipayResultFailure, ///< 支付失败
    JXAlipayResultUserCancel ///< 支付取消
};

/**
 支付结果回调

 @param result 支付结果
 @param memo 支付宝回调消息
 @param resultSign 支付宝回调签名串
 */
typedef void(^JXAlipayResultCallback)(JXAlipayResult result, NSString *memo, NSString *resultSign);

/**
 基于 AlipaySDK-iOS (版本见 JXAlipay.podspec 中的 s.dependency 'AlipaySDK-iOS', 'X.X.X') 封装.
 */
@interface JXAlipayManager : NSObject

+ (instancetype)sharedAlipay; ///< 单例

@property (nonatomic, copy) NSString *alipayScheme; ///< 设置在 Info.plist 里的 alipayScheme, 建议在 APP 启动时设置.

+ (BOOL)canHandleOpenURL:(NSURL *)url; ///< 能否处理该 URL
+ (BOOL)handleOpenURL:(NSURL *)url; ///< 处理支付回调 URL

/**
 发起支付并回调支付结果

 @param orderString 支付订单字符串
 @param result 支付结果
 */
- (void)payWithOrderString:(NSString *)orderString result:(JXAlipayResultCallback)result;

@end

NS_ASSUME_NONNULL_END
