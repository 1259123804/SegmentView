//
//  SegmentPageBaseViewController.h
//  SegmentPage
//
//  Created by 小李 on 16/9/5.
//  Copyright © 2016年 小李. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentPageBaseViewController : UIViewController

@property(strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic, assign) BOOL canScroll;
@end
