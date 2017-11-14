//
//  HomeViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "HomeCell.h"
#import "PlayViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (nonatomic, strong) JJRefreshTabView *homeTable;
@property (nonatomic, strong) HomeViewModel *viewmodel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[HomeViewModel alloc] init];
    [self loadDataRefresh:YES];
}

- (void)loadDataRefresh:(BOOL)isRefresh {
//    @weakSelf(self);
//    [self showWaiting];
//    [self.viewmodel getHomeListWithHomeID:self.homeId refresh:isRefresh success:^(BOOL result) {
//        [weakSelf hideWaiting];
//        [weakSelf.homeTable reloadData];
//        if (weakSelf.viewmodel.homeList.count) {
//            weakSelf.homeTable.isShowMore = YES;
//        }
//        
//    } failture:^(NSString *error) {
//        [weakSelf hideWaiting];
//        [weakSelf showMassage:error];
//    }];
}

#pragma mark - refresh
- (void)refreshTableViewHeader {
    [self loadDataRefresh:YES];
}

- (void)refreshTableViewFooter {
    [self loadDataRefresh:NO];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
//    return self.viewmodel.homeList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [HomeCell myCellWithTableview:tableView];
//    [cell setDataWithModel:self.viewmodel.homeList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
//    [self initTitleViewWithTitle:NSLocalizedString(@"历史记录", nil)];
    
    [self setupTable];
}

- (void)setupTable {
    self.homeTable = [[JJRefreshTabView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-44-49) style:UITableViewStyleGrouped];
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    [self.view addSubview:self.homeTable];
    
    self.homeTable.backgroundColor = [UIColor clearColor];
    self.homeTable.tableFooterView = [UIView new];
    
    self.homeTable.refreshDelegate = self;
    self.homeTable.CanRefresh = YES;
    self.homeTable.lastUpdateKey = NSStringFromClass([self class]);
    self.homeTable.isShowMore = NO;
}


#pragma mark - dealloc
- (void)dealloc {
    [self.viewmodel cancelAllHTTPRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
