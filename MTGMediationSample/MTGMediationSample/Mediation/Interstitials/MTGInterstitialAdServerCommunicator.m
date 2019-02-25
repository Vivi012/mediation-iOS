//
//  MTGInterstitialAdServerCommunicator.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/20.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGInterstitialAdServerCommunicator.h"
#import "MTGAdInfo.h"
#import "MTGInterstitialError.h"

@implementation MTGInterstitialAdServerCommunicator


- (id)initWithDelegate:(id<MTGInterstitialAdServerCommunicatorDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)requestAdUnitInfosWithAdUnit:(NSString *)adUnitId{
    
    // request local configuration for ad infos
    NSArray *interstitialInfos = [MTGAdInfo interstitialInfosWithAdUnitId:adUnitId];
    if (interstitialInfos.count) {

        if (_delegate && [_delegate respondsToSelector:@selector(communicatorDidReceiveAdUnitInfos:)]) {
            [_delegate communicatorDidReceiveAdUnitInfos:interstitialInfos];
        }
        return;
    }
    // we will support send request for remote ad infos later
    if (_delegate && [_delegate respondsToSelector:@selector(communicatorDidFailWithError:)]) {
        NSError *error = [NSError errorWithDomain:MTGInterstitialAdsSDKDomain code:MTGInterstitialAdErrorInvalidAdUnitID userInfo:nil];
        [_delegate communicatorDidFailWithError:error];
    }
}

- (void)cancel{
    
    //cancel request remote infos
}

#pragma mark -
/*
 - (void)communicatorDidReceiveAdUnitInfos:(NSArray *)infos{
 
 }
 - (void)communicatorDidFailWithError:(NSError *)error{
 
 }
 */
@end
