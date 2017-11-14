//
//  SearchArtistCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "SearchArtistCell.h"

@interface SearchArtistCell()

@property (weak, nonatomic) IBOutlet UIImageView *artistImg;
@property (weak, nonatomic) IBOutlet UILabel *artistLab;

@end

@implementation SearchArtistCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"SearchArtistCell";
    SearchArtistCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SearchArtistCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithModel:(SearchArtist *)model barText:(NSString *)barText {
    [self.artistImg sd_setImageWithURL:[NSURL URLWithString:model.artistpic] placeholderImage:PlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.artistLab.attributedText = [LJUtil setMainColorForKeywords:barText mainStr:model.artistname];
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
