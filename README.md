
# Mediation Integration Guide (iOS)
[Chinese Document](./docs/index_cn.md)

## Overview    

This document describes to Android developers how to aggregate other third-parties' ad SDK, through Mintegral. 
Currently, we only support aggregation of ironSource's Rewarded Video and Interstitial ad formats; ironSource's Interstitial ad corresponds to Mintegral's Interstitial Video.

## Mintegral Settings

### Retrieve Account-Related Information

**App Key**      
Each Mintegral account has a corresponding App Key, and the key will be needed for requesting ads. It can be retreived from your Mintegral account through the following path: **APP Setting -> App Key**:  
![](./docs/apikey.png)     

**App ID**      
The M-system will automatically generate a corresponding App ID for each app created by the developer. Find the App ID(s)  here: **APP Setting -> APP ID**:        
![](./docs/appid.png)   

**Unit ID**    
The M-system will automatically generate a corresponding Unit ID for each ad space created by the developer. Find the Unit ID here: **Login to M-system —> App Setting—> Ad Unit —> Ad Unit ID:**   
![](./docs/unitid.png)  

### Obtain the SDK

[Click here](http://cdn-adn.rayjump.com/cdn-adn/v2/portal/19/02/22/11/51/5c6f71d8e7289.zip)  to download the latest version (4.9.3) of the Mintegral SDK. 

#### Interstitial
To integrate the Interstitial ad format, the MTGSDK.framework and MTGSDKInterstitialVideo.framework files need to be imported.

#### Rewarded Video
To integrate Rewarded Video ad format, the MTGSDK.framework and MTGSDKReward.framework files need to be imported. 

### Parameter Configuration Before Initialization

1.Import basic static libraries

CoreGraphics.framework <br/>
Foundation.framework <br/>
UIKit.framework <br/>
libsqlite3.tbd (It's libsqlite3.dylib below Xcode7) <br/>
libz.tbd (It'slibz.dylib below Xcode7) <br/>
AdSupport.framwork <br/>
StoreKit.framewrok <br/>
QuartzCore.framework <br/>
CoreLocation.framework <br/>
CoreTelephony.framework <br/>
MobileCoreServices.framework <br/>
Accelerate.framework <br/>
AVFoundation.framework <br/>
WebKit.framework <br/>
	
2.Add linker parameter for XCode
Find Other Linker Flags in build settings and add flag: -ObjC (case sensitive).

3.Allow the operation of the HTTP connection  

Due to the App Transport Security regulations of iOS 9, you need to modify the project's info.plist file, allowing HTTP connection. The specific method is as below:  
Add an App Transport Security Settings Dictionary in the info.plist file; and add an Allow Arbitrary Loads key with its boolean value (setting as "YES") for this Dictionary.    



## ironSource Setting

###  Create your account
#### [Sign up](https://platform.ironsrc.com/partners/signup)and[sign in](https://platform.ironsrc.com/partners/tour)to your ironSource account.     
#### Create New App 
To add your application to the ironSource dashboard, click the **New App** button.

![](./docs/ir1.png)

### Enter app details

Select **Mobile App**, enter the **App Store** of your app, and click **Import App Info**. Once your app information is displayed, click the **Add App** button.

If your app is not available, select **App Not Live in the Application Store** and provide a **Temporary Name** for your app. Select Android as **platform** and click **Add App**.

![](./docs/ir2.png)

#### Unit Setting
Take note of your new **App Key**, This value will used when loading ads. Select the ad formats your app supports in the appropriate tabs. Then click **Done**.
![](https://developers.google.com/admob/images/mediation/ironsource/ad_format_select_android.png)

### Integrating ironSource 
Please read [ironsource iOS Intergration document](https://developers.ironsrc.com/ironsource-mobile/ios/getting-started-ironsource-ios-sdk-chinese/#step-1) to add the SDK to your project.         


ironSource supports both Cocoapods and manual download mechanisms to integrate our SDK:

#### CocoaPods

To integrate ironsource SDK with Cocoapods, enter the following line in your podfile:  

    pod 'IronSourceSDK','6.8.1.0'

#### Manual Download

Follow these steps to add the ironSource SDK to your project:

1.  [Download iOS SDK Version 6.8.1](https://dl.bintray.com/ironsource-mobile/ios-sdk/IronSource6.8.1.zip "Download iOS SDK Version 6.8.1")  
    After you download the SDK; unzip it and add IronSource.framework into your Xcode Project.
2.  **Add Linker Flags**  
    Add the following linker flag to the build settings at:  
    **Target** ➣**Build****Settings** ➣**Linking**➣ **Other****Linker Flags**:  
    –**ObjC**

#### App Transport Security Settings

**Important!** In iOS 9, Apple added in controls around ‘ATS’. To ensure uninterrupted support for ironSource ad delivery across all mediation networks, it’s important to make the following changes in your **info.plist**:

*   Add in a dictionary called ‘**NSAppTransportSecurity**‘. Make sure you add this dictionary on the ‘**Top Level Key**‘.
*    Inside this dictionary, add a Boolean called ‘**NSAllowsArbitraryLoads**‘ and set it to**YES**.[](/ironsource-mobile/ios/getting-started-ironsource-ios-sdk/ats/)[![ats](https://developers.ironsrc.com/wp-content/uploads/2016/08/ATS.gif)](https://developers.ironsrc.com/wp-content/uploads/2016/08/ATS.gif)  
     
         **Note**:
     
    *   Make sure that your info.plist does not contain any other exceptions besides ‘**NSAllowsArbitraryLoads**‘, as this might create a conflict.
    *   Find more information on ATS [here](https://developer.apple.com/library/prerelease/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33).  




### Import Adapter 
Click [here] (https://github.com/Mintegral-official/mediation-iOS/tree/master/MTGMediationSample/MTGMediationSample) to get the mediation and network package and copy all the files to your project.


## Interstitial
### Import header file

```java
#import "MTGInterstitialAdManager.h"
```

### Create the MTGInterstitialAdManager

You need to pass the adUnitId when initializing, create a plist file, and enter your ad ID, adapter class name and other parameters as shown below. The Mintegral network needs to pass the appid, appkey, unitid that you have applied in the Mintegral background. The ironSource needs to pass the appkey that you have applied in the ironsource background. **Item 0 is the primarily called network.**      
In addition to creating the form of the plist file here, you can also set parameters in MTGAdInfo.                      

![](./docs/iOSplist.png)    

sample code：        

```java 
-(MTGInterstitialAdManager *)interstitialManager{
    if (_interstitialManager) {
        return _interstitialManager;
    }
    _interstitialManager = [[MTGInterstitialAdManager alloc] initWithAdUnitID:self.adUnitId delegate:self];
    return _interstitialManager;
}
```

### Set MTGInterstitialAdManagerDelegate

```java

#pragma mark - MTGInterstitialAdManagerDelegate

/**
 * This method is called after an ad fails to load.
 *
 * @param error An error indicating why the ad failed to load.
 * Specific error code can be viewed in MTGInterstitialError.h
 */


- (void)manager:(MTGInterstitialAdManager *)manager didFailToLoadInterstitialWithError:(NSError *)error {
    self.showButton.userInteractionEnabled = NO;
    NSString *msg = [NSString stringWithFormat:@"error: %@",error.description];
    [self showMsg:msg];
}

/**
 * This method is called after an ad loads successfully.
 *
 * @param adUnitID The unit of the ad associated with the event.
 */

- (void)managerDidLoadInterstitial:(MTGInterstitialAdManager *)manager {
    
    self.showButton.userInteractionEnabled = YES;
    NSString *msg = [NSString stringWithFormat:@"unit %@ loadSuccess",manager];
    [self showMsg:msg];
}

/**
 * This method is called after an ad show successfully.
 *
 */

- (void)managerDidPresentInterstitial:(MTGInterstitialAdManager *)manager {
    
}

/**
 * This method is called after an ad fails to show ads.
 *
 * @param error An error indicating why the ad failed to load.
 * Specific error code can be viewed in MTGInterstitialError.h.
 */

- (void)manager:(MTGInterstitialAdManager *)manager didFailToPresentInterstitialWithError:(NSError *)error {
    
}

/**
 * This method is called when the user taps on the ad.
 *
 */


- (void)managerDidReceiveTapEventFromInterstitial:(MTGInterstitialAdManager *)manager {
    
}

/**
 * This method is called when a rewarded video ad will be dismissed.
 *
 */

- (void)managerWillDismissInterstitial:(MTGInterstitialAdManager *)manager {
    
}

/**
 * This method is get callbacks for your custom parameters 
 *
 */

-(NSDictionary *)managerReceiveMediationSetting{
    
    NSDictionary *mediationSettings = @{MTG_INTERSTITIAL_USER:@"Your userId"};
    return mediationSettings;
}

@end
```


### Load Interstitial Ads


```java
- (void)loadInterstitial;

Sample code：
- (IBAction)loadInterstitialAction:(id)sender {

    if (!self.adUnitId) {
        NSString *msg = @"Your adUnitId is nil";
        [self showMsg:msg];
        return;
    }
    [self.interstitialManager loadInterstitial];
}
```

### Show Interstitial Ads
#### Check An Ads Availability

```java
[MTGInterstitialAdManager ready];
```
#### Show Ads

```java
- (void)presentInterstitialFromViewController:(UIViewController *)controller;

Sample code：


- (IBAction)showInterstitialAction:(id)sender {

    if ([self.interstitialManager ready]) {
        [self.interstitialManager presentInterstitialFromViewController:self];
    }else{
        NSString *msg = @"video still not ready";
        [self showMsg:msg];
    }
}


```




## Rewarded Video
### Import Header File
```java
#import "MTGRewardVideo.h"
```
### Load Rewarded Video

You need to pass the adUnitId when initializing, create a plist file, and enter your ad ID, adapter class name and other parameters as shown below. The Mintegral network needs to pass the appid, appkey, unitid that you have applied in the Mintegral background. The ironSource needs to pass the appkey that you have applied in the ironsource background. **Item 0 is the primarily called network.**      
In addition to creating the form of the plist file here, you can also set parameters in MTGAdInfo.                     

![](./docs/iOSRVPlist.png)

#### Register MTGRewardVideoDelegate
```java
[MTGRewardVideo registerRewardVideoDelegate:self];
    
#pragma mark - MTGRewardVideoDelegate

/**
 * This method is called after an ad loads successfully.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */

- (void)rewardVideoAdDidLoadForAdUnitID:(NSString *)adUnitID{
    
    self.showButton.userInteractionEnabled = YES;
    NSString *msg = [NSString stringWithFormat:@"unit %@ loadSuccess",adUnitID];
    [self showMsg:msg];
}
/**
 * This method is called after an ad fails to load.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 * @param error An error indicating why the ad failed to load.
 * Specific error code can be viewed in MTGRewardVideoError.h
 */

- (void)rewardVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID
                                        error:(NSError *)error{
    self.showButton.userInteractionEnabled = NO;
    NSString *msg = [NSString stringWithFormat:@"error: %@",error.description];
    [self showMsg:msg];
}

/**
 * This method is called when an attempt to play a rewarded video success.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
 
-(void)rewardVideoAdDidPlayForAdUnitID:(NSString *)adUnitID{
    
}

/**
 * This method is called when an attempt to play a rewarded video fails.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 * @param error An error describing why the video couldn't play.
 * Specific error code can be viewed in MTGRewardVideoError.h
 */
 
- (void)rewardVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID
                                        error:(NSError *)error{
    
}

/**
 * This method is called when a rewarded video ad will be dismissed.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
 
- (void)rewardVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID{
    
}

/**
 * This method is called when the user should be rewarded for watching a rewarded video ad.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 * @param reward The object that contains all the information regarding how much you should reward the user.
 */

- (void)rewardVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID
                                      reward:(MTGRewardVideoReward *)reward{
    
}

/**
 * This method is called when the user taps on the ad.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */

- (void)rewardVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID{
    
}

@end

```

#### Load Rewarded Video Ads
**The user ID（can only be numbers and characters） is the identifier for the server-side callback, if it is in client-callback mode it can be left empty.**      

```java
+ (void)loadRewardVideoAdWithAdUnitID:(NSString *)adUnitID mediationSettings:(NSDictionary *)mediationSettings;

Sample code：
- (IBAction)loadRewardVideoAction:(id)sender {
  
    if (!self.adUnitId) {
        NSString *msg = @"Your adUnitId is nil";
        [self showMsg:msg];
        return;
    }
    NSDictionary *mediationSettings = @{MTG_REWARDVIDEO_USER:@"Your userId"}; 
    [MTGRewardVideo registerRewardVideoDelegate:self];
    [MTGRewardVideo loadRewardVideoAdWithAdUnitID:self.adUnitId mediationSettings:mediationSettings];
}
```
### Show Rewarded Video Ads
#### Check ads availability
```java
+ (BOOL)hasAdAvailableForAdUnitID:(NSString *)adUnitID;
```
#### Show ads

```java
+ (void)presentRewardVideoAdForAdUnitID:(NSString *)adUnitID fromViewController:(UIViewController *)viewController;
```
sample code：    

```java
- (IBAction)showRewardVideoAction:(id)sender {

    if ([MTGRewardVideo hasAdAvailableForAdUnitID:self.adUnitId]) {
        [MTGRewardVideo presentRewardVideoAdForAdUnitID:self.adUnitId fromViewController:self];
    }else{
        NSString *msg = @"video still not ready";
        [self showMsg:msg];
    }
}
```

## Adapter Version
 You can see the adapter version number in IronSourceAdapterHelper.h and MintegralAdapterVersion.h

## ChangeLog
Version | ChangeLog | Date
------|-----------|------
1.0.0	|Mediation ironsource |

​		 





