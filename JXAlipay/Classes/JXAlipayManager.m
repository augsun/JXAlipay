//
//  JXAliPayManager.m
//  JXAlipay
//
//  Created by augsun on 8/30/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXAlipayManager.h"
#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>

@interface JXAlipayManager ()

@property (nonatomic, copy) void (^payResult)(JXAlipayResult result, NSString *memo, NSString *resultSign);

@end

@implementation JXAlipayManager

static JXAlipayManager *singleton_;
+ (instancetype)sharedAlipay {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ singleton_ = [[self alloc] init]; }); return singleton_;
}

+ (BOOL)canHandleOpenURL:(NSURL *)URL {
    if ([URL.scheme isEqualToString:[JXAlipayManager sharedAlipay].alipayScheme] && [URL.host isEqualToString:@"safepay"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [[JXAlipayManager sharedAlipay] payResultCallBack:resultDic];
    }];
    return YES;
}

- (void)payWithOrderString:(NSString *)orderString result:(void (^)(JXAlipayResult, NSString *, NSString *))result {
    self.payResult = result;
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:self.alipayScheme callback:^(NSDictionary *resultDic) {
        [self payResultCallBack:resultDic];
    }];
}

- (void)payResultCallBack:(NSDictionary *)resultDic {
    /*
     9000	订单支付成功
     8000	正在处理中
     4000	订单支付失败
     6001	用户中途取消
     6002	网络连接出错
     */
    NSString *memo = [self strValue:resultDic[@"memo"]];
    NSString *resultSign = [self strValue:resultDic[@"result"]];
    JXAlipayResult result = JXAlipayResultFailure;
    switch ([resultDic[@"resultStatus"] integerValue]) {
        case 9000: { result = JXAlipayResultSuccess; }break;
        case 6001: { result = JXAlipayResultUserCancel; }break;
        default:  break;
    }
    !self.payResult ? : self.payResult(result, memo, resultSign);
    self.payResult = nil;
}

- (NSString *)strValue:(id)value {
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", value];
    }
    else {
        return nil;
    }
}

@end

















