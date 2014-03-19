//
//  WPFPageViewCell.h
//  WPFPageView
//
//  Created by PanFengfeng  on 14-3-18.
//  Copyright (c) 2014年 PanFengfeng . All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPFZoomImageView;
#pragma mark WPFImagePageCell
@interface WPFImagePageCell : UICollectionViewCell

@property (nonatomic, readonly, strong)WPFZoomImageView *imageView;

@end
