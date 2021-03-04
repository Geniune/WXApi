//
//  OpenManager.m
//  WXTest
//
//  Created by Geniune on 2021/2/26.
//  Copyright © 2021 Geniune. All rights reserved.
//

#import "OpenManager.h"
#import "WXApi.h"
#import "WWKApi.h"

/**
 *  单例宏方法
 *
 *  @param block
 *
 *  @return 返回单例
 */
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

//微信
#define WX_AppID            @"wxca5f2191000014"
#define WX_UniversalLink           @"https://www.google.com/wx_conn/1000014/"

//企业微信
//用户填写第三方应用Bundle Id完成上述注册流程后，系统根据corpId(企业ID 见下描述)与agentId(应用ID 见下描述)计算得到的一个schema字符串。用于企业微信完成SSO登录流程后回调返回用户的第三方应用
#define WW_AppID            @"wwauth700000a5f2191000014"//app id
#define WW_CorpID            @"ww700000a5f2191"//用户登录企业管理页面的时候在 “我的企业” 页面会得到一个corpId，这个corpid即为需要填在这里的企业ID
#define WW_AgentID            @"1000014"//当用户为自己企业新加一个第三方iOS应用的时候，系统会为每个iOS应用分配不同的企业内部唯一的应用ID

@interface OpenManager () <WXApiDelegate, WWKApiDelegate>

@end

@implementation OpenManager

+ (instancetype)sharedInstance{
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        
        return [[self alloc] init];
    });
}

- (instancetype)init{
    
    self = [super init];
    
    if(self){
        
    }
    
    return self;
}

- (void)setup{
    
    [WXApi registerApp:WX_AppID universalLink:WX_UniversalLink];
    
    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult * _Nonnull result) {
        
        if(!result.success){
            DebugLog(@"step %zd", step);
            DebugLog(@"%@", result.suggestion);
        }
    }];
    
    [WWKApi registerApp:WW_AppID corpId:WW_CorpID agentId:WW_AgentID];
}

- (BOOL)WWAppInstalled{
    
    return [WWKApi isAppInstalled];
}

- (void)WWAuth{
    
    WWKSSOReq *req = [[WWKSSOReq alloc] init];
    req.state = @"ww_oauth_authorization_state";
    [WWKApi sendReq:req];
}

- (void)WWShare:(WebShareModel *)model{
    
    WWKMessageLinkAttachment *attachment = [[WWKMessageLinkAttachment alloc] init];
    attachment.title = model.title;
    attachment.summary = model.content;
    attachment.url = model.url;
    attachment.icon = UIImageJPEGRepresentation(model.image, 1.0f);
    
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    req.attachment = attachment;
    
    [WWKApi sendReq:req];
}

- (BOOL)WXAppInstalled{
    
    return [WXApi isWXAppInstalled];
}

- (void)WXAuth{
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.state = @"wx_oauth_authorization_state";
    req.scope = @"snsapi_userinfo";
    [WXApi sendReq:req completion:nil];
}

- (void)WXShare:(WebShareModel *)model{
    
    //创建多媒体消息结构体
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = model.title;
    urlMessage.description = model.content;
    [urlMessage setThumbImage:model.image];

    //创建网页数据对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = model.url;
    urlMessage.mediaObject = webObj;

    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.message = urlMessage;
    sendReq.scene = WXSceneSession;//分享到好友会话

    [WXApi sendReq:sendReq completion:nil];
}

- (BOOL)handleOpenURL:(NSURL *)url{
    
    if([url.scheme isEqualToString:WX_AppID]){
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    if([url.scheme isEqualToString:WW_AppID]){
        
        return [WWKApi handleOpenURL:url delegate:self];
    }
    
    return NO;
}

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity{
    
    if([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]){

        if([userActivity.webpageURL.absoluteString containsString:WX_UniversalLink]){
            
            return [WXApi handleOpenUniversalLink:userActivity delegate:self];
        }else{
            
            return NO;
        }
    }
    
    return NO;
}

//注意：“微信” 和 “企业微信” 走的回调方法是同一个
- (void)onResp:(id)resp{

    //这里注意判断resp类型来区别分享来源
    
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        
        DebugLog(@"微信分享");
        
        SendMessageToWXResp *rep = (SendMessageToWXResp *)resp;

        if(rep.errCode == WXSuccess){//目前分享回调只会走成功
            
            DebugLog(@"分享成功");
        }
    }else if([resp isKindOfClass:[SendAuthResp class]]){//判断是否为授权登录类

        DebugLog(@"微信登录");
        
        SendAuthResp *rep = (SendAuthResp *)resp;
        
        DebugLog(@"state：%@", rep.state);
        
        if([rep.state isEqualToString:@"wx_oauth_authorization_state"]){
            
            [self showAlert:@"授权登录" message:[NSString stringWithFormat:@"code=%@", rep.code]];
        }
    }else if([resp isKindOfClass:[WWKSSOResp class]]){
        
        DebugLog(@"企业微信登录");
        
        WWKSSOResp *rep = (WWKSSOResp *)resp;
        
        DebugLog(@"state：%@", rep.state);
        
        if([rep.state isEqualToString:@"ww_oauth_authorization_state"]){
            
            [self showAlert:@"授权登录" message:[NSString stringWithFormat:@"code=%@", rep.code]];
        }
    }else if([resp isKindOfClass:[WWKSendMessageResp class]]){
        
        DebugLog(@"企业微信分享");
        
        WWKSendMessageResp *rep = (WWKSendMessageResp *)resp;
        
        if(rep.errCode == WWKBaseRespErrCodeOK){
            
            DebugLog(@"分享成功");
        }
    }
}

- (void)onReq:(id)req {
    
    
}

- (void)showAlert:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert.title = title;
    alert.message = message;
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end

@implementation  WebShareModel

@end

@implementation  BaseShareModel

@end


