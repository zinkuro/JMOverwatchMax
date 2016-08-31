//
//  JMBasicViewController.h
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/11.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
@interface JMBasicViewController : UIViewController

@property (nonatomic,strong) NSString *requestUrl;
@property (nonatomic,strong) AFHTTPSessionManager *requestManager;

@end
