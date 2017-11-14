//
//  SearchAlbumCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "SearchAlbumCell.h"

@interface SearchAlbumCell()

@property (weak, nonatomic) IBOutlet UIImageView *albumImg;
@property (weak, nonatomic) IBOutlet UILabel *artistLab;
@property (weak, nonatomic) IBOutlet UILabel *albumLab;

@end

@implementation SearchAlbumCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"SearchAlbumCell";
    SearchAlbumCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SearchAlbumCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithModel:(SearchAlbum *)model  barText:(NSString *)barText {
    [self.albumImg sd_setImageWithURL:[NSURL URLWithString:model.artistpic] placeholderImage:PlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.artistLab.attributedText = [LJUtil setMainColorForKeywords:barText mainStr:model.artistname];
    self.albumLab.attributedText = [LJUtil setMainColorForKeywords:barText mainStr:model.albumname];
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
