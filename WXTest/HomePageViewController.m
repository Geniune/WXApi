//
//  HomePageViewController.m
//  WXTest
//
//  Created by Apple on 2020/5/18.
//  Copyright © 2020 Geniune. All rights reserved.
//

#import "HomePageViewController.h"
#import "OpenManager.h"

@interface HomePageViewController ()

@property (nonatomic, strong) WebShareModel *media_model;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //注意：
    //由于微信登录只提供了原生登录方式，根据审核指南中的相关规定，建议在初始化页面时检查当前设备是否已安装对应客户端应用
    //若当前设备未安装客户端，则需要将对应UI交互入口隐藏，避免后期打包提交审核时被拒绝
    
    //判断当前设备是否已安装微信客户端
    if([OPENSDKMANAGER WXAppInstalled]){

        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 150, 38)];
        [btn1 setTitle:@"微信登录" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(wxAuthAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn1];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 150, 38)];
        [btn2 setTitle:@"微信分享" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(wxShareAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn2];
        
    }else{
        
        DebugLog(@"当前设备还未安装微信客户端或版本过低");
    }
    
    //判断当前设备是否已安装企业微信客户端
    if([OPENSDKMANAGER WWAppInstalled]){

        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 150, 38)];
        [btn3 setTitle:@"企业微信登录" forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(wwAuthAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn3];
        
        UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(50, 250, 150, 38)];
        [btn4 setTitle:@"企业微信分享" forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn4 addTarget:self action:@selector(wwShareAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn4];
        
    }else{
        
        DebugLog(@"当前设备还未安装企业微信客户端或版本过低");
    }

}

#pragma mark - 微信授权登录Action
- (void)wxAuthAction:(id)sender{
    
    [OPENSDKMANAGER WXAuth];
}

#pragma mark - 微信分享Action
- (void)wxShareAction:(id)sender{

    [OPENSDKMANAGER WXShare:self.media_model];
}

#pragma mark - 企业微信授权登录Action
- (void)wwAuthAction:(id)sender{
    
    [OPENSDKMANAGER WWAuth];
}

#pragma mark - 企业微信分享Action
- (void)wwShareAction:(id)sender{

    [OPENSDKMANAGER WWShare:self.media_model];
}

#pragma mark - 分享媒体Model 懒加载
- (WebShareModel *)media_model{
    
    if(!_media_model){
        
        _media_model = [WebShareModel new];
        _media_model.title = @"16英寸MacBook Pro今年下半年发布";
        _media_model.content = @"据分析师郭明錤称，苹果正计划重新设计 14 英寸和 16 英寸的 MacBook Pro 机型，并将于 2021 年下半年发布";
        _media_model.image = [UIImage imageNamed:@"chatu_login"];
        _media_model.url = @"https://www.feng.com/post/13320156";
    }
    
    return _media_model;
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
