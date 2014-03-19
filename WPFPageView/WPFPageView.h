//
//  WPFPageView.h
//  WPFPageView
//
//  Created by PanFengfeng  on 14-3-18.
//  Copyright (c) 2014年 PanFengfeng . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPFPageViewDatasource;
@protocol WPFPageViewDelegate;
@class WPFImagePageCell;

#pragma mark - WPFPageView
@interface WPFPageView : UIView

@property (nonatomic, weak) id<WPFPageViewDatasource> datasource;
@property (nonatomic, weak) id<WPFPageViewDelegate>   delegate;

@end

#pragma mark - WPFPageViewDatasource
@protocol WPFPageViewDatasource <NSObject>

- (NSInteger)numberOfPagesInPageView:(WPFPageView *)pageView;
- (void)pageView:(WPFPageView *)pageView preparePageCell:(WPFImagePageCell*)cell atIndex:(NSInteger)index;

@end

#pragma mark - WPFPageViewDelegate
@protocol WPFPageViewDelegate <NSObject>

- (void)pageView:(WPFPageView *)pageView didSelectAtIndex:(NSInteger)index;

@end


