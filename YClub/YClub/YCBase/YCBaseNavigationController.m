//
//  YCBaseNavigationController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/28.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCBaseNavigationController.h"

@interface YCBaseNavigationController ()

@end
@implementation YCBaseNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:YC_Nav_TitleColor, NSFontAttributeName:YC_Nav_TitleFont}];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"dt_nav_bg"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]  forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}
@end
