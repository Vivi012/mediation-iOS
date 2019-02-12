//
//  MTGAdInfo.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/18.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGAdInfo.h"

@implementation MTGAdInfo

+ (NSArray *)rewardVideoAdUnitIds{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RewardVideoAdInfosData" ofType:@"plist"];
    NSDictionary *adUnitIdInfos = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *adUnitIds = adUnitIdInfos.allKeys;
    return adUnitIds;
}

+ (NSArray *)rewardVideoInfosWithAdUnitId:(NSString *)adUnitId{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"RewardVideoAdInfosData" ofType:@"plist"];
    NSDictionary *adUnitIdInfos = [NSDictionary dictionaryWithContentsOfFile:path];

    NSArray *networkInfos = [adUnitIdInfos objectForKey:adUnitId];
    return networkInfos;
}


@end
