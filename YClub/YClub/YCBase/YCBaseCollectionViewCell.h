//
//  YCBaseCollectionViewCell.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCBaseCollectionViewCell;
@protocol YCBaseCollectionViewCellDelegate <NSObject>
- (void)beginDeleteState;
- (void)deletePic:(YCBaseModel *)pic
       atIndexpath:(NSIndexPath *)indexPath;
@end

@interface YCBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton    *deleteBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<YCBaseCollectionViewCellDelegate>delegate;

- (void)setModel:(YCBaseModel *)model;

- (void)setUpLongGes;
@end
