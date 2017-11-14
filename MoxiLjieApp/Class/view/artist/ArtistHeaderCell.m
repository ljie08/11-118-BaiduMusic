//
//  ArtistHeaderCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "ArtistHeaderCell.h"

@interface ArtistHeaderCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgview;
@property (weak, nonatomic) IBOutlet UIImageView *artistImgview;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLab;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;

@end

@implementation ArtistHeaderCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"ArtistHeaderCell";
    ArtistHeaderCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ArtistHeaderCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithModel:(ArtistInfo *)model {
    [self.bgImgview sd_setImageWithURL:[NSURL URLWithString:model.avatar_s1000] placeholderImage:PlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    [self.artistImgview sd_setImageWithURL:[NSURL URLWithString:model.avatar_middle] placeholderImage:PlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.artistNameLab.text = model.name;
    self.countryLab.text = model.country;
    self.companyLab.text = model.company;
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
