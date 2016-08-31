//
//  JMContainerViewController.h
//  JMContainerViewControllerTest
//
//  Created by Jin on 16/7/1.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMContainerViewControllerDelegate <NSObject>

- (void)containerViewItemIndex:(NSInteger)index
             currentController:(UIViewController *)controller;

@end

@interface JMContainerViewController : UIViewController

@property (nonatomic,weak) id<JMContainerViewControllerDelegate> delegate;

@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong,readonly) NSMutableArray *titles;
@property (nonatomic,strong,readonly) NSMutableArray *childControllers;

@property (nonatomic,strong) UIFont *menuItemFont;
@property (nonatomic,strong) UIColor *menuItemTitleColor;
@property (nonatomic,strong) UIColor *menuItemSelectedTitleColor;

@property (nonatomic,strong) UIColor *menuBackGroudColor;
@property (nonatomic,strong) UIColor *menuIndicatorColor;

- (instancetype)initWithControllers:(NSArray *)controllers
                       topBarHeight:(CGFloat)topBarHeight
                parentViewController:(UIViewController *)parentViewController;

@end
