//
//  MTGPrivateInterstitialDelegate.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/20.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol MTGPrivateInnerInterstitialDelegate <NSObject>


- (void)didLoadInterstitial;
- (void)didFailToLoadInterstitialWithError:(NSError *)error;
- (void)didPresentInterstitial;
- (void)didFailToPresentInterstitialWithError:(NSError *)error;
- (void)willDismissInterstitial;
- (void)didReceiveTapEventFromInterstitial;


@end

NS_ASSUME_NONNULL_END
