//
//  LKHotViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/24.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKHotViewController.h"
#import "LKHotLiveTableViewCell.h"
#import "LKPlayerViewController.h"

static NSString * const LiveCellID = @"HotLiveCell";

@interface LKHotViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation LKHotViewController

#pragma mark - LazyLoad

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorBackGroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除系统线条
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"LKHotLiveTableViewCell" bundle:nil] forCellReuseIdentifier:LiveCellID];
    }
    return _tableView;
}

#pragma mark - Events

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorBackGroundColor];
    
    [self setUptable];
    [self loadLives];
}


- (void)setUptable {
    
    [self.view addSubview:self.tableView];
}


#pragma mark - NetWorking

//获取热门直播数据
- (void)loadLives {

    [LKLiveHandler executeGetHotLiveTaskWithSuccess:^(id obj) {
        
        [self.dataSource addObjectsFromArray:obj];
        [self.tableView  reloadData];
        
    } failed:^(id obj) {
        
        [XDProgressHUD showHUDWithText:@"请求失败" hideDelay:1.0];
    }];
}


#pragma mark - UITableViewDataSource Or UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LKHotLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LiveCellID];
    cell.backgroundColor = [UIColor colorBackGroundWhiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataSource.count > indexPath.row) {
        
        cell.model = self.dataSource[indexPath.row];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSource.count > indexPath.row) {
        
        //获取直播的源
        LKLiveModel *model = self.dataSource[indexPath.row];
        [self toPlayerWithModel:model];
    }
}

- (void)toPlayerWithModel:(LKLiveModel *)model {
    if (!model) return;
    
    LKPlayerViewController *playerVC = [[LKPlayerViewController alloc] init];
    playerVC.model = model;
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0 + SCREEN_WIDTH;
}

/*
 注意：系统自带的播放器实现不了直播视频播放
- (void)systemPlayWithURL:(NSString *)url {
    if (!url || url.length<=0) return;
    
    MPMoviePlayerViewController *movieVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];
    [self presentViewController:movieVC animated:YES completion:NULL];
}
 */



@end