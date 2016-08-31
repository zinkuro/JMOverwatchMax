//
//  JMBasicViewController.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/11.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMBasicViewController.h"
#import "MenuView.h"
#import "JMLeftMenuView.h"

@interface JMBasicViewController ()

@end

@implementation JMBasicViewController

- (AFHTTPSessionManager *)requestManager {
    if (!_requestManager) {
        _requestManager = [AFHTTPSessionManager manager];
        _requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _requestManager.responseSerializer.acceptableContentTypes = [_requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    return _requestManager;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithR:245 G:111 B:34]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
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
