//
//  WPFPageView.m
//  WPFPageView
//
//  Created by PanFengfeng  on 14-3-18.
//  Copyright (c) 2014年 PanFengfeng . All rights reserved.
//

#import "WPFPageView.h"
#import "WPFPageViewCell.h"
#import "WPFZoomImageView.h"

#pragma mark - WPFPageViewLayout
static const CGFloat kWPFPageCellPadding = 20;

@interface WPFPageViewLayout : UICollectionViewLayout

@property (nonatomic, strong)NSMutableArray *pageAttributes;

@end

@implementation WPFPageViewLayout


@end

@implementation WPFPageViewLayout (Override)

- (void)prepareLayout {
    [super prepareLayout];
    
    self.collectionView.pagingEnabled = YES;
    
    self.pageAttributes = [NSMutableArray array];
    
    NSInteger sections = [self.collectionView numberOfSections];
    for (int section = 0; section < sections; section++) {
        NSInteger rowsInSection = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < rowsInSection; row++) {
            [self.pageAttributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]]];
        }
    }
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *pageAttribute in self.pageAttributes) {
        if (CGRectContainsPoint(rect, pageAttribute.frame.origin)) {
            [attributes addObject:pageAttribute];
        }else if (CGRectContainsPoint(rect, CGPointMake(CGRectGetMaxX(pageAttribute.frame), CGRectGetMinY(pageAttribute.frame)))) {
            [attributes addObject:pageAttribute];
        }
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect pageBounds = self.collectionView.bounds;
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(CGRectGetWidth(pageBounds) - kWPFPageCellPadding,
                                 CGRectGetHeight(pageBounds));
    attributes.alpha = 1.0;
    attributes.center = CGPointMake(CGRectGetWidth(pageBounds)*indexPath.row + CGRectGetWidth(pageBounds)/2.0,
                                    CGRectGetMidY(self.collectionView.bounds));
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity; // return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(7_0); // a layout can return the content offset to be applied during transition or update animations

- (CGSize)collectionViewContentSize {
    CGRect pageBounds = self.collectionView.bounds;
    NSInteger sections = [self.collectionView numberOfSections];
    NSInteger itemCount = 0;
    
    for (int i = 0; i < sections; i++) {
        itemCount += [self.collectionView numberOfItemsInSection:i];
    }
    
    return CGSizeMake(CGRectGetWidth(pageBounds)*itemCount,
                      CGRectGetHeight(pageBounds));
}

@end


#pragma mark - WPFPageView
typedef  struct  {
    BOOL  numberOfPage : 1;
    BOOL  pageCell    : 1;
} WPFPageViewDatasourceFlag;

typedef struct {
    BOOL didSelect     : 1;
} WPFPageViewDelegateFlag;

@interface WPFPageView () {
    WPFPageViewLayout   *_pageViewLayout;
    UICollectionView    *_internalPageView;
    
    WPFPageViewDatasourceFlag _datasourceFlag;
    WPFPageViewDelegateFlag   _delegateFlag;
}

@end

@interface WPFPageView (UICollectionViewAdditions) <
UICollectionViewDataSource,
UICollectionViewDelegate
>

@end

@implementation WPFPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageViewLayout = [[WPFPageViewLayout alloc] init];
        _internalPageView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                               collectionViewLayout:_pageViewLayout];
        _internalPageView.backgroundColor = [UIColor blueColor];
        _internalPageView.dataSource = self;
        _internalPageView.delegate = self;
        [self addSubview:_internalPageView];
        
        [_internalPageView registerClass:[WPFImagePageCell class]
              forCellWithReuseIdentifier:NSStringFromClass([WPFImagePageCell class])];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _internalPageView.frame = CGRectMake(-kWPFPageCellPadding/2.0, 0,
                                         CGRectGetWidth(self.bounds) + kWPFPageCellPadding,
                                         CGRectGetHeight(self.bounds));
    [_pageViewLayout invalidateLayout];
}

- (void)setDatasource:(id<WPFPageViewDatasource>)datasource {
    if (_datasource == datasource) {
        return;
    }
    
    _datasource = datasource;
    
    _datasourceFlag.numberOfPage = [_datasource respondsToSelector:@selector(numberOfPagesInPageView:)];

    _datasourceFlag.pageCell = [_datasource respondsToSelector:@selector(pageView:preparePageCell:atIndex:)];
}

- (void)setDelegate:(id<WPFPageViewDelegate>)delegate {
    if (_delegate == delegate) {
        return;
    }
    
    _delegate = delegate;
    _delegateFlag.didSelect = [_delegate respondsToSelector:@selector(pageView:didSelectAtIndex:)];
}

@end

@implementation WPFPageView (UICollectionViewAdditions)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_datasourceFlag.numberOfPage) {
        return [self.datasource numberOfPagesInPageView:self];
    }
    
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WPFImagePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WPFImagePageCell class])
                                                                       forIndexPath:indexPath];
    
    if (![cell isKindOfClass:[WPFImagePageCell class]]) {
        @throw [NSException exceptionWithName:@"PageView Datasource Error"
                                       reason:[NSString stringWithFormat:@"PageView Datasource Cell Return Error At Index:%d", indexPath.row] userInfo:nil];
    }
    
    cell.imageView.image = nil;
    
    if (_datasourceFlag.pageCell) {
        [_datasource pageView:self preparePageCell:cell atIndex:indexPath.row];
    }
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView
                        transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout
                                           newLayout:(UICollectionViewLayout *)toLayout {
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (_delegateFlag.didSelect) {
        [self.delegate pageView:self didSelectAtIndex:indexPath.row];
    }
}

@end
