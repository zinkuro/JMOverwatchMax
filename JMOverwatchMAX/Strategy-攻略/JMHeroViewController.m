//
//  JMHeroViewController.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/13.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMHeroViewController.h"

@interface JMHeroViewController () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation JMHeroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    //http://ow.17173.com/zt/yxk/index.html
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.webView.opaque = YES;
    self.webView.backgroundColor = [UIColor colorWithR:248 G:248 B:248];
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://ow.17173.com/zt/yxk/index.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    
    UIBarButtonItem *tempBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
//    tempBarButtonItem.title = @"返回";
//    tempBarButtonItem.target = self;
//    tempBarButtonItem.action = @selector(back:);
    self.navigationItem.leftBarButtonItem = tempBarButtonItem;
}

- (void)back:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
