//
//  MTGRewardVideoAdManager.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/17.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGRewardVideoAdManager.h"
#import "MTGAdServerCommunicator.h"
#import "MTGRewardVideoAdapter.h"


@interface MTGRewardVideoAdManager ()<MTGAdServerCommunicatorDelegate,MTGRewardVideoAdapterDelegate>

@property (nonatomic, strong) MTGRewardVideoAdapter *adapter;
@property (nonatomic, strong) MTGAdServerCommunicator *communicator;

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL playedAd;
@property (nonatomic, assign) BOOL ready;


@end

@implementation MTGRewardVideoAdManager

- (instancetype)initWithAdUnitID:(NSString *)adUnitID delegate:(id<MTGRewardVideoAdManagerDelegate>)delegate{
    if (self = [super init]) {
        _adUnitID = [adUnitID copy];
        _communicator = [[MTGAdServerCommunicator alloc] initWithDelegate:self];
        _delegate = delegate;
    }
    
    return self;
}

- (void)loadRewardedVideoAd{
    
    if (self.ready && !self.playedAd) {
     
//        [self.delegate rewardedVideoDidLoadForAdManager:self];
    } else {
        
        [self.communicator requestAdUnitInfosWithAdUnit:_adUnitID];
    }
}

- (BOOL)hasAdAvailable{
    
    if (self.playedAd) {
        return NO;
    }
    return [self.adapter hasAdAvailable];
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController{
    // If we've already played an ad, don't allow playing of another since we allow one play per load.
    if (self.playedAd) {
//        NSError *error = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorAdAlreadyPlayed userInfo:nil];
//        [self.delegate rewardedVideoDidFailToPlayForAdManager:self error:error];
        return;
    }

    [self.adapter presentRewardedVideoFromViewController:viewController];
}

#pragma Private
- (void)dealloc
{
    [_communicator cancel];
}

/*
- (void)startTimeoutTimer
{

}

- (void)timeout
{

}
 */

#pragma mark MTGAdServerCommunicatorDelegate -
- (void)communicatorDidReceiveAdUnitInfos:(NSArray *)infos{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    [infos enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *adInfo = (NSDictionary *)obj;

        dispatch_group_async(group, queue, ^{

            dispatch_group_enter(group);

            MTGRewardVideoAdapter *adapter = [[MTGRewardVideoAdapter alloc] initWithDelegate:self];
            
            if (!adapter) {
//                NSError *error = nil;
                //        [self rewardedVideoDidFailToLoadForAdapter:nil error:error];
                return;
            }
            
            self.adapter = adapter;

            [self.adapter getAdWithInfo:adInfo completionHandler:^(BOOL success, NSError * _Nonnull error) {
                if (success) {
#warning  Chark TODO
                    *stop = YES;
                }else{
                    //if the last loop failed
                    if (idx == (infos.count - 1)) {
                        #warning  Chark TODO
                        //send failed callback
                    }
                }
                
                dispatch_group_leave(group);

            }];
        });
    }];

}

- (void)communicatorDidFailWithError:(NSError *)error{
    
}

@end
