//
//  MeHeaderCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/27.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "MeHeaderCell.h"

@interface MeHeaderCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgview;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation MeHeaderCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"MeHeaderCell";
    MeHeaderCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MeHeaderCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
