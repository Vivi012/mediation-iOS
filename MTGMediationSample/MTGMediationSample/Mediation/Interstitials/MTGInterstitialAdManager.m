//
//  MTGInterstitialAdManager.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/19.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGInterstitialAdManager.h"
#import "MTGInterstitialAdapter.h"
#import "MTGAdServerCommunicator.h"
#import "MTGInterstitialError.h"

@interface MTGInterstitialAdManager ()<MTGAdServerCommunicatorDelegate>

@property (nonatomic, readonly) NSString *adUnitID;

@property (nonatomic, strong) MTGInterstitialAdapter *adapter;
@property (nonatomic, strong) MTGAdServerCommunicator *communicator;

@property (nonatomic, assign) BOOL loading;

@end

@implementation MTGInterstitialAdManager


- (id)initWithAdUnitID:(NSString *)adUnitID delegate:(id<MTGInterstitialAdManagerDelegate>)delegate{

    if (self = [super init]) {
        _adUnitID = [adUnitID copy];
        _communicator = [[MTGAdServerCommunicator alloc] initWithDelegate:self];
        _delegate = delegate;
    }
    
    return self;
}

- (void)loadInterstitial{
    
    if (self.loading) {
//        NSError *error = [NSError errorWithDomain:MTGRewardVideoAdsSDKDomain code:MTGRewardVideoAdErrorCurrentUnitIsLoading userInfo:nil];
//        [self sendLoadFailedWithError:error];
        return;
    }
    
    self.loading = YES;
    
    [self.communicator requestAdUnitInfosWithAdUnit:_adUnitID];
}

- (BOOL)hasAdAvailable{
    
    if (self.loading) {
        return NO;
    }
    if (!self.adapter) {
        return NO;
    }
    return NO;
//    return [self.adapter hasAdAvailable];
}


- (void)presentInterstitialFromViewController:(UIViewController *)controller{
    // If we've already played an ad, don't allow playing of another since we allow one play per load.
    if (self.loading) {
//        NSError *error = [NSError errorWithDomain:MTGRewardVideoAdsSDKDomain code:MTGRewardVideoAdErrorCurrentUnitIsLoading userInfo:nil];
//        [self sendShowFailedWithError:error];
        return;
    }
    if (![self hasAdAvailable]) {
//        NSError *error = [NSError errorWithDomain:MTGRewardVideoAdsSDKDomain code:MTGRewardVideoAdErrorNoAdsAvailable userInfo:nil];
//        [self sendShowFailedWithError:error];
        return;
    }
    [self.adapter presentInterstitialFromViewController:controller];
}


#pragma Private Methods -
- (void)dealloc
{
    [_communicator cancel];
}

- (void)sendLoadFailedWithError:(NSError *)error{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidFailToLoadForAdUnitID:error:)]) {
//        [_delegate rewardVideoAdDidFailToLoadForAdUnitID:self.adUnitID error:error];
    }
}

- (void)sendLoadSuccess{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidLoadForAdUnitID:)]) {
//        [_delegate rewardVideoAdDidLoadForAdUnitID:self.adUnitID];
    }
}

- (void)sendShowFailedWithError:(NSError *)error{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidFailToLoadForAdUnitID:error:)]) {
//        [_delegate rewardVideoAdDidFailToLoadForAdUnitID:self.adUnitID error:error];
    }
    
}


#pragma mark MTGAdServerCommunicatorDelegate -
- (void)communicatorDidReceiveAdUnitInfos:(NSArray *)infos{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self createThreadhandleInfos:infos];
    });
}

- (void)createThreadhandleInfos:(NSArray *)infos{
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *adInfo = (NSDictionary *)obj;
        
        self.adapter = nil;
        
        MTGInterstitialAdapter *adapter = [[MTGInterstitialAdapter alloc] initWithDelegate:self mediationSettings:nil];
        
        self.adapter = adapter;
        
        [self.adapter getAdWithInfo:adInfo completionHandler:^(BOOL success, NSError * _Nonnull error) {
            if (success) {
                [self sendLoadSuccess];
                *stop = YES;
            }else{
                
                self.adapter = nil;
                
                //if the last loop failed
                if (idx == (infos.count - 1)) {
                    [self sendLoadFailedWithError:error];
                }
                //else: continue next request loop
            }
            
            dispatch_semaphore_signal(sem);
        }];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    }];
    
    self.loading = NO;
}


- (void)communicatorDidFailWithError:(NSError *)error{
    
    [self sendLoadFailedWithError:error];
    
    self.loading = NO;
}



@end
