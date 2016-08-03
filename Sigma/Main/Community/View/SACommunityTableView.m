//
//  SACommunityTableView.m
//  Sigma
//
//  Created by 汤轶侬 on 16/7/20.
//  Copyright © 2016年 Terence. All rights reserved.
//

#import "SACommunityTableView.h"
#import "SACommunityUserModel.h"
#import "SADynamicModel.h"
#import "SACommunityTableHeaderView.h"
#import "SACommunityTableFooterView.h"
#import "SADynamicFrameModel.h"
#import "SADynamicTableViewCell.h"
#import "SAHeaderLoadingView.h"
#import "SAFooterLoadingView.h"
#import "SACommunityRequest.h"



@interface SACommunityTableView() <UITableViewDataSource, UITableViewDelegate, SADynamicTableViewCellDelegate>

@property (nonatomic, strong) SACommunityTableHeaderView *headerView;

@property (nonatomic, strong) SACommunityTableFooterView *footerView;

@property (nonatomic, strong) NSDictionary* userDict; // 头部用户数据

@property (nonatomic, strong) NSMutableArray* dynamicArray; // 动态内容数据

@property (nonatomic, assign) NSTimeInterval time; // 存储请求时间点

@end

@implementation SACommunityTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];

    if (self) {
        self.tableHeaderView = self.headerView;
        self.tableFooterView = self.footerView;

        self.useHeaderLoading = YES;
        self.useFooterLoading = YES;

        self.dataSource = self;
        self.delegate = self;
    }

    return self;
}

- (void)setHeaderData:(NSDictionary *)dict {
    _userDict = dict;

    [self renderHeaderData];
}

- (void)setDynamicData:(NSArray *)dynamicArray {

    if (self.dynamicArray.count == 0) {
        // 添加数据
        for (int i = 0; i < dynamicArray.count; ++i) {
            SADynamicModel *dynamicModel = [SADynamicModel dynamicWithDict:dynamicArray[(NSUInteger)i]];
            SADynamicFrameModel *frameModel = [[SADynamicFrameModel alloc] init];
            frameModel.dynamicModel = dynamicModel;
            [self.dynamicArray addObject:frameModel];
        }
        SADynamicFrameModel *firstDynamicFrameModel = self.dynamicArray.firstObject;
        self.time = (NSTimeInterval)firstDynamicFrameModel.dynamicModel.publish_time;
        [self reloadData];
        return;
    }

    NSDictionary *firstNewDynamicModel = dynamicArray.firstObject;
    NSDictionary *lastNewDynamicModel = dynamicArray.lastObject;
    SADynamicFrameModel *firstDynamicFrameModel = self.dynamicArray.firstObject;

    if ([firstNewDynamicModel[@"publish_date"] intValue] > firstDynamicFrameModel.dynamicModel.publish_time) {
        // 上拉刷新数据
        self.time = (NSTimeInterval)[lastNewDynamicModel[@"publish_date"] intValue];
        // 添加数据
        for (int i = 0; i < dynamicArray.count; ++i) {
            SADynamicModel *dynamicModel = [SADynamicModel dynamicWithDict:dynamicArray[(NSUInteger)i]];
            SADynamicFrameModel *frameModel = [[SADynamicFrameModel alloc] init];
            frameModel.dynamicModel = dynamicModel;
            [self.dynamicArray insertObject:frameModel atIndex:0];
            [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        }
    } else {
        // 下拉加载
        self.time = (NSTimeInterval) firstDynamicFrameModel.dynamicModel.publish_time;
        // 添加数据
        for (int i = 0; i < dynamicArray.count; ++i) {
            SADynamicModel *dynamicModel = [SADynamicModel dynamicWithDict:dynamicArray[(NSUInteger) i]];
            SADynamicFrameModel *frameModel = [[SADynamicFrameModel alloc] init];
            frameModel.dynamicModel = dynamicModel;
            [self.dynamicArray addObject:frameModel];
            [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.dynamicArray.count-1) inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

// 构造模型，显示数据和布局
- (void)renderHeaderData {
    self.headerView.userModel = [SACommunityUserModel userModelWithDict:self.userDict];
}

- (NSMutableArray *)dynamicArray {
    if (!_dynamicArray) {
        _dynamicArray = [NSMutableArray array];
    }
    return _dynamicArray;
}

// headerView
- (SACommunityTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[SACommunityTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, COMMUNITY_HEADER_VIEW_HEIGHT)];
    }
    
    return _headerView;
}

- (SACommunityTableFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[SACommunityTableFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 0)];
    }

    return _footerView;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SADynamicFrameModel *frameModel = self.dynamicArray[(NSUInteger)indexPath.row];
    return [frameModel getTotalHeight];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dynamicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DynamicCell";

    SADynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[SADynamicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.frameModel = self.dynamicArray[(NSUInteger)indexPath.row];
    cell.delegate = self;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -
#pragma mark SALoadingTableViewDelegate
- (void)endHeaderLoadingAnimation:(SAHeaderLoadingView *)loadingView {
    // 加载最新数据
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    [SACommunityRequest requestDynamics:@{@"t": @(self.time), @"now": @(now)} user_id:28 token:@"b42754e673e94f5eaef972c4ae4a4c06"];
}

#pragma mark -
#pragma mark SALoadingTableViewDelegate
- (void)endFooterLoadingAnimation:(SAFooterLoadingView *)footerLoadingView {
    // 下拉加载更多数据
    [SACommunityRequest requestDynamics:@{@"t": @(self.time), @"c": @(self.dynamicArray.count)} user_id:28 token:@"b42754e673e94f5eaef972c4ae4a4c06"];
}

#pragma mark -
#pragma mark SADynamicTableViewCellDelegate
- (void)commentBtnDidClicked:(SADynamicTableViewCell *)tableViewCell{
    int dynamic_id = tableViewCell.frameModel.dynamicModel.dynamic_id;
    SADynamicModel *dynamicModel = tableViewCell.frameModel.dynamicModel;

    if ([self.ownDelegate respondsToSelector:@selector(commentBtnDidClicked:dynamicModel:)]) {
        [self.ownDelegate commentBtnDidClicked:dynamic_id dynamicModel:dynamicModel];
    }
}

@end
