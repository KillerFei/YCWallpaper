//
//  YCEditDownView.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCEditDownView.h"

@interface YCEditDownView()

@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIButton *readBtn;
@end
@implementation YCEditDownView

- (UIButton *)downBtn
{
    if (!_downBtn) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downBtn setTitle:@"下载" forState:UIControlStateNormal];
        [_downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _downBtn;
}
- (UIButton *)readBtn
{
    if (!_readBtn) {
        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_readBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _readBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:self.downBtn];
        [self addSubview:self.readBtn];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(@(KSCREEN_WIDTH/2));
    }];
    [_readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(@(KSCREEN_WIDTH/2));
    }];
}
@end
