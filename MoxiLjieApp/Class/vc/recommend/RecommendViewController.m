//
//  RecommendViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendCell.h"
#import "RecommendViewModel.h"
#import "PlayViewController.h"
#import "SearchViewController.h"

@interface RecommendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, RefreshCollectionViewDelegate>

@property (nonatomic, strong) LLRefreshCollectionView *recommendCollection;

@property (nonatomic, strong) RecommendViewModel *viewmodel;

@property (nonatomic, assign) BOOL hasData;

@end

@implementation RecommendViewController

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
    self.viewmodel = [[RecommendViewModel alloc] init];
}


- (void)loadDataRefresh:(BOOL)isRefresh {
    @weakSelf(self);
    [self showWaiting];
    [self.viewmodel getRecommandSongListWithRefresh:isRefresh success:^(BOOL result) {
        [weakSelf hideWaiting];
        
        if (weakSelf.viewmodel.recommendList.count) {
            [weakSelf.recommendCollection dismissNoView];
        } else {
            [weakSelf.recommendCollection showNoView:@"没有数据，刷新试试吧" image:nil certer:CGPointZero];
        }
        
        [weakSelf.recommendCollection reloadData];
        if (weakSelf.viewmodel.recommendList.count>= 10) {
            weakSelf.recommendCollection.isShowMore = YES;
        }
        weakSelf.hasData = YES;
        
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        weakSelf.hasData = NO;
        [weakSelf showMassage:error];
    }];
}

#pragma mark - search
- (void)goSearch {
    SearchViewController *search = [[SearchViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
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
    return self.viewmodel.recommendList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCell" forIndexPath:indexPath];
    if (self.viewmodel.recommendList.count) {
        [cell setDataWithModel:self.viewmodel.recommendList[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Song *model = self.viewmodel.recommendList[indexPath.row];
    [self gotoPlayVCWithSongId:model.song_id];
    
//    ProductDetailViewController *detail = [[ProductDetailViewController alloc] init];
//    detail.hidesBottomBarWhenPushed = YES;
//    Danpin *model = self.viewmodel.productList[indexPath.row];
//    detail.productId = model.newid;
//    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UI
- (void)initUIView {
    self.navigationItem.title = NSLocalizedString(@"推荐", nil);
//    [self setBackButton:YES];
    [self setCollectionviewLayout];
    [self setNav];
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    flow.minimumLineSpacing = 10;
    flow.minimumInteritemSpacing = 10;
    
    flow.itemSize = CGSizeMake((Screen_Width-10)/2, (Screen_Width-10)/2+25);
    
    self.recommendCollection = [[LLRefreshCollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-49-64) collectionViewLayout:flow];
    self.recommendCollection.backgroundColor = [UIColor clearColor];
    self.recommendCollection.delegate = self;
    self.recommendCollection.dataSource = self;
    
    self.recommendCollection.refreshCDelegate = self;
    self.recommendCollection.CanRefresh = YES;
    self.recommendCollection.isShowMore = NO;
    self.recommendCollection.lastUpdateKey = NSStringFromClass([self class]);
    
    self.recommendCollection.showsHorizontalScrollIndicator = NO;
    self.recommendCollection.showsVerticalScrollIndicator = NO;
    [self.recommendCollection registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellWithReuseIdentifier:@"RecommendCell"];
    [self.view addSubview:self.recommendCollection];
}

- (void)setNav {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    
    UIImage *rightImg = [UIImage imageNamed:@"search"];
    
    rightImg = [rightImg imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    
    [rightBtn setImage:rightImg forState:UIControlStateNormal];
    [rightBtn setTintColor:FontColor];
    
    [rightBtn addTarget:self action:@selector(goSearch) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    
    UIImage *leftImg = [UIImage imageNamed:@"single"];
    
    leftImg = [leftImg imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    
    [leftBtn setImage:leftImg forState:UIControlStateNormal];
    [leftBtn setTintColor:FontColor];
    
    [leftBtn addTarget:self action:@selector(gotoPlayVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self addNavigationWithTitle:nil leftItem:leftItem rightItem:rightItem titleView:nil];
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
