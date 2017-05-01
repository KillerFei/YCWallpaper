//
//  YCTypeViewController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCTypeViewController.h"
#import "YCNewViewController.h"
#import "YCTypeCollectionViewCell.h"

@interface YCTypeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end
@implementation YCTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLayOut];
    [self setUpCollectionView];
    [self registerCell];
    [self requestData];
}
- (void)setUpLayOut
{
    self.layOut = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (KSCREEN_WIDTH-10*4)/3;
    self.layOut.itemSize = CGSizeMake(itemWidth, 54.f/35*itemWidth);
    self.layOut.minimumLineSpacing = 10;
    self.layOut.minimumInteritemSpacing = 10;
    self.layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)setUpCollectionView
{
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-64-49) collectionViewLayout:self.layOut];
    self.myCollectionView.backgroundColor = YC_Base_BgGrayColor;
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    [self.view addSubview:self.myCollectionView];
}
- (void)registerCell
{
    [self.myCollectionView registerClass:[YCTypeCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}
- (void)requestData
{
    [YCHudManager showHudInView:self.view];
    [YCNetManager getCategoryPicsWithCallBack:^(NSError *error, NSArray *pics) {
        [YCHudManager hideHudInView:self.view];
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:pics];
            [self.myCollectionView reloadData];
        } else {
            [self addNoResultView];
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
    YCTypeCollectionViewCell *baseCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [baseCell setModel:self.dataSource[indexPath.item]];
    return baseCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YCBaseModel *model = self.dataSource[indexPath.item];
    if (kStringIsEmpty(model.tId)) return;
    YCNewViewController *newVC = [[YCNewViewController alloc] init];
    newVC.tId = model.tId;
    newVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
