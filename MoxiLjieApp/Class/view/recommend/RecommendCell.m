//
//  RecommendCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "RecommendCell.h"

@interface RecommendCell()

@property (weak, nonatomic) IBOutlet UIImageView *songImgView;

@property (weak, nonatomic) IBOutlet UIImageView *artistImg;
@property (weak, nonatomic) IBOutlet UILabel *artistLab;
@property (weak, nonatomic) IBOutlet UILabel *songLab;

@end

@implementation RecommendCell

- (void)setDataWithModel:(Song *)model {
    [self.songImgView sd_setImageWithURL:[NSURL URLWithString:model.pic_big] placeholderImage:PlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.artistLab.text = model.author;
    self.songLab.text = model.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    /*
    UIImageRenderingModeAutomatic  // 根据图片的使用环境和所处的绘图上下文自动调整渲染模式。
    UIImageRenderingModeAlwaysOriginal   // 始终绘制图片原始状态，不使用Tint Color。
    UIImageRenderingModeAlwaysTemplate   // 始终根据Tint Color绘制图片，忽略图片的颜色信息。
     */
    self.artistImg.image = [self.artistImg.image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    self.artistImg.tintColor = [UIColor whiteColor];
}

@end
