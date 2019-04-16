//
//  JXAliPayManager.h
//  JXAlipay
//
//  Created by augsun on 8/30/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 支付结果 */
typedef NS_ENUM(NSUInteger, JXAlipayResult) {
    JXAlipayResultSuccess, ///< 支付成功
    JXAlipayResultFailure, ///< 支付失败
    JXAlipayResultUserCancel ///< 支付取消
};

/**
 基于 AlipaySDK-iOS 15.5.9 版本封装.
 */
@interface JXAlipayManager : NSObject

+ (instancetype)sharedAlipay; ///< 单例

@property (nonatomic, copy) NSString *alipayScheme; ///< 设置在 Info.plist 里的 alipayScheme

+ (BOOL)canHandleOpenURL:(NSURL *)URL; ///< 能否处理该 URL
+ (BOOL)handleOpenURL:(NSURL *)url; ///< 处理支付回调 URL

/**
 发起支付并回调支付结果

 @param orderString 支付订单字符串
 @param result 支付结果
 */
- (void)payWithOrderString:(NSString *)orderString result:(void(^)(JXAlipayResult result, NSString *memo, NSString *resultSign))result;

@end
