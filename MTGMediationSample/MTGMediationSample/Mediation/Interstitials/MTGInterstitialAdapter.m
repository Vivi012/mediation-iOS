//
//  MTGInterstitialAdapter.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/19.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGInterstitialAdapter.h"
#import "MTGInterstitialCustomEvent.h"
#import "MTGInterstitialConstants.h"
#import "MTGInterstitialError.h"

@interface MTGInterstitialAdapter ()<MTGPrivateInnerInterstitialDelegate>


@property (nonatomic, strong) MTGInterstitialCustomEvent *interstitialCustomEvent;

@property (nonatomic, weak) id<MTGPrivateInnerInterstitialDelegate> delegate;
@property (nonatomic, copy) void(^completionHandler)(BOOL success,NSError *error);

@property (nonatomic, copy)  NSString *adUnitID;
@property (nonatomic, copy)  NSString *networkName;
@property (nonatomic, strong) NSDictionary *mediationSettings;
@property (nonatomic, assign)  BOOL hasExpired;
@property (nonatomic, assign)  BOOL hasCancelPreviousPerform;

@end

@implementation MTGInterstitialAdapter


- (id)initWithDelegate:(id<MTGPrivateInnerInterstitialDelegate>)delegate mediationSettings:(NSDictionary *)mediationSettings{
    
    if (self = [super init]) {
        _delegate = delegate;
        _mediationSettings = mediationSettings;
    }
    return self;
}

- (void)getAdWithInfo:(NSDictionary *)adInfo completionHandler:(void (^ __nullable)(BOOL success,NSError *error))completion{
    
    NSMutableDictionary *adInfoWithMediationSetting = [NSMutableDictionary dictionaryWithDictionary:adInfo];
    [adInfoWithMediationSetting addEntriesFromDictionary:_mediationSettings];
    
    self.adUnitID = [adInfo objectForKey:MTG_INTERSTITIAL_UNITID];
    self.networkName = [adInfo objectForKey:MTG_INTERSTITIAL_NETWORKNAME];
    NSString *customEventClassName = [adInfo objectForKey:MTG_INTERSTITIAL_CLASSNAME ];
    
    self.interstitialCustomEvent = [self buildInterstitialCustomEventFromCustomClass:NSClassFromString(customEventClassName)];
    
    if (self.interstitialCustomEvent) {
        
        NSTimeInterval duration = [[adInfo objectForKey:MTG_INTERSTITIAL_TIMEOUT] doubleValue];
        [self startTimeoutTimer:duration];
        
        self.completionHandler = completion;
        
        [self.interstitialCustomEvent requestInterstitialWithCustomEventInfo:adInfoWithMediationSetting];
    } else {
        
        NSError *error = [NSError errorWithDomain:MTGInterstitialAdsSDKDomain code:MTGInterstitialAdErrorInvalidCustomEvent userInfo:nil];
        [self.delegate didFailToLoadInterstitialWithError:error];
    }
}

- (BOOL)hasAdAvailable{
    
    BOOL available = [self.interstitialCustomEvent hasAdAvailable];
    return available;
}


- (void)presentInterstitialFromViewController:(UIViewController *)viewController{
    
    [self.interstitialCustomEvent presentInterstitialFromViewController:viewController];
}

- (void)unregisterDelegate
{
    self.delegate = nil;
}


#pragma Private Methods -

-(void)dealloc{
    
    [self cancelPreviousPerform];
    _completionHandler = nil;

}

- (MTGInterstitialCustomEvent *)buildInterstitialCustomEventFromCustomClass:(Class)customClass{
    
    MTGInterstitialCustomEvent *customEvent = [[customClass alloc] init];
    
    if (![customEvent isKindOfClass:[MTGInterstitialCustomEvent class]]) {
        return nil;
    }
    customEvent.delegate = self;
    return customEvent;
}


- (void)startTimeoutTimer:(NSTimeInterval)duration{
    
    if (duration < 1) {
        duration = 10;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self performSelector:@selector(timeout) withObject:nil afterDelay:duration];
    });
}

- (void)timeout{
    
    self.hasExpired = YES;
    NSError *error = [NSError errorWithDomain:MTGInterstitialAdsSDKDomain code:MTGInterstitialAdErrorTimeout userInfo:nil];
    [self sendLoadFailedWithError:error];
}

- (void)cancelPreviousPerform{
    
    if (self.hasCancelPreviousPerform) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout) object:nil];
    self.hasCancelPreviousPerform = YES;
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(didFailToPresentInterstitialWithError:)]) {
        [_delegate didFailToPresentInterstitialWithError:error];
    }
}



- (void)didLoadInterstitial {
    
    [self cancelPreviousPerform];
    [self sendLoadSuccess];
}

- (void)didFailToLoadInterstitialWithError:(nonnull NSError *)error {
    
    [self cancelPreviousPerform];
    [self sendLoadFailedWithError:error];
}

- (void)didFailToPresentInterstitialWithError:(nonnull NSError *)error {
    
    [self sendShowFailedWithError:error];
}

- (void)didPresentInterstitial {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didPresentInterstitial)]) {
        [_delegate didPresentInterstitial];
    }
}

- (void)didReceiveTapEventFromInterstitial {

    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveTapEventFromInterstitial)]) {
        [_delegate didReceiveTapEventFromInterstitial];
    }
}

- (void)willDismissInterstitial {

    if (_delegate && [_delegate respondsToSelector:@selector(willDismissInterstitial)]) {
        [_delegate willDismissInterstitial];
    }
}

@end
