//
//  WPFPageViewCell.m
//  WPFPageView
//
//  Created by PanFengfeng  on 14-3-18.
//  Copyright (c) 2014年 PanFengfeng . All rights reserved.
//

#import "WPFPageViewCell.h"
#import "WPFZoomImageView.h"

#pragma mark WPFImagePageCell
@interface WPFImagePageCell ()

@property (nonatomic, strong, readwrite)WPFZoomImageView *imageView;

@end

@implementation WPFImagePageCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView = [[WPFZoomImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageView];
        
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

@end


