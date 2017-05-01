//
//  YCNewViewController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCNewViewController.h"
#import "YCBaseCollectionViewCell.h"
#import "YCEditCollectionController.h"
#import "UIViewController+WXSTransition.h"
@interface YCNewViewController ()

@end

@implementation YCNewViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLayOut];
    [self setUpCollectionView];
    if (!kStringIsEmpty(_tId)) {
        self.myCollectionView.frame = CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-64);
        [self setLeftBackNavItem];
    }
    [self registerCell];
    [self requestData];
    if (!kStringIsEmpty(_tId)) return;
    [self addRefreshHeader];
}
- (void)requestData
{
    if (kStringIsEmpty(_tId)) {
        [self requestNewListData];
    } else {
        [YCHudManager showHudInView:self.view];
        [self requestTypeListData];
    }
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

- (void)requestNewListData
{
    [YCNetManager getListPicsWithOrder:@"new" skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
        
        if (kStringIsEmpty(_tId)) {
            [self endRefresh];
        } else {
            [YCHudManager hideHudInView:self.view];
        }
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource addObjectsFromArray:pics];
            [self.myCollectionView reloadData];
            [self addLoadMoreFooter];
        } else {
            [self addNoResultView];
            if (!kStringIsEmpty(_tId)) {
                return;
            }
            [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
- (void)requestTypeListData
{
    [YCNetManager getCategoryListWithTId:_tId skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
        if (!kStringIsEmpty(_tId)) {
            [YCHudManager hideHudInView:self.view];
        } else {
             [self endRefresh];
        }
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource addObjectsFromArray:pics];
            [self.myCollectionView reloadData];
            if (kStringIsEmpty(_tId)) {
                [self addLoadMoreFooter];
            }
        } else {
            [self addNoResultView];
            if (!kStringIsEmpty(_tId)) return;
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
    if (!kStringIsEmpty(_tId)) return;
    if (indexPath.item>self.dataSource.count-12 && self.scrollBottom)
    {
        [self loadMoreData];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YCEditCollectionController *editVC = [[YCEditCollectionController alloc] init];
    if (!kStringIsEmpty(_tId)) {
        editVC.category = YES;
        editVC.order    = _tId;
    } else {
        editVC.category = NO;
        editVC.order    = @"new";
    }
    editVC.pageNum    = self.pageNum+30;
    editVC.dataSource = self.dataSource;
    editVC.indexPath  = indexPath;
    [self wxs_presentViewController:editVC  animationType:WXSTransitionAnimationTypeSysRippleEffect completion:nil];
}
#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!kStringIsEmpty(_tId)) return;
    if (self.lastOffSetY<scrollView.contentOffset.y) {
        self.scrollBottom = YES;
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (!kStringIsEmpty(_tId)) return;
    self.lastOffSetY = scrollView.contentOffset.y;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
