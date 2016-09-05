//
//  SegmentPageBaseViewController.m
//  SegmentPage
//
//  Created by 小李 on 16/9/5.
//  Copyright © 2016年 小李. All rights reserved.
//


#import "SegmentPageBaseViewController.h"

@interface SegmentPageBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation SegmentPageBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"goTop" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
}

- (void)acceptMsg:(NSNotification *)notification{
    
    NSString *notificationName = notification.name;
    
    if ([notificationName isEqualToString:@"goTop"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.scrollView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:@"leaveTop"]){
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.canScroll = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.canScroll) {
        
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil userInfo:@{@"canScroll":@"1"}];
    }
    
    _scrollView = scrollView;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.scrollView.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
