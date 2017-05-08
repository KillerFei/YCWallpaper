//
//  YCNetManager.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCNetManager.h"
#import "NetAPI_YC.h"
#import "YCBaseModel.h"

typedef NS_ENUM(NSInteger, YCErrorCode)
{
    YCErrorCode_Fail = 101,
    YCErrorCode_NoResult
};
@implementation YCNetManager

+ (void)faildToLoadWithCode:(NSInteger)code
                   CallBack:(callBack)callBack
{
    if (callBack) {
        NSError *error = [NSError errorWithDomain:@"BizYixinErrorDomain" code:code userInfo:nil];
        callBack(error, nil);
    }
}
+ (void)getListPicsWithOrder:(NSString *)order
                        skip:(NSNumber *)skip
                    callBack:(callBack)callBack
{
    NSDictionary *params = @{@"adult":@0,
                            @"first":@1,
                            @"limit":@30,
                            @"order":order,
                            @"skip":skip};
    [HYBNetworking getWithUrl:kYCBaseListUrl refreshCache:YES params:params success:^(id response) {
        
        NSDictionary *resp = (NSDictionary *)response;
        NSNumber *code = resp[@"code"];
        if ([code isEqual:@0]) {
            
            NSDictionary *res = resp[@"res"];
            NSArray *vertical = res[@"vertical"];
            if (!kArrayIsEmpty(vertical)) {
                NSMutableArray *pics = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in vertical) {
                    
                    YCBaseModel *model = [[YCBaseModel alloc] init];
                    model.thumb = dict[@"thumb"];
                    model.img   = dict[@"img"];
                    [pics addObject:model];
                }
                if (callBack) {
                    callBack(nil, pics);
                }
            } else {
               [YCNetManager faildToLoadWithCode:102 CallBack:callBack];
            }
        }
    } fail:^(NSError *error) {
        [YCNetManager faildToLoadWithCode:101 CallBack:callBack];
    }];
}
+ (void)getCategoryListWithTId:(NSString *)tId
                          skip:(NSNumber *)skip
                      callBack:(callBack)callBack
{
    NSDictionary *params = @{@"adult":@0,
                             @"first":@1,
                             @"limit":@30,
                             @"order":@"new",
                             @"skip":skip};
    NSString *url = [NSString stringWithFormat:@"v1/vertical/category/%@/vertical",tId];
    [HYBNetworking getWithUrl:url refreshCache:YES params:params success:^(id response) {
        
        NSDictionary *resp = (NSDictionary *)response;
        NSNumber *code = resp[@"code"];
        if ([code isEqual:@0]) {
            
            NSDictionary *res = resp[@"res"];
            NSArray *vertical = res[@"vertical"];
            if (!kArrayIsEmpty(vertical)) {
                NSMutableArray *pics = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in vertical) {
                    
                    YCBaseModel *model = [[YCBaseModel alloc] init];
                    model.thumb = dict[@"thumb"];
                    model.img   = dict[@"img"];
                    [pics addObject:model];
                }
                if (callBack) {
                    callBack(nil, pics);
                }
            } else {
                [YCNetManager faildToLoadWithCode:102 CallBack:callBack];
            }
        }
    } fail:^(NSError *error) {
       [YCNetManager faildToLoadWithCode:101 CallBack:callBack];
    }];
}
+ (void)getCategoryPicsWithCallBack:(callBack)callBack
{
    [HYBNetworking getWithUrl:kYCBaseCategoryUrl refreshCache:YES success:^(id response) {
        
        NSDictionary *resp = (NSDictionary *)response;
        NSNumber *code = resp[@"code"];
        if ([code isEqual:@0]) {
            
            NSDictionary *res = resp[@"res"];
            NSArray *vertical = res[@"category"];
            if (!kArrayIsEmpty(vertical)) {
                NSMutableArray *pics = [[NSMutableArray alloc] init];
                [YCBaseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"tId":@"id"};
                }];
                for (NSDictionary *dict in vertical) {
                    
                    YCBaseModel *model = [YCBaseModel mj_objectWithKeyValues:dict];
                    [pics addObject:model];
                }
                if (callBack) {
                    callBack(nil, pics);
                }
            } else {
                [YCNetManager faildToLoadWithCode:101 CallBack:callBack];
            }
        }
    } fail:^(NSError *error) {
        [YCNetManager faildToLoadWithCode:101 CallBack:callBack];
    }];
}
@end
