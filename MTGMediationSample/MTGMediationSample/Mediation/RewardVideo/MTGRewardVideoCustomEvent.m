//
//  MTGRewardVideoCustomEvent.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/21.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGRewardVideoCustomEvent.h"
#import "MTGRewardVideoReward.h"

@implementation MTGRewardVideoCustomEvent


- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info{
    
    //to override in subclass
}

- (BOOL)hasAdAvailable{
    
    //to override in subclass
    return NO;
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController{
    
    //to override in subclass
}

@end
