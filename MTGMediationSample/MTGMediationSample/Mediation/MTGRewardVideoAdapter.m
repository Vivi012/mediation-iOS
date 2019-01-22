//
//  MTGRewardVideoAdapter.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/18.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGRewardVideoAdapter.h"

@interface MTGRewardVideoAdapter ()<MTGRewardVideoAdapterDelegate>

@property (nonatomic, weak) id<MTGRewardVideoAdapterDelegate> delegate;
@property (nonatomic,copy) void(^completionHandler)(BOOL success,NSError *error);


@end

@implementation MTGRewardVideoAdapter

#pragma mark - public
- (id)initWithDelegate:(id<MTGRewardVideoAdapterDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
    }
    
    return self;
}

- (void)getAdWithInfo:(NSDictionary *)adInfo completionHandler:(void (^ __nullable)(BOOL success,NSError *error))completion{

}

- (BOOL)hasAdAvailable{
    
    return YES;
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController{
    
}


@end
