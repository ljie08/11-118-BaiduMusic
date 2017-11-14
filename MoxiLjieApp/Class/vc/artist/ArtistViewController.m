//
//  ArtistViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "ArtistViewController.h"
#import "ArtistViewModel.h"
#import "ArtistHeaderCell.h"
#import "ArtistMoreViewController.h"
#import "PlayViewController.h"

@interface ArtistViewController ()<UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (nonatomic, strong) JJRefreshTabView *artistTable;
@property (nonatomic, strong) ArtistViewModel *viewmodel;

@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[ArtistViewModel alloc] init];
    [self loadDataRefresh:YES];
}

- (void)loadDataRefresh:(BOOL)isRefresh {
    @weakSelf(self);
    [self showWaiting];
    [self.viewmodel getArtistDataWithID:self.tinguid success:^(BOOL result) {
         [weakSelf hideWaiting];
         [weakSelf.artistTable reloadData];
        
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];
    }];
    
    [self.viewmodel getSongListWithRefresh:isRefresh tingid:self.tinguid success:^(BOOL result) {
        [weakSelf hideWaiting];
        if (weakSelf.viewmodel.songList.count >= 10) {
            weakSelf.artistTable.isShowMore = YES;
        }
        if (weakSelf.viewmodel.songList.count) {
            [weakSelf.artistTable dismissNoView];
        } else {
            [weakSelf.artistTable showNoView:@"没有数据，刷新试试吧" image:nil certer:CGPointZero];
        }
        [weakSelf.artistTable reloadData];
        
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];
    }];
}

- (void)gotoMoreVC {
    ArtistMoreViewController *more = [[ArtistMoreViewController alloc] init];
    more.artist = self.viewmodel.artistInfo;
    [self.navigationController pushViewController:more animated:YES];
}

#pragma mark - refresh
- (void)refreshTableViewHeader {
    [self loadDataRefresh:YES];
}

- (void)refreshTableViewFooter {
    [self loadDataRefresh:NO];
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.viewmodel.songList.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        return 60;
    }
    return 185;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"list"];
        }
        cell.textLabel.textColor = FontColor;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        Song *model = self.viewmodel.songList[indexPath.row];
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = model.author;
        
        return cell;
    }
    
    ArtistHeaderCell *cell = [ArtistHeaderCell myCellWithTableview:tableView];
    [cell setDataWithModel:self.viewmodel.artistInfo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Song *model = self.viewmodel.songList[indexPath.row];
    
    PlayViewController *play = [PlayViewController shareSongPlay];
    [play setSongPlayWithID:model.song_id];
    play.hidesBottomBarWhenPushed = YES;
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController pushViewController:play animated:YES];
    
//    [self gotoPlayVCWithSongId:model.song_id];
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
    [self initTitleViewWithTitle:NSLocalizedString(@"歌手", nil)];
    
    [self setupTable];
    [self setNav];
}

- (void)setupTable {
    self.artistTable = [[JJRefreshTabView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64) style:UITableViewStyleGrouped];
    self.artistTable.delegate = self;
    self.artistTable.dataSource = self;
    
//    self.artistTable.estimatedSectionHeaderHeight = CGFLOAT_MIN;
//    self.artistTable.estimatedSectionFooterHeight = CGFLOAT_MIN;
    
    self.artistTable.estimatedSectionHeaderHeight = 0.f;
    self.artistTable.estimatedSectionFooterHeight = 0.f;
    if (@available(iOS 11.0, *)) {
        self.artistTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.artistTable];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.artistTable.backgroundColor = [UIColor clearColor];
    self.artistTable.tableFooterView = [UIView new];
    
    self.artistTable.refreshDelegate = self;
    self.artistTable.CanRefresh = YES;
    self.artistTable.lastUpdateKey = NSStringFromClass([self class]);
    self.artistTable.isShowMore = NO;
}

- (void)setNav {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 30);
    [rightBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(gotoMoreVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self addNavigationWithTitle:nil leftItem:nil rightItem:rightItem titleView:nil];
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
