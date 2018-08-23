//
//  WXAuth.h
//  hongyantub2b
//
//  Created by Apple on 2018/8/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  WXAUTH [WXAuth sharedInstance]

@interface WXAuth : NSObject

//全局管理对象
+ (WXAuth *)sharedInstance;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)sendWXAuthReq;

@end
