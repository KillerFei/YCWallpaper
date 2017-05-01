//
//  YCEditBackView.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCEditBackView.h"

@interface YCEditBackView ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *loveBtn;
@end

@implementation YCEditBackView
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _backBtn;
}
- (UIButton *)loveBtn
{
    if (!_loveBtn) {
        _loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _loveBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:self.backBtn];
        [self addSubview:self.loveBtn];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(@100);
    }];
    [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.right.equalTo(self);
        make.width.mas_equalTo(@100);
    }];
}
@end
