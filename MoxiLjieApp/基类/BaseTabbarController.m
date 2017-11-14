//
//  BaseTabbarController.m
//  IOSFrame
//
//  Created by lijie on 2017/7/17.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "BaseTabbarController.h"
#import "BaseNavigationController.h"
#import "HomePageViewController.h"
#import "RecommendViewController.h"
#import "MeViewController.h"

@interface BaseTabbarController ()

@end

@implementation BaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"songid"];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    HomePageViewController *home = [[HomePageViewController alloc] init];
    [self setChildVCWithViewController:home title:NSLocalizedString(@"音乐", nil) image:[UIImage imageNamed:@"home"] selectedImg:nil];
    
    RecommendViewController *recommend = [[RecommendViewController alloc] init];
    [self setChildVCWithViewController:recommend title:NSLocalizedString(@"推荐", nil) image:[UIImage imageNamed:@"recommend"] selectedImg:nil];
    
    MeViewController *me = [[MeViewController alloc] init];
    [self setChildVCWithViewController:me title:NSLocalizedString(@"我", nil) image:[UIImage imageNamed:@"me"] selectedImg:nil];
}

- (void)setChildVCWithViewController:(UIViewController *)controller title:(NSString *)title image:(UIImage *)image selectedImg:(UIImage *)selectedImg {
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:controller];
    self.tabBar.tintColor = MyColor;

    nav.title = title;
    nav.tabBarItem.image = image;
    nav.tabBarItem.selectedImage = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}

#pragma mark - tabbar
- (void)presentPlayVC {
    
}



@end
