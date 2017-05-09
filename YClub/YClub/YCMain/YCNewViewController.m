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

@implementation YCNewViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLayOut];
    [self setUpCollectionView];
    if (!kStringIsEmpty(_tId) || !kStringIsEmpty(_searchKey)) {
        self.myCollectionView.frame = CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-64);
        [self setLeftBackNavItem];
    }
    [self registerCell];
    [self requestData];
    [self addRefreshHeader];
}
- (void)requestData
{
    if (kStringIsEmpty(_tId) && kStringIsEmpty(_searchKey)) {
        [self requestNewListData];
    } else {
        if (!self.bFirstLoad) {
            [YCHudManager showLoadingInView:self.view];
        }
        if (!kStringIsEmpty(_tId)) {
            [self requestTypeListData];
        } else {
            [self requestSearchListData];
        }
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
- (void)requestTypeListData
{
    [YCNetManager getCategoryListWithTId:_tId skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
        if (!self.bFirstLoad) {
            [YCHudManager hideLoadingInView:self.view];
        } else {
             [self endRefresh];
        }
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
- (void)requestSearchListData
{
    [YCNetManager getSearchListWithKey:_searchKey skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
        self.bFirstLoad = YES;
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource addObjectsFromArray:pics];
            if (pics.count < 30) {
                [YCHudManager hideLoadingInView:self.view];
                [self.myCollectionView reloadData];
            } else {
                [self loadMoreData];
            }
        } else {
            
            if (error.code == 101) {
                [YCHudManager showMessage:@"wa，请检查" InView:<#(UIView *)#>]
            } else {
                [YCHudManager hideLoadingInView:self.view];
                [self.myCollectionView reloadData];
            }
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
    if (indexPath.item>self.dataSource.count-12 && self.scrollBottom && kStringIsEmpty(_searchKey))
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
    } else if (!kStringIsEmpty(_searchKey)){
        editVC.dataSource = self.dataSource;
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
    if (!kStringIsEmpty(_searchKey)) {
        return;
    }
    if (self.lastOffSetY<scrollView.contentOffset.y) {
        self.scrollBottom = YES;
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (!kStringIsEmpty(_searchKey)) {
        return;
    }
    self.lastOffSetY = scrollView.contentOffset.y;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
