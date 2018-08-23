//
//  WXAuth.m
//  hongyantub2b
//
//  Created by Apple on 2018/8/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "WXAuth.h"
#import "WXApi.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

@interface WXAuth ()<WXApiDelegate>

@end

@implementation WXAuth

+ (WXAuth *)sharedInstance{
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        
        return [[self alloc] init];
    });
}

- (id)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)sendWXAuthReq{
    
    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        
        [WXApi sendReq:req];
    }else{
        
        NSLog(@"未安装微信应用或版本过低");
    }
}

- (BOOL)handleOpenURL:(NSURL *)url{
    
    //处理回调
    if([url.host isEqualToString:@"platformId=wechat"] || [url.host isEqualToString:@"oauth"]){//微信WeChat分享回调
        
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        
        return NO;
    }
}

/**
 Delegate回调方法
 */
- (void)onResp:(id)resp{
    if([resp isKindOfClass:[SendAuthResp class]]){//判断是否为授权登录类
        
        SendAuthResp *req = (SendAuthResp *)resp;
        if([req.state isEqualToString:@"wx_oauth_authorization_state"]){//微信授权成功
            
            if(req.errCode == 0){
                
                NSLog(@"获取code：%@", req.code);
                
//                req.code;
            }
        }
    }
}

@end
