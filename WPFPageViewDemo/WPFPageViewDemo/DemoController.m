//
//  DemoController.m
//  WPFPageViewDemo
//
//  Created by PanFengfeng  on 14-3-19.
//  Copyright (c) 2014年 WingPan. All rights reserved.
//

#import "DemoController.h"
#import "WPFPageView.h"
#import "WPFPageViewCell.h"
#import "WPFZoomImageView.h"

@interface DemoController () <WPFPageViewDatasource, WPFPageViewDelegate>

@property (nonatomic, strong)NSArray *imageFileNames;

@end

@implementation DemoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageFileNames = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg"];
    }
    return self;
}

- (void)loadView {
    WPFPageView *pageView = [[WPFPageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    pageView.datasource = self;
    pageView.delegate = self;
    pageView.backgroundColor = [UIColor blueColor];
    self.view = pageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfPagesInPageView:(WPFPageView *)pageView {
    return self.imageFileNames.count;
}

- (void)pageView:(WPFPageView *)pageView preparePageCell:(WPFImagePageCell*)cell atIndex:(NSInteger)index {
    cell.imageView.image = [UIImage imageNamed:self.imageFileNames[index]];
}

- (void)pageView:(WPFPageView *)pageView didSelectAtIndex:(NSInteger)index {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"select on Page"
                                                        message:[NSString stringWithFormat:@"index : %d", index]
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles: nil];
    [alertView show];
}

@end
