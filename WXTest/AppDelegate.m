//
//  AppDelegate.m
//  WXTest
//
//  Created by Apple on 2020/5/18.
//  Copyright © 2020 Geniune. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"

#import "OpenManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [OPENSDKMANAGER setup];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HomePageViewController *VC = [[HomePageViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

//若要支持iOS 7 ~ 9，则需要放开这两个回调：
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//
//    return [OPENSDKMANAGER handleOpenURL:url];
//}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
//
//    return [OPENSDKMANAGER handleOpenURL:url];
//}

//若只支持iOS 9+，只保留下方两个回调即可：
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    
    return [OPENSDKMANAGER handleOpenURL:url];
}

#pragma mark Universal Link
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {

    return [OPENSDKMANAGER handleOpenUniversalLink:userActivity];
}

@end
