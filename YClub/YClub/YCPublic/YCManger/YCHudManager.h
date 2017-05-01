//
//  YCHudManager.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YCHudManager : NSObject

+ (void)showHudInView:(UIView *)view;
+ (void)showMessage:(NSString *)message InView:(UIView *)view;

+ (void)hideHudInView:(UIView *)view;

@end
