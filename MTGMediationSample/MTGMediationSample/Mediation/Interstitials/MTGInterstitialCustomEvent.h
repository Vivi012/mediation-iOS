//
//  MTGInterstitialCustomEvent.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/19.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTGPrivateInterstitialDelegate.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTGInterstitialCustomEvent : NSObject


@property (nonatomic, weak) id<MTGPrivateInnerInterstitialDelegate> delegate;

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info;

- (BOOL)hasAdAvailable;

- (void)presentInterstitialFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
