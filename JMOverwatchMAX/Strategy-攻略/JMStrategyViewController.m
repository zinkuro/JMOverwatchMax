//
//  JMStrategyViewController.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/11.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMStrategyViewController.h"
#import "JMHeroViewController.h"
@interface JMStrategyViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) JMHeroViewController *heroVC;

@end

@implementation JMStrategyViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    JMHeroViewController *heroVC = [[JMHeroViewController alloc]init];
    [self.navigationController pushViewController:heroVC animated:YES];
}

- (void)viewDidLoad {
    
    UIImageView *heroesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 32, (self.view.width - 32), (self.view.width - 32) * 9 / 16)];
    heroesImageView.image = [UIImage imageNamed:@"heroes"];
    [self.view addSubview:heroesImageView];
    UILabel *heroesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width / 4, 60)];
    heroesLabel.text = @" 英雄资料库 ";
    heroesLabel.font = [UIFont boldSystemFontOfSize:17];
    heroesLabel.textColor = [UIColor whiteColor];
    heroesLabel.adjustsFontSizeToFitWidth = YES;
    heroesLabel.backgroundColor = [UIColor colorWithR:245 G:111 B:34];
    heroesLabel.layer.cornerRadius = 4;
    heroesLabel.layer.masksToBounds = YES;
    [self.view addSubview:heroesLabel];
    
    [heroesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(heroesImageView.mas_bottom).offset(16);
        make.centerX.equalTo(heroesImageView);
    }];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = item;
    [super viewDidLoad];
    
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
