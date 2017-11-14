//
//  MeViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "MeViewController.h"
#import "MeHeaderCell.h"

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *artistTable;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        return 50;
    }
    return 230;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"list"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.textColor = FontColor;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        NSArray *titleArr = [NSArray arrayWithObjects:@"作者", @"版本", nil];
        NSArray *detailArr = [NSArray arrayWithObjects:@"Lynn", @"2.10.1", nil];
        cell.textLabel.text = titleArr[indexPath.row];
        cell.detailTextLabel.text = detailArr[indexPath.row];
        
        return cell;
    }
    MeHeaderCell *cell = [MeHeaderCell myCellWithTableview:tableView];
    return cell;
}

#pragma mark - ui
- (void)setupTable {
    self.artistTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStylePlain];
    self.artistTable.delegate = self;
    self.artistTable.dataSource = self;
    [self.view addSubview:self.artistTable];
    
    self.artistTable.backgroundColor = [UIColor clearColor];
    self.artistTable.tableFooterView = [UIView new];
}

#pragma mark - UI
- (void)initUIView {
    self.navigationItem.title = NSLocalizedString(@"我的", nil);

    [self setNav];
    [self setupTable];
}

- (void)setNav {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    
    UIImage *leftImg = [UIImage imageNamed:@"single"];
    
    leftImg = [leftImg imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    
    [leftBtn setImage:leftImg forState:UIControlStateNormal];
    [leftBtn setTintColor:FontColor];
    
    [leftBtn addTarget:self action:@selector(gotoPlayVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self addNavigationWithTitle:nil leftItem:leftItem rightItem:nil titleView:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
