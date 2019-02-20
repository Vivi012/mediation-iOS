//
//  MTGInterstitialAdapter.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/19.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MTGPrivateInterstitialDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTGInterstitialAdapter : NSObject

- (id)initWithDelegate:(id<MTGPrivateInnerInterstitialDelegate>)delegate mediationSettings:(NSDictionary *)mediationSettings;

- (void)getAdWithInfo:(NSDictionary *)adInfo completionHandler:(void (^ __nullable)(BOOL success,NSError *error))completion;

- (BOOL)hasAdAvailable;

- (void)presentInterstitialFromViewController:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
