//
//  MainHomeCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/25.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "MainHomeCell.h"

@interface MainHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *songImg;
@property (weak, nonatomic) IBOutlet UILabel *songLab;
@property (weak, nonatomic) IBOutlet UILabel *artistLab;

@end

@implementation MainHomeCell

- (void)setDataWithModel:(Song *)model {
    [self.songImg sd_setImageWithURL:[NSURL URLWithString:model.pic_big] placeholderImage:PlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.songLab.text = model.title;
    self.artistLab.text = model.author;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
