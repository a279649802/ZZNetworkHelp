//
//  ViewController.m
//  AFN二次封装
//
//  Created by 久其智通 on 2018/6/20.
//  Copyright © 2018年 jiuqizhitong. All rights reserved.
//

#import "ViewController.h"
#import "ZZNetworkHelp.h"

static NSString *const dataUrl = @"http://www.qinto.com/wap/index.php?ctl=article_cate&act=api_app_getarticle_cate&num=1&p=7";
static NSString *const downloadUrl = @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clickGet:(id)sender {
    [ZZNetworkHelp GET:dataUrl parameters:nil responseCache:nil success:^(id responseObject) {
        NSLog(@"成功");
    } failure:^(NSError *error) {
        NSLog(@"。。");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
