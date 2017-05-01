//
//  YCBaseCollectionController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCBaseCollectionController.h"
#import "YCBaseCollectionViewCell.h"
#import "YCEditCollectionController.h"

@interface YCBaseCollectionController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation YCBaseCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UIView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64)];
        UIImageView *noReultImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yc_no_result"]];
        noReultImg.center = CGPointMake(KSCREEN_WIDTH/2, (KSCREEN_HEIGHT-204)/2);
        noReultImg.userInteractionEnabled = YES;
        [_noResultView addSubview:noReultImg];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_noResultView addGestureRecognizer:tap];
    }
    return _noResultView;
}
- (void)setUpLayOut
{
    _layOut = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (KSCREEN_WIDTH-YC_Base_Space*(YC_Line_Count+1))/YC_Line_Count;
    _layOut.itemSize = CGSizeMake(itemWidth, 54.f/35*itemWidth);
    _layOut.minimumLineSpacing = YC_Base_Space;
    _layOut.minimumInteritemSpacing = YC_Base_Space;
    _layOut.sectionInset = UIEdgeInsetsMake(YC_Base_Space, YC_Base_Space, YC_Base_Space, YC_Base_Space);
}
- (void)setUpCollectionView
{
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64-49) collectionViewLayout:_layOut];
    _myCollectionView.backgroundColor = YC_Base_BgGrayColor;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    [self.view addSubview:_myCollectionView];
}
- (void)registerCell
{
    [_myCollectionView registerClass:[YCBaseCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}
#pragma mark --- Public
- (void)addRefreshHeader
{
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    _myCollectionView.mj_header = header;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // Hide the status
    header.stateLabel.hidden = YES;
    [header setImages:@[[UIImage imageNamed:@"loading11_105x18_"]] forState:MJRefreshStateIdle];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 11; i < 22; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading%d_105x18_",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    for (int i = 1; i < 11; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading%d_105x18_",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    [header setImages:images forState:MJRefreshStatePulling];
    [header setImages:images forState:MJRefreshStateRefreshing];
    _myCollectionView.mj_header = header;
}
- (void)addLoadMoreFooter
{
    if (!_bFirstLoad) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _myCollectionView.mj_footer = footer;
        _bFirstLoad = YES;
    }
}
- (void)loadNewData
{
}
- (void)loadMoreData
{
}
- (void)requestData
{
}
- (void)endRefresh
{
    [self.myCollectionView.mj_header endRefreshing];
    [self.myCollectionView.mj_footer endRefreshing];
}
#pragma mark --- UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - resultView
- (void)addNoResultView
{
    if (kArrayIsEmpty(self.dataSource) && !self.bFirstLoad) {
        [self.view addSubview:self.noResultView];
    }
}
- (void)removeNoResultView
{
    if (_noResultView && [_noResultView superview]) {
        [_noResultView removeFromSuperview];
        _noResultView = nil;
    }
}
- (void)tapAction
{
    _pageNum = 30;
    [self removeNoResultView];
    [self requestData];
}
@end
