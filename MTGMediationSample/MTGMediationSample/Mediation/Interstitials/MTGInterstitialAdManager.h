//
//  MTGInterstitialAdManager.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/19.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MTGInterstitialAdManagerDelegate.h"
#import "MTGInterstitialConstants.h"

NS_ASSUME_NONNULL_BEGIN


@interface MTGInterstitialAdManager : NSObject


@property (nonatomic, weak) id<MTGInterstitialAdManagerDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL ready;

- (id)initWithAdUnitID:(NSString *)adUnitID delegate:(id<MTGInterstitialAdManagerDelegate>)delegate;

- (void)loadInterstitial;
- (void)presentInterstitialFromViewController:(UIViewController *)controller;



@end

NS_ASSUME_NONNULL_END
