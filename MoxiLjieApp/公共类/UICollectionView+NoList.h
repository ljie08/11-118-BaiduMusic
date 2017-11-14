//
//  UICollectionView+NoList.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (NoList)

-(void)showNoView:(NSString *)title image:(UIImage *)placeImage certer:(CGPoint)p;
-(void)dismissNoView;

///
@property(nonatomic,assign,readonly,getter=isShowNoView)BOOL showNoView;

@end
