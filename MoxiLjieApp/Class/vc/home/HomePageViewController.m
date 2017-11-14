//
//  HomePageViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "HomePageViewController.h"
//#import "HomeViewController.h"
#import "SliderNavBar.h"
#import "HomeViewModel.h"

#import "MainViewController.h"
#import "SearchViewController.h"
#import "PlayViewController.h"

@interface HomePageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
    SliderNavBar *_navbar;//类型滑动控件
}

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *pageArr;//子VC数组
@property (nonatomic, assign) NSInteger currentIndex;//当前页面index

@property (nonatomic, strong) HomeViewModel *viewmodel;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[HomeViewModel alloc] init];
}

#pragma mark - 跳转
- (void)goSearchVC {
    SearchViewController *search = [[SearchViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - UIPageViewControllerDelegate & UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.pageArr indexOfObject:viewController];
    index --;
    if ((index < 0) || (index == NSNotFound)) {
        return nil;
    }
    return self.pageArr[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.pageArr indexOfObject:viewController];
    index ++;
    if (index >= self.pageArr.count) {
        return nil;
    }
    return self.pageArr[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        MainViewController *vc = pageViewController.viewControllers.firstObject;
        NSInteger index = [self.pageArr indexOfObject:vc];
        [_navbar moveToIndex:index];
        
        self.currentIndex = index;
    }
}

#pragma mark - UI
- (void)initUIView {
    self.navigationItem.title = NSLocalizedString(@"音乐", nil);
    [self setupSlider];
    [self setNav];
    [self initPage];
}

- (void)setupSlider {
    _navbar = [[SliderNavBar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
    _navbar.buttonTitleArr = [NSArray arrayWithArray:[self.viewmodel.navDic objectForKey:@"title"]];
    _navbar.mode = BottomLineModeEqualBtn;
    _navbar.fontSize = 14;
    _navbar.selectedColor = MyColor;
    _navbar.unSelectedColor = [UIColor grayColor];
    _navbar.bottomLineColor = MyColor;
    _navbar.canScrollOrTap = YES;
    [self.view addSubview:_navbar];
}

- (void)setNav {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    
    UIImage *rightImg = [UIImage imageNamed:@"search"];
    
    rightImg = [rightImg imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    
    [rightBtn setImage:rightImg forState:UIControlStateNormal];
    [rightBtn setTintColor:FontColor];
    
    [rightBtn addTarget:self action:@selector(goSearchVC) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)initPage {
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    _pageArr = [NSMutableArray array];
    
    NSArray *typeArr = [NSArray arrayWithArray:[self.viewmodel.navDic objectForKey:@"type"]];
    for (NSString *type in typeArr) {
        MainViewController *main = [[MainViewController alloc] init];
        main.type = [type integerValue];
        [_pageArr addObject:main];
    }
    
    [_pageViewController setViewControllers:[NSArray arrayWithObject:_pageArr[self.currentIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    _pageViewController.view.frame = CGRectMake(0, 44, Screen_Width, Screen_Height - 44);
    
    __weak typeof (_pageViewController)weakPageViewController = _pageViewController;
    __weak typeof (_pageArr)weakPageArr = _pageArr;
    @weakSelf(self);
    [_navbar setNavBarTapBlock:^(NSInteger index, UIPageViewControllerNavigationDirection direction) {
        [weakPageViewController setViewControllers:[NSArray arrayWithObject:weakPageArr[index]] direction:direction animated:YES completion:nil];
        weakSelf.currentIndex = index;
    }];
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_navbar moveToIndex:self.currentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
