//
//  YCEditCollectionViewCell.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCEditCollectionViewCell.h"

@interface YCEditCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YCBaseModel *model;
@end

@implementation YCEditCollectionViewCell

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        _imageView.frame = self.bounds;
    }
    return self;
}
- (void)setModel:(YCBaseModel *)model
{
    if (!model) {
        return;
    }
    _model = model;
    [_imageView sd_setImageWithURL:[NSURL safeURLWithString:model.img]];
}
- (UIImage *)showImg
{
    return _imageView.image;
}
@end
