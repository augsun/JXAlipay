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

#define JX_BLOCK_EXEC(block, ...) !block ? nil : block(__VA_ARGS__)

@interface JXAlipayManager ()

@property (nonatomic, copy) JXAlipayResultCallBack payResultCallBack;

@end

@implementation JXAlipayManager

static JXAlipayManager *singleton_;
+ (instancetype)sharedAlipay {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton_ = [[self alloc] init];
    });
    return singleton_;
}

+ (BOOL)canHandleOpenURL:(NSURL *)url {
    if ([url.scheme isEqualToString:[JXAlipayManager sharedAlipay].alipayScheme] && [url.host isEqualToString:@"safepay"]) {
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
    self.payResultCallBack = result;
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:self.alipayScheme callback:^(NSDictionary *resultDic) {
        [self payResultCallBack:resultDic];
    }];
}

- (void)payResultCallBack:(NSDictionary *)resultDic {
    NSString *resultStatus_string = [NSString stringWithFormat:@"%@", resultDic[@"resultStatus"]];
    NSInteger resultStatus = [resultStatus_string integerValue];
    JXAlipayResult result = JXAlipayResultFailure;
    switch (resultStatus) {
        case 9000: { result = JXAlipayResultSuccess; }break;
        case 6001: { result = JXAlipayResultUserCancel; }break;
        default:  break;
    }
    
    NSString *memo = [NSString stringWithFormat:@"%@", resultDic[@"memo"]];
    NSString *resultSign = [NSString stringWithFormat:@"%@", resultDic[@"result"]];

    JX_BLOCK_EXEC(self.payResultCallBack, result, memo, resultSign);
    self.payResultCallBack = nil;
}

@end

#if 0
9000    订单支付成功
8000    正在处理中
4000    订单支付失败
6001    用户中途取消
6002    网络连接出错
#endif

















