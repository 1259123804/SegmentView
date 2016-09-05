//
//  SegmentSuperViewController.m
//  SegmentPage
//
//  Created by 小李 on 16/9/5.
//  Copyright © 2016年 小李. All rights reserved.
//

#import "SegmentSuperViewController.h"
#import "SegmentViewController.h"
#import "MainTouchTableTableView.h"
#import "MYSegmentView.h"

@interface SegmentSuperViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, strong) MainTouchTableTableView *tableView;
@property (nonatomic, strong) MYSegmentView *segmentView;
@property (nonatomic, strong) UIImageView *headImageView;

@end

static CGFloat const headViewHeight = 200.0f;
#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
@implementation SegmentSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setAlpha:0];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:[self tableView]];
    [self.tableView addSubview:[self headImageView]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveTop:) name:@"leaveTop" object:nil];

    // Do any additional setup after loading the view.
}

- (void)leaveTop:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     * 处理联动
     */
    //获取滚动视图y值的偏移量
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    self.navigationController.navigationBar.alpha = (headViewHeight+yOffset)/(headViewHeight-64);
    
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y-64.0f;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    
    if (offsetY >= tabOffsetY) {
        
        //不能滑动
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
        
    }else{
        
        //可以滑动
        _isTopIsCanNotMoveTabView = NO;
        
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"子视图控制器滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"父视图控制器滑动到顶端");
            if (!_canScroll) {
                
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
    
    /**
     * 处理头部视图
     */
    if(yOffset < -headViewHeight) {
        
        CGRect f = self.headImageView.frame;
        f.origin.x = (yOffset*KWidth/headViewHeight+KWidth)/2;
        f.origin.y= yOffset ;
        f.size.height = -yOffset;
        f.size.width = -yOffset*KWidth/headViewHeight;
        //改变头部视图的fram
        self.headImageView.frame= f;
    }
}

- (UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, -headViewHeight , KWidth,headViewHeight)];
        [_headImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Animal" ofType:@"jpeg"]]];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[MainTouchTableTableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(headViewHeight, 0, 0, 0);
        _tableView.rowHeight = KHeight;
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:self.segmentView];
    return cell;
}

- (UIView *)segmentView
{
    if(!_segmentView){
        
        SegmentViewController *firstViewController = [[SegmentViewController alloc] init];
        firstViewController.title = @"first";
        
        SegmentViewController *secondViewController = [[SegmentViewController alloc] init];
        secondViewController.title = @"second";
        
        NSArray *controllerArray = @[firstViewController, secondViewController];
        NSArray *titleArray = @[@"first", @"second"];
        
        CGFloat lineWidth = [@"second" boundingRectWithSize:CGSizeMake(100, 21) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size.width;
        
        MYSegmentView *tempView = [[MYSegmentView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-64) controllers:controllerArray titleArray:titleArray ParentController:self lineWidth:lineWidth lineHeight:3.];
        _segmentView = tempView;
    }
    return _segmentView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
