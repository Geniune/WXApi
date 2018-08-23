//
//  ViewController.m
//  hongyantub2b
//
//  Created by Apple on 2018/8/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "WXAuth.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(70, 50, 85, 35.0f)];
    [btn setTitle:@"微信授权登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(sendAuth:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)sendAuth:(id)sender {
    
    [WXAUTH sendWXAuthReq];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
