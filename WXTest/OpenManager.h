//
//  OpenManager.h
//  WXTest
//
//  Created by Geniune on 2021/2/26.
//  Copyright © 2021 Geniune. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define  OPENSDKMANAGER [OpenManager sharedInstance] //获取单例类对象

@interface BaseShareModel : NSObject

@end

@interface WebShareModel : BaseShareModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *url;

@end

@interface OpenManager : NSObject

//全局管理对象
+ (OpenManager *)sharedInstance;

- (void)setup;


//企业微信
- (BOOL)WWAppInstalled; //是否安装客户端
- (void)WWAuth; //授权登录
- (void)WWShare:(WebShareModel *)model;//分享

//微信
- (BOOL)WXAppInstalled; //是否安装客户端
- (void)WXAuth; //授权登录
- (void)WXShare:(WebShareModel *)model; //分享


- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;

@end

