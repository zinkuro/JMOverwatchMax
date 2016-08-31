//
//  JMTabBarController.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/11.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMTabBarController.h"
#import "JMNewsViewController.h"
#import "JMStrategyViewController.h"
#import "JMVideoViewController.h"
#import "JMMoreViewController.h"
@interface JMTabBarController () <UITabBarControllerDelegate>

@property (nonatomic,strong) UIButton *button;

@end

@implementation JMTabBarController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [self creatChildControllerWithVc:[[JMNewsViewController alloc]init] Title:@"新闻资讯" image:@"btn_overwatch_normal" selectedImage:@""];
//    
//    [self creatChildControllerWithVc:[[JMStrategyViewController alloc]init] Title:@"数据攻略" image:@"btn_column_normal" selectedImage:@"btn_column_selected"];
//    
//    [self creatChildControllerWithVc:[[JMVideoViewController alloc]init] Title:@"直播视频" image:@"btn_live_normal" selectedImage:@"btn_live_selected"];
//    
//    [self creatChildControllerWithVc:[[JMMoreViewController alloc]init] Title:@"更多" image:@"btn_user_normal" selectedImage:@"btn_user_selected"];
//    
//}
//
//- (void)creatChildControllerWithVc:(UIViewController *)vc
//                             Title:(NSString *)title
//                             image:(NSString *)image
//                     selectedImage:(NSString *)selectedImage {
//    vc.tabBarItem.title = title;
//    vc.title = title;
//    vc.tabBarItem.image = [UIImage imageNamed:image];
//    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    
//    [self addChildViewController:nav];
//}
-(void)setup
{
    //  添加突出按钮
    [self addCenterButtonWithImage:[UIImage imageNamed:@"77"] selectedImage:[UIImage imageNamed:@""]];
    //  UITabBarControllerDelegate 指定为自己
    self.delegate=self;
    //  指定当前页——中间页
    //self.selectedIndex=0;
    //  设点button状态
    //button.selected=YES;
    //  设定其他item点击选中颜色
    
}

- (void) addCenterButtonWithImage:(UIImage*)buttonImage selectedImage:(UIImage*)selectedImage
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        
        
        _button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        [_button setImage:buttonImage forState:UIControlStateNormal];
        [_button setImage:selectedImage forState:UIControlStateSelected];
        
        _button.imageView.layer.masksToBounds = YES;
        _button.imageView.layer.cornerRadius = buttonImage.size.height / 2;
        
        
        _button.adjustsImageWhenHighlighted = NO;
        
        CGPoint center = self.tabBar.center;
        center.y = center.y - buttonImage.size.height / 4;
        _button.center = center;
        [self.view addSubview:_button];
    }

-(void)btnClicked:(id)sender
{
    self.selectedIndex = 1;
    _button.selected = YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.selectedIndex == 1) {
        _button.selected = YES;
    }else
    {
        _button.selected = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarVC];
    [self setup];
    [self addButtonNotifation];
    self.tabBar.barTintColor = [UIColor whiteColor];
}

- (void)addButtonNotifation {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonHidden) name:@"buttonNotifationCenter" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonNotHidden) name:@"buttonNotHidden" object:nil];
}

- (void)buttonNotHidden{
    _button.hidden = NO;
}
- (void)buttonHidden {
    _button.hidden = YES;
}
// 初始化所有子控制器
- (void)setTabBarVC{
    [self setTabBarChildController:[[JMNewsViewController alloc] init] title:@"新闻资讯" image:@"btn_column_normal" selectImage:@"btn_column_selected"];
    
    [self setTabBarChildController:[[JMStrategyViewController alloc] init] title:@"游戏攻略" image:@"" selectImage:@""];
    
    [self setTabBarChildController:[[JMVideoViewController alloc] init] title:@"直播视频" image:@"btn_live_normal" selectImage:@"btn_live_selected"];
}


// 添加tabbar的子viewcontroller
- (void)setTabBarChildController:(UIViewController*)controller title:(NSString*)title image:(NSString*)imageStr selectImage:(NSString*)selectImageStr{
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.tabBarItem.title = title;
    controller.title = title;
    nav.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithR:74 G:74 B:74]} forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithR:245 G:111 B:34]} forState:UIControlStateSelected];
    
    [self addChildViewController:nav];
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
