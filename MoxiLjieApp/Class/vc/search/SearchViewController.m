//
//  SearchViewController.m
//  JJFS
//
//  Created by 王新宇 on 2017/3/3.
//  Copyright © 2017年 zhouqixin. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchViewModel.h"//搜索viewModel
#import "PlayViewController.h"//播放
#import "SearchAlbumCell.h"
#import "SearchArtistCell.h"
#import "ArtistViewController.h"

@interface SearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *searchTabView;
@property (strong, nonatomic) SearchViewModel *viewModel;

@end

@implementation SearchViewController {
    UISearchBar *_bar;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTabView.tableFooterView = [UIView new];
    [self addSearchBar];//设置搜索框
    [self initViewModel];//初始化
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItems = [self leftSearchBarButtonItems];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_bar becomeFirstResponder];//响应编辑状态
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_bar resignFirstResponder];
}

#pragma mark - 模型初始化 获取数据
- (void)initViewModel {
    self.viewModel = [[SearchViewModel alloc] init];
    
}

#pragma mark - 页面添加view
- (void)addSearchBar {//配置 searchBar
    _bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
    _bar.delegate = self;
    _bar.placeholder = @"搜索歌曲、歌手、专辑";
    [_bar setShowsCancelButton:YES];
    [self searchBarBasicConfig];//自定义searchBar
    self.navigationItem.titleView = _bar;
}

#pragma mark - uisearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {//点击search 请求数据
    [_bar resignFirstResponder];
    [self showWaiting];
    @weakSelf(self);
    [self.viewModel searchSongWithString:searchBar.text success:^(BOOL result) {
        [weakSelf hideWaiting];
        if (result) {
            if (weakSelf.viewModel.artistList.count || weakSelf.viewModel.songList.count) {
                [weakSelf.searchTabView dismissNoView];
            }
            if (!weakSelf.viewModel.artistList.count && !weakSelf.viewModel.songList.count) {
                [weakSelf.searchTabView showNoView:@"没有数据，刷新试试吧" image:nil certer:CGPointZero];
            }
            
            [weakSelf.searchTabView reloadData];
        } else {
            [weakSelf showMassage:@"暂无结果"];
        }
        
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [super goBack];
}

#pragma mark - uitableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!section) {
        return self.viewModel.songList.count;
    } else {
        return self.viewModel.artistList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 60;
    } else {
        return 65;
    }
}

static NSString *identifier = @"searchIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.textLabel.textColor = FontColor;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        if (self.viewModel.songList.count) {
            SearchSong *model = self.viewModel.songList[indexPath.row];
            cell.textLabel.attributedText = [LJUtil setMainColorForKeywords:_bar.text mainStr:model.songname];
            cell.detailTextLabel.attributedText = [LJUtil setMainColorForKeywords:_bar.text mainStr:model.artistname];
        }
        
        return cell;
    } else {
        SearchArtistCell *cell = [SearchArtistCell myCellWithTableview:tableView];
        if (self.viewModel.artistList.count) {
            [cell setDataWithModel:self.viewModel.artistList[indexPath.row] barText:_bar.text];
        }
        return cell;
    }
    
//    FundBase *model = self.viewModel.searchArray[indexPath.row];
//    NSString *totalTitle = [NSString stringWithFormat:@"%@  %@",model.fundId,model.fundName];
//    NSRange range = [totalTitle rangeOfString:_bar.text];
//    if (range.location != NSNotFound) {//搜索关键字 对应 返回名称 变为红色
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:totalTitle];
//        [attributeStr addAttribute:NSForegroundColorAttributeName value:MyColor range:NSMakeRange(range.location, range.length)];
//        cell.textLabel.attributedText = attributeStr;
//    }
    
//    return cell;
}

#pragma mark - uitableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
//        PlayViewController *
        SearchSong *model = self.viewModel.songList[indexPath.row];
        [self gotoPlayVCWithSongId:model.songid];
    } else {
        SearchArtist *model = self.viewModel.artistList[indexPath.row];
        [self gotoArtistVCWithTinguid:model.artistid];
    }
}

#pragma mark - uiscrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_bar resignFirstResponder];
}

#pragma mark - searchHotDelegate
- (void)resignEditing {
    [_bar resignFirstResponder];//页面滑动 取消编辑状态
}

#pragma mark - method
- (NSMutableAttributedString *)setMainColorForKeywords:(NSString *)keywords {
    NSRange range = [keywords rangeOfString:_bar.text];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:keywords];
    if (range.location != NSNotFound) {//搜索关键字 对应 返回名称 变为红色
        [attributeStr addAttribute:NSForegroundColorAttributeName value:MyColor range:NSMakeRange(range.location, range.length)];
//        return attributeStr;
    }
    return attributeStr;
}

//自定义searchBar
- (void)searchBarBasicConfig {
    UITextField *searchField = [_bar valueForKey:@"searchField"];
    searchField.layer.cornerRadius = 10;
    searchField.layer.masksToBounds = YES;
    UIButton*cancelButton = [_bar valueForKey:@"_cancelButton"];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    for (UIView *view in _bar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
}

//返回左边返回按钮 占据左边位置
- (NSArray<UIBarButtonItem *> *)leftSearchBarButtonItems {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    return @[nagetiveSpacer, backButton];
}

- (void)dealloc {
    [self.viewModel cancelAllHTTPRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
