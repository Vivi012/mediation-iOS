//
//  MTGRewardVideoAdapter.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/18.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGRewardVideoAdapter.h"
#import "MTGRewardVideoCustomEvent.h"
#import "MTGRewardVideoReward.h"
#import "MTGRewardVideoError.h"


#define MTG_REWARDVIDEO_UNITID @"unitid"
#define MTG_REWARDVIDEO_CLASSNAME @"classname"
#define MTG_REWARDVIDEO_TIMEOUT @"timeout"

@interface MTGRewardVideoAdapter ()<MTGRewardVideoCustomEventDelegate>


@property (nonatomic, strong) MTGRewardVideoCustomEvent *rewardedVideoCustomEvent;

@property (nonatomic, weak) id<MTGRewardVideoAdapterDelegate> delegate;
@property (nonatomic,copy) void(^completionHandler)(BOOL success,NSError *error);

@property (nonatomic,copy)  NSString *adUnitID;
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

    self.adUnitID = [adInfo objectForKey:MTG_REWARDVIDEO_UNITID];

    NSString *customEventClassName = [adInfo objectForKey:MTG_REWARDVIDEO_CLASSNAME];
    self.rewardedVideoCustomEvent = [self buildRewardedVideoCustomEventFromCustomClass:NSClassFromString(customEventClassName)];
    
    if (self.rewardedVideoCustomEvent) {

        NSTimeInterval duration = [[adInfo objectForKey:MTG_REWARDVIDEO_TIMEOUT] doubleValue];
        [self startTimeoutTimer:duration];
        
        [self.rewardedVideoCustomEvent requestRewardedVideoWithCustomEventInfo:adInfo];
    } else {
        
        NSError *error = [NSError errorWithDomain:MTGRewardVideoAdsSDKDomain code:MTGRewardVideoAdErrorInvalidCustomEvent userInfo:nil];
        [self.delegate rewardVideoAdDidFailToLoadForAdUnitID:self.adUnitID error:error];
    }
}

- (BOOL)hasAdAvailable{
    
    BOOL available = [self.rewardedVideoCustomEvent hasAdAvailable];
    return available;
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController{
    
    [self.rewardedVideoCustomEvent presentRewardedVideoFromViewController:viewController];
}

#pragma Private Methods -

-(void)dealloc{

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [_rewardedVideoCustomEvent handleCustomEventInvalidated];
    // Make sure the custom event isn't released synchronously as objects owned by the custom event
    // may do additional work after a callback that results in dealloc being called
//    [[MPCoreInstanceProvider sharedProvider] keepObjectAliveForCurrentRunLoopIteration:_rewardedVideoCustomEvent];
    

}

- (MTGRewardVideoCustomEvent *)buildRewardedVideoCustomEventFromCustomClass:(Class)customClass
{
    MTGRewardVideoCustomEvent *customEvent = [[customClass alloc] init];
    
    if (![customEvent isKindOfClass:[MTGRewardVideoCustomEvent class]]) {
        return nil;
    }
    customEvent.delegate = self;
    return customEvent;
}


- (void)startTimeoutTimer:(NSTimeInterval)duration
{
    if (duration < 1) {
        duration = 10;
    }
    
    [self performSelector:@selector(timeout) withObject:nil afterDelay:duration];
}

- (void)timeout
{
    NSError *error = [NSError errorWithDomain:MTGRewardVideoAdsSDKDomain code:MTGRewardVideoAdErrorTimeout userInfo:nil];
    [self sendLoadFailedWithError:error];
}

- (void)didStopLoading
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)sendLoadFailedWithError:(NSError *)error{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidFailToLoadForAdUnitID:error:)]) {
        [_delegate rewardVideoAdDidFailToLoadForAdUnitID:self.adUnitID error:error];
    }
}

- (void)sendLoadSuccess{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidLoadForAdUnitID:)]) {
        [_delegate rewardVideoAdDidLoadForAdUnitID:self.adUnitID];
    }
}

- (void)sendShowFailedWithError:(NSError *)error{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidFailToLoadForAdUnitID:error:)]) {
        [_delegate rewardVideoAdDidFailToLoadForAdUnitID:self.adUnitID error:error];
    }
}


#pragma mark MTGRewardVideoCustomEventDelegate -

- (void)rewardedVideoDidLoadAdForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent{
    
    [self sendLoadSuccess];
}

- (void)rewardedVideoDidFailToLoadAdForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent error:(NSError *)error{
    [self sendLoadFailedWithError:error];
}

- (void)rewardVideoAdDidShowForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidShowForAdUnitID:)]) {
        [_delegate rewardVideoAdDidShowForAdUnitID:self.adUnitID];
    }
}

- (void)rewardVideoAdDidFailToPlayForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent error:(NSError *)error{

    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidFailToPlayForAdUnitID:error:)]) {
        [_delegate rewardVideoAdDidFailToPlayForAdUnitID:self.adUnitID error:error];
    }
}

- (void)rewardVideoAdWillDisappearForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdWillDisappearForAdUnitID:)]) {
        [_delegate rewardVideoAdWillDisappearForAdUnitID:self.adUnitID];
    }
}

- (void)rewardVideoAdShouldRewardForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent reward:(MTGRewardVideoReward *)reward{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdShouldRewardForAdUnitID:reward:)]) {
        [_delegate rewardVideoAdShouldRewardForAdUnitID:self.adUnitID reward:reward];
    }
}

- (void)rewardVideoAdDidReceiveTapEventForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidReceiveTapEventForAdUnitID:)]) {
        [_delegate rewardVideoAdDidReceiveTapEventForAdUnitID:self.adUnitID];
    }
}


@end
