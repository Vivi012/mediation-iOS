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
#import "MTGRewardVideoConstants.h"


@interface MTGRewardVideoAdapter ()<MTGRewardVideoCustomEventDelegate>


@property (nonatomic, strong) MTGRewardVideoCustomEvent *rewardedVideoCustomEvent;

@property (nonatomic, weak) id<MTGRewardVideoAdapterDelegate> delegate;
@property (nonatomic, copy) void(^completionHandler)(BOOL success,NSError *error);

@property (nonatomic, copy)  NSString *adUnitID;
@property (nonatomic, copy)  NSString *networkName;
@property (nonatomic, strong) NSDictionary *mediationSettings;
@property (nonatomic, assign)  BOOL hasExpired;

@property (nonatomic,strong) NSPort *emptyPort;
@property (nonatomic,assign)  BOOL shouldStopRunning;

@end

@implementation MTGRewardVideoAdapter

#pragma mark - public
- (id)initWithDelegate:(id<MTGRewardVideoAdapterDelegate>)delegate mediationSettings:(NSDictionary *)mediationSettings{

    if (self = [super init]) {
        _delegate = delegate;
        _mediationSettings = mediationSettings;
    }
    return self;
}

- (void)getAdWithInfo:(NSDictionary *)adInfo completionHandler:(void (^ __nullable)(BOOL success,NSError *error))completion{

    NSMutableDictionary *adInfoWithMediationSetting = [NSMutableDictionary dictionaryWithDictionary:adInfo];
    [adInfoWithMediationSetting addEntriesFromDictionary:_mediationSettings];

    self.adUnitID = [adInfo objectForKey:MTG_REWARDVIDEO_UNITID];
    self.networkName = [adInfo objectForKey:MTG_REWARDVIDEO_NETWORKNAME];
    NSString *customEventClassName = [adInfo objectForKey:MTG_REWARDVIDEO_CLASSNAME];

    self.rewardedVideoCustomEvent = [self buildRewardedVideoCustomEventFromCustomClass:NSClassFromString(customEventClassName)];
    
    if (self.rewardedVideoCustomEvent) {

        NSTimeInterval duration = [[adInfo objectForKey:MTG_REWARDVIDEO_TIMEOUT] doubleValue];
        [self startTimeoutTimer:duration];
        
        self.completionHandler = completion;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rewardedVideoCustomEvent requestRewardedVideoWithCustomEventInfo:adInfo];
        });
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

//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    _completionHandler = nil;
    // Make sure the custom event isn't released synchronously as objects owned by the custom event
//    [self keepObjectAliveForCurrentRunLoopIteration:_rewardedVideoCustomEvent];
}

//- (void)keepObjectAliveForCurrentRunLoopIteration:(id)anObject{
//
//    [self performSelector:@selector(performNoOp:) withObject:anObject afterDelay:0];
//}
//
//- (void)performNoOp:(id)anObject{
//    ; // noop
//}

- (MTGRewardVideoCustomEvent *)buildRewardedVideoCustomEventFromCustomClass:(Class)customClass{

    MTGRewardVideoCustomEvent *customEvent = [[customClass alloc] init];
    
    if (![customEvent isKindOfClass:[MTGRewardVideoCustomEvent class]]) {
        return nil;
    }
    customEvent.delegate = self;
    return customEvent;
}


- (void)startTimeoutTimer:(NSTimeInterval)duration{

    if (duration < 1) {
        duration = 10;
    }
    
    [self performSelector:@selector(timeout) withObject:nil afterDelay:duration];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self timeout];
    });
    
    
//    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//
//    if (!_emptyPort) {
//        _emptyPort = [NSMachPort port];
//    }
//    [runLoop addPort:_emptyPort forMode:NSDefaultRunLoopMode];
//    [runLoop runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];//[runLoop run];
//    [self performSelector:@selector(timeout) withObject:nil afterDelay:duration];

    
//    [self performSelector:@selector(timeout) withObject:nil afterDelay:duration];
//    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
//    while (!self.shouldStopRunning ){
//        NSLog(@"--------------%@",[NSThread currentThread]);
//        [theRL runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
//    }
    
    
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(runLoop) object:nil];
//    [thread start];
//    [self performSelector:@selector(timeout) onThread:thread withObject:nil waitUntilDone:YES];
}

//- (void)runLoop {
//
//        NSLog(@"current thread = %@", [NSThread currentThread]);
//        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//        if (!self.emptyPort) {
//            self.emptyPort = [NSMachPort port];
//        }
//        [runLoop addPort:self.emptyPort forMode:NSDefaultRunLoopMode];
//        [runLoop runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
//}

- (void)timeout{
    
//    CFRunLoopStop(CFRunLoopGetCurrent());
    
    self.hasExpired = YES;
    NSError *error = [NSError errorWithDomain:MTGRewardVideoAdsSDKDomain code:MTGRewardVideoAdErrorTimeout userInfo:nil];
    [self sendLoadFailedWithError:error];
//    self.shouldStopRunning = YES;
    
//    CFRunLoopStop(CFRunLoopGetCurrent());
//    NSThread *thread = [NSThread currentThread];
//    [thread cancel];
}

- (void)didStopLoading{

//    if (!_hasExpired) {
//        [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    }
}

- (void)sendLoadFailedWithError:(NSError *)error{

    if (self.completionHandler) {
        self.completionHandler(NO, error);
    }
    self.completionHandler = nil;
}

- (void)sendLoadSuccess{
    
    if (_hasExpired) {
        return;
    }

    if (self.completionHandler && ![self.completionHandler isEqual:[NSNull null]]) {

        NSLog([NSString stringWithFormat: @"current unit%@ loadSuccess,   ",self.adUnitID],
              [NSString stringWithFormat: @"and ad network is:%@",self.networkName]
              );
        self.completionHandler(YES, nil);
    }
    self.completionHandler = nil;

}

- (void)sendShowFailedWithError:(NSError *)error{

    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidFailToLoadForAdUnitID:error:)]) {
        [_delegate rewardVideoAdDidFailToLoadForAdUnitID:self.adUnitID error:error];
    }
}


#pragma mark MTGRewardVideoCustomEventDelegate -

- (void)rewardedVideoDidLoadAdForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent{
    
    [self didStopLoading];
    [self sendLoadSuccess];
}

- (void)rewardedVideoDidFailToLoadAdForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent error:(NSError *)error{
    
    [self didStopLoading];
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
