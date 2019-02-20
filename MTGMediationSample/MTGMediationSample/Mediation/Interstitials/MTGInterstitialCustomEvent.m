//
//  MTGInterstitialCustomEvent.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/19.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGInterstitialCustomEvent.h"

@implementation MTGInterstitialCustomEvent


- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info{
    
    //to override in subclass
}

- (BOOL)hasAdAvailable{
    
    //to override in subclass
    return NO;
}

- (void)presentInterstitialFromViewController:(UIViewController *)viewController{
    
    //to override in subclass
}



@end
