//
//  YCHudManager.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCHudManager.h"

@implementation YCHudManager

+ (void)showHudInView:(UIView *)view
{
    if (!view) {
        return;
    }
    MBProgressHUD *oldHud = [MBProgressHUD HUDForView:view];
    if (oldHud) {
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    //hud.bezelView.color = [UIColor blackColor];
    hud.mode = MBProgressHUDModeIndeterminate;
    //设置转轮颜色
    //[UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = ;
    [view addSubview:hud];
    [hud showAnimated:YES];
}
+ (void)showMessage:(NSString *)message InView:(UIView *)view
{
    if (!view) {
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.bezelView.color = [UIColor blackColor];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.label.textColor        = [UIColor whiteColor];
    [view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.5];
}
+ (void)hideHudInView:(UIView *)view
{
    if (!view) {
        return;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}
@end
