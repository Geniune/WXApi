//
//  AppDelegate.m
//  WXTest
//
//  Created by Apple on 2020/5/18.
//  Copyright © 2020 Geniune. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"

#import "WXAPI/WXApi.h"

#define WXAppId            @"wx0860cd14939708ef"    //App ID
#define UNIVERSALLINK           @"https://wwwtest.asiacoat.com/" //Universal Links

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //输出微信的log信息
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString * _Nonnull log) {
        NSLog(@"%@", log);
    }];

    if([WXApi registerApp:WXAppId universalLink:UNIVERSALLINK]){
        NSLog(@"初始化成功");

        //自检函数
        [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
            NSLog(@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
        }];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HomePageViewController *VC = [[HomePageViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 第三方分享、登录回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark Universal Link
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

//注意：微信和QQ回调方法用的是同一个，这里注意判断resp类型来区别分享来源
- (void)onResp:(id)resp{

    if([resp isKindOfClass:[SendMessageToWXResp class]]){//微信回调
        
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;

        if(response.errCode == WXSuccess){
            //目前分享回调只会走成功
            NSLog(@"分享完成");
        }
    }else if([resp isKindOfClass:[SendAuthResp class]]){//判断是否为授权登录类

        SendAuthResp *req = (SendAuthResp *)resp;
        if([req.state isEqualToString:@"wx_oauth_authorization_state"]){//微信授权成功
            NSLog(@"微信登录完成，code：%@", req.code);//获取到第一步code
        }
    }else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]){
        
        WXLaunchMiniProgramResp *req = (WXLaunchMiniProgramResp *)resp;
        NSLog(@"%@", req.extMsg);// 对应JsApi navigateBackApplication中的extraData字段数据
    }
}

@end
