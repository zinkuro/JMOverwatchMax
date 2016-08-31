//
//  JMNewsViewController.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/11.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMNewsViewController.h"
#import "JMNewsTableViewCell.h"
#import "JMNewsModel.h"
#import "JMNewsDetailViewController.h"
#import "HcdGuideView.h"
#import "JMLeftMenuView.h"
#import "MenuView.h"

#define WIDTH [[UIScreen mainScreen]bounds].size.width
#define HEIGHT [[UIScreen mainScreen]bounds].size.height
@interface JMNewsViewController ()<UITableViewDelegate,UITableViewDataSource,HomeMenuViewDelegate>

 {
    BOOL _isMore;
}
@property (nonatomic,strong) JMLeftMenuView *leftView;
@property (nonatomic,strong) MenuView *menu;

@property (nonatomic,strong) UITableView *newsTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation JMNewsViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.requestUrl = @"http://news.maxjia.com:80/maxnews/app/list/?lang=zh-cn&game_type=ow&limit=30&offset=0";
    }
    return self;
}

- (UITableView *)newsTableView {
    if (!_newsTableView) {
        _newsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 49) style:UITableViewStylePlain];
    }
    return _newsTableView;
}

- (void)requestDataWithLimit:(NSInteger)limit
                      Offset:(NSInteger)offset {
    NSString *requestStr = [NSString stringWithFormat:@"http://news.maxjia.com:80/maxnews/app/list/?lang=zh-cn&game_type=ow&limit=%ld&offset=%ld",limit,offset];
    [self.requestManager GET:requestStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        [SVProgressHUD showWithStatus:@"加载中"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *newsResult = responseObject[@"result"];
        NSArray *newsArray = [NSArray yy_modelArrayWithClass:[JMNewsModel class] json:newsResult];
        if (self.dataArray.count > 0 && !_isMore) {
            [self.dataArray removeAllObjects];
        }else {
            if (_isMore) {
                _isMore = NO;
            }
        }
        if (newsArray.count == 0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多数据"];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        }
        [self.dataArray addObjectsFromArray:newsArray];
        [self.newsTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menu = [[MenuView alloc]initWithDependencyView:self.view MenuView:self.leftView isShowCoverView:YES];
    [self creatNavButtonWithImage:@"btn_home_normal" selectedImage:@"btn_home_normal" isRight:NO];
    NSMutableArray *images = [NSMutableArray new];
    
    [images addObject:[UIImage imageNamed:@"启动0.jpg"]];
    [images addObject:[UIImage imageNamed:@"启动1.jpg"]];
    [images addObject:[UIImage imageNamed:@"启动2.jpg"]];
    
    [[HcdGuideViewManager sharedInstance] showGuideViewWithImages:images
                                                   andButtonTitle:@"立即前往"
                                              andButtonTitleColor:[UIColor whiteColor]
                                                 andButtonBGColor:[UIColor clearColor]
                                             andButtonBorderColor:[UIColor whiteColor]];
    

    _isMore = NO;
    //[self requestDataWithLimit:30 Offset:0];
    [self creatUI];
    [self creatRefresh];
    [self.newsTableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

-(void)LeftMenuViewClick:(NSInteger)tag{
    [self.menu hidenWithAnimation];
    
    NSLog(@"tag = %lu",tag);
    
    if (tag == 5) {
        NSLog(@"a");
    }
    
}


- (void)creatNavButtonWithImage:(NSString *)image
                  selectedImage:(NSString *)selectedImage
                        isRight:(BOOL)isRight {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:self action:@selector(leftMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (isRight) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
}

- (JMLeftMenuView *)leftView {
    if (!_leftView) {
        _leftView = [[JMLeftMenuView alloc]initWithFrame:CGRectMake(0, 0, WIDTH * 0.8, HEIGHT)];
        _leftView.customDelegate = self;
    }
    return _leftView;
}

- (void)leftMenuClicked:(id)sender {
    [self.menu show];
}


- (void)creatUI {
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
//    self.newsTableView.rowHeight = self.view.width * 9 / 32;
    self.newsTableView.sectionHeaderHeight = 0;
    
//    [self.newsTableView registerNib:[UINib nibWithNibName:@"JMNewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.newsTableView];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithR:0 G:0 B:0 alpha:.5]];
    [SVProgressHUD setMinimumDismissTimeInterval:.5];
    [SVProgressHUD showWithStatus:@"加载中"];
}

- (void)creatRefresh {
    self.newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewNews)];
    self.newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNews)];
    //self.newsTableView.mj_footer.hidden = YES;
}

- (void)loadNewNews {
    NSInteger limit = 30;
    NSInteger offset = 0;
    [self requestDataWithLimit:limit Offset:offset];
    [self.newsTableView.mj_header endRefreshing];
}

- (void)loadMoreNews {
    _isMore = YES;
    NSInteger limit = 30;
    NSInteger offset = (self.dataArray.count / limit + 1) * limit;
    [self requestDataWithLimit:limit Offset:offset];
    [self.newsTableView.mj_footer endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JMNewsModel *model = [[JMNewsModel alloc]init];
    model = self.dataArray[indexPath.row];
    JMNewsTableViewCell *cell = [[JMNewsTableViewCell alloc]init];
    if (model.img_type == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"iden"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"JMNewsTableViewCell" owner:nil options:nil]objectAtIndex:1];
        }

    }else if (model.img_type == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"JMNewsTableViewCell" owner:nil options:nil]objectAtIndex:0];
        }
    }

    NSLog(@"%ld",model.img_type);
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMNewsModel *model = [[JMNewsModel alloc]init];
    model = self.dataArray[indexPath.row];
    if (model.img_type == 2) {
        return self.view.width * 9 / 16;
    }else {
        return self.view.width * 9 / 32;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMNewsModel *model = [[JMNewsModel alloc]init];
    model = self.dataArray[indexPath.row];
    NSLog(@"%@",model.n_newUrl);
    JMNewsDetailViewController *detailView = [[JMNewsDetailViewController alloc]init];
    detailView.jumpUrl = model.n_newUrl;
    [self.navigationController pushViewController:detailView animated:YES];
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
