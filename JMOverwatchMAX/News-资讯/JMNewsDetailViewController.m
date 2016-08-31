//
//  JMNewsDetailViewController.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/12.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMNewsDetailViewController.h"

@interface JMNewsDetailViewController () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation JMNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatWebView];
    // Do any additional setup after loading the view.
}

- (void)creatWebView {
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.webView.opaque = YES;
    self.webView.backgroundColor = [UIColor colorWithR:248 G:248 B:248];
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.jumpUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSLog(@"%@",request);
//    
//    NSURL *tryVideo = [NSURL URLWithString:@"http://v.youku.com/v_show/id_XMTY0MDgyMTE3Ng==.html"];
//    NSURLRequest *requestT = [NSURLRequest requestWithURL:tryVideo];
//    NSLog(@"%@",requestT);
    
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *IJs = @"document.documentElement.innerHTML";
    NSString *fHTML = [webView stringByEvaluatingJavaScriptFromString:IJs];
    NSLog(@"html:%@",fHTML);
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
