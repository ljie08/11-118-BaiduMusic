//
//  ArtistMoreViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/27.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "ArtistMoreViewController.h"

@interface ArtistMoreViewController ()

@end

@implementation ArtistMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
    [self initTitleViewWithTitle:self.artist.name];
    
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, Screen_Width - 30, Screen_Height-64)];
    textview.textColor = FontColor;
    textview.font = [UIFont systemFontOfSize:15];
    textview.text = self.artist.intro.length ? self.artist.intro : @"暂无介绍";
    textview.showsHorizontalScrollIndicator = NO;
    textview.showsVerticalScrollIndicator = NO;
//    textview.isEditable = NO;
    [textview setEditable:NO];
    [self.view addSubview:textview];
}

#pragma mark ----
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
