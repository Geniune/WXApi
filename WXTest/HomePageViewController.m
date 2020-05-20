//
//  HomePageViewController.m
//  WXTest
//
//  Created by Apple on 2020/5/18.
//  Copyright © 2020 Geniune. All rights reserved.
//

#import "HomePageViewController.h"
#import "WXApi.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 150, 38)];
    [btn1 setTitle:@"微信分享" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 150, 38)];
    [btn2 setTitle:@"微信登录" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(authAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)shareAction:(id)sender{
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 0;//0.好友列表 1.朋友圈 2.收藏
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = @"标题";//标题
    urlMessage.description = @"描述内容";//描述内容
    [urlMessage setThumbImage:[UIImage imageNamed:@"expert_placeholder"]];//设置图片
    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = @"https://www.baidu.com/";//URL链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送请求
     [WXApi sendReq:sendReq completion:^(BOOL success) {
         NSLog(@"唤起微信:%@", success ? @"成功" : @"失败");
     }];
}

- (void)authAction:(id)sender{
        
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
    req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
    
    //发送请求
    [WXApi sendReq:req completion:^(BOOL success) {
        NSLog(@"唤起微信:%@", success ? @"成功" : @"失败");
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
