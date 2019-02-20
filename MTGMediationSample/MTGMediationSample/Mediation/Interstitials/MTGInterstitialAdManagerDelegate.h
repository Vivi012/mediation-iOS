//
//  MTGInterstitialAdManagerDelegate.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/19.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTGInterstitialAdManager;
@protocol MTGInterstitialAdManagerDelegate <NSObject>


- (void)managerDidLoadInterstitial:(MTGInterstitialAdManager *)manager;
- (void)manager:(MTGInterstitialAdManager *)manager didFailToLoadInterstitialWithError:(NSError *)error;
- (void)managerDidPresentInterstitial:(MTGInterstitialAdManager *)manager;
- (void)manager:(MTGInterstitialAdManager *)manager didFailToPresentInterstitialWithError:(NSError *)error;
- (void)managerWillDismissInterstitial:(MTGInterstitialAdManager *)manager;
- (void)managerDidReceiveTapEventFromInterstitial:(MTGInterstitialAdManager *)manager;
- (NSDictionary *)managerReceiveMediationSetting;

@end

