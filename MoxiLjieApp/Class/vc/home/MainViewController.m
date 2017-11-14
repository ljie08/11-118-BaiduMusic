//
//  MainViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/25.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewModel.h"
#import "MainHomeCell.h"
#import "PlayViewController.h"

@interface MainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, RefreshCollectionViewDelegate>

@property (nonatomic, strong) LLRefreshCollectionView *mainCollection;
@property (nonatomic, strong) HomeViewModel *viewmodel;

@property (nonatomic, assign) BOOL hasData;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hasData = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.hasData) {
        [self loadDataRefresh:YES];
    }
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[HomeViewModel alloc] init];
//    [self loadDataRefresh:YES];
}

- (void)loadDataRefresh:(BOOL)isRefresh {
    @weakSelf(self);
    [self showWaiting];
    [self.viewmodel getSongListWithRefresh:isRefresh type:self.type success:^(BOOL result) {
        [weakSelf hideWaiting];
        
        if (weakSelf.viewmodel.homeList.count) {
            [weakSelf.mainCollection dismissNoView];
        } else {
            [weakSelf.mainCollection showNoView:@"没有数据，刷新试试吧" image:nil certer:CGPointZero];
        }
        
        [weakSelf.mainCollection reloadData];
        if (weakSelf.viewmodel.homeList.count>= 10) {
            weakSelf.mainCollection.isShowMore = YES;
        } else {
            weakSelf.mainCollection.isShowMore = NO;
        }
        weakSelf.hasData = YES;
        
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        weakSelf.hasData = NO;
        [weakSelf showMassage:error];
    }];
}

#pragma mark - refresh
- (void)refreshCollectionViewHeader {
    [self loadDataRefresh:YES];
}

- (void)refreshCollectionViewFooter {
    [self loadDataRefresh:NO];
}

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 10;
    return self.viewmodel.homeList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainHomeCell" forIndexPath:indexPath];
    if (self.viewmodel.homeList.count) {
        [cell setDataWithModel:self.viewmodel.homeList[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Song *song = self.viewmodel.homeList[indexPath.row];
    [self gotoPlayVCWithSongId:song.song_id];
}

#pragma mark - UI
- (void)initUIView {
    [self setCollectionviewLayout];
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    flow.minimumLineSpacing = 10;
    flow.minimumInteritemSpacing = 10;
    
    CGFloat width = (Screen_Width-40)/2;
    flow.itemSize = CGSizeMake(width, width+40);
    
    self.mainCollection = [[LLRefreshCollectionView alloc] initWithFrame:CGRectMake(15, 0, Screen_Width-30, Screen_Height-49-64-44) collectionViewLayout:flow];
    self.mainCollection.backgroundColor = [UIColor clearColor];
    self.mainCollection.delegate = self;
    self.mainCollection.dataSource = self;
    
    self.mainCollection.refreshCDelegate = self;
    self.mainCollection.CanRefresh = YES;
    self.mainCollection.isShowMore = NO;
    self.mainCollection.lastUpdateKey = NSStringFromClass([self class]);
    
    self.mainCollection.showsHorizontalScrollIndicator = NO;
    self.mainCollection.showsVerticalScrollIndicator = NO;
    [self.mainCollection registerNib:[UINib nibWithNibName:@"MainHomeCell" bundle:nil] forCellWithReuseIdentifier:@"MainHomeCell"];
    [self.view addSubview:self.mainCollection];
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
