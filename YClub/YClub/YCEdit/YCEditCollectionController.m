//
//  YCEditCollectionController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCEditCollectionController.h"
#import "YCEditCollectionViewCell.h"
#import "YCEditBackView.h"
#import "YCEditDownView.h"

@interface YCEditCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource, YCEditBackViewDelegate, YCEditDownViewDelegate>

@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) YCBaseModel    *currentModel;
@property (nonatomic, strong) YCEditBackView *backView;
@property (nonatomic, strong) YCEditDownView *downView;
@end

@implementation YCEditCollectionController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLayOut];
    [self setUpCollectionView];
    [self registerCell];
    [self setUpMenuView];
    [self setUpCurrentModel];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)setUpLayOut
{
    self.layOut = [[UICollectionViewFlowLayout alloc] init];
    self.layOut.itemSize = [UIScreen mainScreen].bounds.size;
    self.layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.layOut.minimumLineSpacing = 0;
    self.layOut.minimumInteritemSpacing = 0;
    self.layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}
- (void)setUpCollectionView
{
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.layOut];
    self.myCollectionView.backgroundColor = YC_Base_BgGrayColor;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    self.myCollectionView.pagingEnabled = YES;
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
- (void)setUpCurrentModel
{
    if (!kArrayIsEmpty(self.dataSource)) {
        _currentModel = self.dataSource[_indexPath.section];
    }
}
- (void)registerCell
{
    [self.myCollectionView registerClass:[YCEditCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}
- (void)setUpMenuView
{
    _show = YES;
    _backView = [[YCEditBackView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 64)];
    _downView = [[YCEditDownView alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT-49, KSCREEN_WIDTH, 49)];
    _backView.delegate = self;
    _downView.delegate = self;
    [self.view addSubview:_backView];
    [self.view addSubview:_downView];
}
- (void)menuViewAnima
{
    if (_show) {
        [self hidenMenuView];
    } else {
        [self showMenuView];
    }
}
- (void)showMenuView
{
    [UIView animateWithDuration:0.2 animations:^{
        _backView.top = 0;
        _downView.bottom = KSCREEN_HEIGHT;
        _show = YES;
    }];
}
- (void)hidenMenuView
{
    [UIView animateWithDuration:0.2 animations:^{
        _backView.top = -64;
        _downView.bottom = KSCREEN_HEIGHT+49;
        _show = NO;
    }];
}
- (void)loadMoreData
{
    self.pageNum+=30;
    [self requestData];
}
- (void)requestData
{
    if (!_category) {
        [self requestNewListData];
    } else {
        [self requestCaListData];
    }
}
- (void)requestNewListData
{
    [YCNetManager getListPicsWithOrder:_order skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
        
//        [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource addObjectsFromArray:pics];
            [self.myCollectionView reloadData];
//            [self addLoadMoreFooter];
        }
    }];
}
- (void)requestCaListData
{
    [YCNetManager getCategoryListWithTId:_order skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
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
    YCEditCollectionViewCell *baseCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [baseCell setModel:self.dataSource[indexPath.item]];
    _currentModel = self.dataSource[indexPath.item];
    _indexPath    = indexPath;
    return baseCell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item>self.dataSource.count-6 && self.scrollBottom)
    {
        [self loadMoreData];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self menuViewAnima];
}
#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.lastOffSetX < scrollView.contentOffset.x) {
        self.scrollBottom = YES;
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.lastOffSetX = scrollView.contentOffset.x;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - YCEditBackViewDelegate
- (void)clickBackBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - YCEditDownViewDelegate
- (void)clickDownBtn
{
    YCEditCollectionViewCell *cell = (YCEditCollectionViewCell *)[self.myCollectionView cellForItemAtIndexPath:_indexPath];
    UIImage *img = [cell showImg];
    [self saveImage:img];
}
- (void)saveImage:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
}
- (void)clickReadBtn
{
    
}
@end
