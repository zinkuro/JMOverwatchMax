//
//  JMPlayerViewController.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/12.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMPlayerViewController.h"
//#import "KrVideoPlayerController.h"
#import "KxMovieViewController.h"

@interface JMPlayerViewController ()

//@property (nonatomic, strong) KrVideoPlayerController  *videoController;

@property (nonatomic, strong) NSString *finalVideoUrl;
@end

@implementation JMPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.liveType isEqualToString:@"douyu"]) {
        [self requestDouyu];
    }else if ([self.liveType isEqualToString:@"quanmin"]) {
        [self requestQuanmin];
    }
    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestDouyu {
    __weak typeof(self) weakself = self;
    [self.requestManager GET:self.requestVideoUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        [SVProgressHUD showSuccessWithStatus:@"地址读取中"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        weakself.finalVideoUrl = responseObject[@"data"][@"hls_url"];
        [SVProgressHUD showSuccessWithStatus:@"地址读取成功!"];
        [self playVideoWithUrl:weakself.finalVideoUrl];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-/-/--/--/-%@",error);
    }];
}

- (void)requestQuanmin {
    __weak typeof(self) weakself = self;
    NSLog(@"%@",self.requestVideoUrl);
    [self.requestManager GET:self.requestVideoUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Quanmining..");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        weakself.finalVideoUrl = responseObject[@"result"][@"stream_list"][0][@"url"];
        [self playVideoWithUrl:weakself.finalVideoUrl];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"quanminError:%@",error);
    }];
}


//- (void)requestPanda {
//    [self.requestManager GET:@"http://api.maxjia.com:80/api/live/detail/?live_type=panda&live_id=373162&lang=zh-cn&os_type=iOS&game_type=ow" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"videoDownloading");
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//}


//- (void)playVideo{
//    if (self.finalVideoUrl) {
//        NSLog(@"playerReady");
//        NSURL *url = [NSURL URLWithString:self.finalVideoUrl];
//        [self addVideoPlayerWithURL:url];
//    }
//    else {
//        NSLog(@"playerNotReady");
//    }
//}

- (void)playVideoWithUrl:(NSString *)finalUrl {
    NSString *path = finalUrl;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([path.pathExtension isEqualToString:@"wmv"]) {
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    }
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
                                                                               parameters:parameters];
    [self presentViewController:vc animated:YES completion:nil];
}
//
//- (void)addVideoPlayerWithURL:(NSURL *)url{
//    if (!self.videoController) {
//        CGFloat width = [UIScreen mainScreen].bounds.size.width;
//        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, width, width*(9.0/16.0))];
//        __weak typeof(self)weakSelf = self;
//        [self.videoController setDimissCompleteBlock:^{
//            weakSelf.videoController = nil;
//        }];
//        [self.videoController setWillBackOrientationPortrait:^{
//            [weakSelf toolbarHidden:NO];
//        }];
//        [self.videoController setWillChangeToFullscreenMode:^{
//            [weakSelf toolbarHidden:YES];
//        }];
//        [self.view addSubview:self.videoController.view];
//    }
//    self.videoController.contentURL = url;
//    
//}
//隐藏navigation tabbar 电池栏
//- (void)toolbarHidden:(BOOL)Bool{
//    self.navigationController.navigationBar.hidden = Bool;
//    self.tabBarController.tabBar.hidden = Bool;
//    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
//    if (Bool) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonNotifationCenter" object:nil];
//    }else {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonNotHidden" object:nil];
//    }
//    
//}


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
