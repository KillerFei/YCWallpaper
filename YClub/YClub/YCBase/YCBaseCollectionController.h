//
//  YCBaseCollectionController.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCBaseViewController.h"

@interface YCBaseCollectionController : YCBaseViewController

@property (nonatomic, assign) NSInteger        pageNum;
@property (nonatomic, assign) BOOL             bFirstLoad;
@property (nonatomic, strong) NSMutableArray   *dataSource;
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layOut;
@property (nonatomic, assign) BOOL             scrollBottom;
@property (nonatomic, strong) UIView           *noResultView;
@property (nonatomic, assign) CGFloat          lastOffSetY;
@property (nonatomic, assign) CGFloat          lastOffSetX;

- (void)setUpLayOut;
- (void)setUpCollectionView;
- (void)registerCell;

- (void)addRefreshHeader;
- (void)addLoadMoreFooter;

- (void)loadNewData;
- (void)loadMoreData;
- (void)requestData;
- (void)endRefresh;

- (void)addNoResultView;
- (void)removeNoResultView;

@end
