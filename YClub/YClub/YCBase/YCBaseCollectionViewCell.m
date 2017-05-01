//
//  YCBaseCollectionViewCell.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCBaseCollectionViewCell.h"

@interface YCBaseCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YCBaseCollectionViewCell

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubview];
    }
    return self;
}
- (void)setUpSubview
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.equalTo(self.contentView).with.offset(5);
        make.right.bottom.equalTo(self.contentView).with.offset(-5);
    }];
}
- (void)setModel:(YCBaseModel *)model
{
    if (!model) {
        return;
    }
    [_imageView sd_setImageWithURL:[NSURL safeURLWithString:model.thumb]];
}
@end
