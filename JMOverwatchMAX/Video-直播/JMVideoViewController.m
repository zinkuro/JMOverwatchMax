//
//  JMVideoViewController.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/11.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMVideoViewController.h"
#import "JMLiveTableViewCell.h"
#import "JMLiveModel.h"
#import "JMInfoModel.h"
//#import "JMPlayerViewController.h"
#import "KxMovieViewController.h"

@interface JMVideoViewController ()<UITableViewDelegate,UITableViewDataSource> {
    BOOL _isMore;
}

@property (nonatomic,strong) NSString *videoStr;
@property (nonatomic,strong) UITableView *liveTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

//@property (nonatomic,strong) NSString *requestVideoUrl;
//@property (nonatomic,strong) NSString *finalUrl;

@end

@implementation JMVideoViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)liveTableView {
    if (!_liveTableView) {
        _liveTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 49) style:UITableViewStylePlain];
    }
    return _liveTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isMore = NO;
    [self creatUI];
    [self creatRefresh];
    [self.liveTableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)creatUI {
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.liveTableView.delegate = self;
    self.liveTableView.dataSource = self;
    self.liveTableView.rowHeight = self.view.width * 15 / 32;
    self.liveTableView.sectionHeaderHeight = 0;
    
    [self.liveTableView registerNib:[UINib nibWithNibName:@"JMLiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"iden"];
    [self.view addSubview:self.liveTableView];

}

- (void)creatRefresh {
    self.liveTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewNews)];
    self.liveTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNews)];
    //self.newsTableView.mj_footer.hidden = YES;
}


- (void)loadNewNews {
    NSInteger limit = 30;
    NSInteger offset = 0;
    [self requestVideoWithLimit:limit Offset:offset];
    [self.liveTableView.mj_header endRefreshing];
}

- (void)loadMoreNews {
    _isMore = YES;
    NSInteger limit = 30;
    NSInteger offset = (self.dataArray.count / limit + 1) * limit;
    [self requestVideoWithLimit:limit Offset:offset];
    [self.liveTableView.mj_footer endRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iden" forIndexPath:indexPath];
    JMLiveModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestVideoWithLimit:(NSInteger)limit
                       Offset:(NSInteger)offset {
//    __weak typeof(self) weakself = self;
    NSString *requestStr = [NSString stringWithFormat:@"http://api.maxjia.com:80/api/live/list/?lang=zh-cn&os_type=iOS&game_type=ow&limit=%ld&offset=%ld",limit,offset];
    [self.requestManager GET:requestStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        [SVProgressHUD showWithStatus:@"加载中"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *liveResult = responseObject[@"result"];
        NSArray *liveArray = [NSArray yy_modelArrayWithClass:[JMLiveModel class] json:liveResult];
        NSLog(@"%@",responseObject);
        if (self.dataArray.count > 0 && !_isMore) {
            [self.dataArray removeAllObjects];
        }else {
            if (_isMore) {
                _isMore = NO;
            }
        }
        if (liveArray.count == 0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多数据"];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        }

        [self.dataArray addObjectsFromArray:liveArray];
        [self.liveTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMLiveModel *model = self.dataArray[indexPath.row];
    if ([model.live_name isEqualToString:@"douyu"]) {
        [self requestDouyuWithUrl:model.url_info.url];
    }else if ([model.live_name isEqualToString:@"quanmin"]) {
        NSString *requestVideoUrl = [NSString stringWithFormat:@"http://api.maxjia.com:80/api/live/detail/?live_type=quanmin&live_id=%@&lang=zh-cn&os_type=iOS&game_type=ow",model.live_id];
        [self requestQuanminWithUrl:requestVideoUrl];
    }
    else {
        [SVProgressHUD showWithStatus:@"目前暂不支持该直播"];
        [SVProgressHUD dismiss];
    }
    
}





- (void)requestDouyuWithUrl:(NSString *)requestVideoUrl {
    [self.requestManager GET:requestVideoUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        [SVProgressHUD showSuccessWithStatus:@"地址读取中"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *finalVideoUrl = responseObject[@"data"][@"hls_url"];
        [SVProgressHUD showSuccessWithStatus:@"地址读取成功!"];
        [self playVideoWithUrl:finalVideoUrl];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-/-/--/--/-%@",error);
    }];
}

- (void)requestQuanminWithUrl:(NSString *)requestVideoUrl {
    [self.requestManager GET:requestVideoUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Quanmining..");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *finalVideoUrl = responseObject[@"result"][@"stream_list"][0][@"url"];
        [self playVideoWithUrl:finalVideoUrl];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"quanminError:%@",error);
    }];
}


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


//- (void)requestYouku {
//    [self.requestManager GET:@"http://api.maxjia.com:80/api/video/list/?lang=zh-cn&os_type=iOS&game_type=ow&dm_uid=hot_all&limit=30&offset=0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"a");
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error:%@",error);
//    }];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
