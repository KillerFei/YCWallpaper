//
//  YCRecViewController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCRecViewController.h"
#import "YCBaseCollectionViewCell.h"
#import "YCEditCollectionController.h"
#import "UIViewController+WXSTransition.h"

@interface YCRecViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation YCRecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLayOut];
    [self setUpCollectionView];
    [self registerCell];
    [self requestData];
    [self addRefreshHeader];
    [self setUpNotification];
}
- (void)setUpNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiAction:) name:kYCEditLoadingNoti object:nil];
}
- (void)notiAction:(NSNotification *)noti
{
    NSDictionary *info = noti.userInfo;
    NSArray *dataSource = info[@"data"];
    if (dataSource.count > self.dataSource.count) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:dataSource];
        [self.myCollectionView reloadData];
    }
    NSIndexPath *index = info[@"index"];
    if (!kObjectIsEmpty(index)) {
        [self.myCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)loadNewData
{
    if (!kArrayIsEmpty(self.dataSource)) {
        [self endRefresh];
        return;
    }
    self.pageNum = 30;
    [self requestData];
}
- (void)loadMoreData
{
    self.pageNum+=30;
    [self requestData];
}
- (void)requestData
{
    [YCNetManager getListPicsWithOrder:@"mixin" skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
        [self endRefresh];
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource addObjectsFromArray:pics];
            [self.myCollectionView reloadData];
            [self addLoadMoreFooter];
        } else {
            [self addNoResultView];
            [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
#pragma mark - collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCBaseCollectionViewCell *baseCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [baseCell setModel:self.dataSource[indexPath.item]];
    return baseCell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item>self.dataSource.count-12 && self.scrollBottom)
    {
        [self loadMoreData];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YCEditCollectionController *editVC = [[YCEditCollectionController alloc] init];
    editVC.category   = NO;
    editVC.order      = @"mixin";
    editVC.pageNum    = self.pageNum+30;
    editVC.indexPath  = indexPath;
    editVC.dataSource = self.dataSource;
    [self wxs_presentViewController:editVC  animationType:WXSTransitionAnimationTypeSysRippleEffect completion:nil];
}
#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.lastOffSetY < scrollView.contentOffset.y) {
        self.scrollBottom = YES;
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.lastOffSetY = scrollView.contentOffset.y;
}
@end
