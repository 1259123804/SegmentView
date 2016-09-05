//
//  ViewController.m
//  MySegmentView
//
//  Created by 小李 on 16/9/5.
//  Copyright © 2016年 小李. All rights reserved.
//

#import "ViewController.h"
#import "SegmentSuperViewController.h"
#define KWidth CGRectGetWidth(self.view.frame)
#define KHeight CGRectGetHeight(self.view.frame)
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    segmentBtn.frame = CGRectMake((KWidth-150)/2, 200, 150, 40);
    [segmentBtn setTitle:@"segmentView" forState:UIControlStateNormal];
    segmentBtn.backgroundColor = [UIColor orangeColor];
    [segmentBtn addTarget:self action:@selector(segmentClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:segmentBtn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)segmentClick{
    
    SegmentSuperViewController *superViewController = [[SegmentSuperViewController alloc] init];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = leftItem;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:74/255. green:74/255. blue:74/255. alpha:1];
    [self.navigationController pushViewController:superViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
