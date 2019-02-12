//
//  MTGRewardVideoReward.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/12.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGRewardVideoReward.h"

NSString *const kMTGRewardVideoRewardCurrencyTypeUnspecified = @"MTGRewardVideoRewardCurrencyTypeUnspecified";
NSInteger const kMTGRewardVideoRewardCurrencyAmountUnspecified = 0;


@implementation MTGRewardVideoReward

- (instancetype)initWithCurrencyType:(NSString *)currencyType amount:(NSNumber *)amount
{
    if (self = [super init]) {
        _currencyType = [currencyType copy];
        _amount = amount;
    }
    
    return self;
}

- (instancetype)initWithCurrencyAmount:(NSNumber *)amount
{
    return [self initWithCurrencyType:kMTGRewardVideoRewardCurrencyTypeUnspecified amount:amount];
}

@end
