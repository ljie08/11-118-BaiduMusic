//
//  SearchAlbumCell.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchAlbumCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;
- (void)setDataWithModel:(SearchAlbum *)model barText:(NSString *)barText;

@end
