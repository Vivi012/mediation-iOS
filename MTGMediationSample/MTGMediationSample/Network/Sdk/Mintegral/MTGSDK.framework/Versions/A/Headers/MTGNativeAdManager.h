//
//  MTGNativeAdManager.h
//  MTGSDK
//
//  Created by Jomy on 15/10/14.
//

#import "MTGCampaign.h"

@class MTGNativeAdManager;
typedef NS_ENUM(NSInteger, MTGAdCategory) {
    MTGAD_CATEGORY_ALL  = 0,
    MTGAD_CATEGORY_GAME = 1,
    MTGAD_CATEGORY_APP  = 2,
};

#pragma mark - MTGNativeAdManagerDelegate

/*!
 @protocol MTGNativeAdManagerDelegate
 
 @abstract Messages from MTGNativeAdManager indicating success or failure loading ads.
 */

@protocol MTGNativeAdManagerDelegate <NSObject>

@optional
/*!
 @method
 
 @abstract When the MTGNativeAdManager has finished loading a batch of ads this message will be sent. A batch of ads may be loaded in response to calling loadAds.
 @param nativeAds A array contains native ads (MTGCampaign).
 
 */
- (void)nativeAdsLoaded:(nullable NSArray *)nativeAds DEPRECATED_ATTRIBUTE;
- (void)nativeAdsLoaded:(nullable NSArray *)nativeAds nativeManager:(nonnull MTGNativeAdManager *)nativeManager;


/*!
 @method
 
 @abstract When the MTGNativeAdManager has reached a failure while attempting to load a batch of ads this message will be sent to the application.
 @param error An NSError object with information about the failure.
 
 */
- (void)nativeAdsFailedToLoadWithError:(nonnull NSError *)error DEPRECATED_ATTRIBUTE;
- (void)nativeAdsFailedToLoadWithError:(nonnull NSError *)error nativeManager:(nonnull MTGNativeAdManager *)nativeManager;

/*!
 @method
 
 @abstract When the MTGNativeAdManager has finished loading a batch of frames this message will be sent. A batch of frames may be loaded in response to calling loadAds.
 @param nativeFrames A array contains native frames (MTGFrame).
 
 @deprecated This method has been deprecated.
 */
- (void)nativeFramesLoaded:(nullable NSArray *)nativeFrames DEPRECATED_ATTRIBUTE;

/*!
 @method
 
 @abstract When the MTGNativeAdManager has reached a failure while attempting to load a batch of frames this message will be sent to the application.
 @param error An NSError object with information about the failure.
 
 @deprecated This method has been deprecated.
 */
- (void)nativeFramesFailedToLoadWithError:(nonnull NSError *)error DEPRECATED_ATTRIBUTE;

/*!
 @method
 
 @abstract
 Sent after an ad has been clicked by a user.
 
 @param nativeAd An MTGCampaign object sending the message.
 */
- (void)nativeAdDidClick:(nonnull MTGCampaign *)nativeAd DEPRECATED_ATTRIBUTE;
- (void)nativeAdDidClick:(nonnull MTGCampaign *)nativeAd nativeManager:(nonnull MTGNativeAdManager *)nativeManager;


/*!
 @method
 
 @abstract
 Sent after an ad url did start to resolve.
 
 @param clickUrl The click url of the ad.
 */
- (void)nativeAdClickUrlWillStartToJump:(nonnull NSURL *)clickUrl DEPRECATED_ATTRIBUTE;
- (void)nativeAdClickUrlWillStartToJump:(nonnull NSURL *)clickUrl nativeManager:(nonnull MTGNativeAdManager *)nativeManager;
/*!
 @method
 
 @abstract
 Sent after an ad url has jumped to a new url.
 
 @param jumpUrl The url during jumping.
 
 @discussion It will not be called if a ad's final jump url has been cached
 */
- (void)nativeAdClickUrlDidJumpToUrl:(nonnull NSURL *)jumpUrl DEPRECATED_ATTRIBUTE;
- (void)nativeAdClickUrlDidJumpToUrl:(nonnull NSURL *)jumpUrl nativeManager:(nonnull MTGNativeAdManager *)nativeManager;


/*!
 @method
 
 @abstract
 Sent after an ad url did reach the final jump url.
 
 @param finalUrl the final jump url of the click url.
 @param error the error generated between jumping.
 */
- (void)nativeAdClickUrlDidEndJump:(nullable NSURL *)finalUrl
                             error:(nullable NSError *)error DEPRECATED_ATTRIBUTE;

- (void)nativeAdClickUrlDidEndJump:(nullable NSURL *)finalUrl
                             error:(nullable NSError *)error nativeManager:(nonnull MTGNativeAdManager *)nativeManager;


- (void)nativeAdImpressionWithType:(MTGAdSourceType)type nativeManager:(nonnull MTGNativeAdManager *)nativeManager;

@end


#pragma mark - MTGNativeAdManager

@interface MTGNativeAdManager : NSObject

/*!
 @property
 
 @abstract The delegate
 
 @discussion All delegate method will be called in main thread.
 */
@property (nonatomic, weak, nullable) id <MTGNativeAdManagerDelegate> delegate;

/*!
 @property
 
 @discussion Show the  loading view when to click on ads.
    The default is yes
 */
@property (nonatomic, assign) BOOL showLoadingView;

/*!
 @property
 
 @discussion DEPRECATED_ATTRIBUTE
 Mintegral support configuration： https://www.mintegral.net
 */
@property (nonatomic, readonly) BOOL videoSupport DEPRECATED_ATTRIBUTE;

/*!
 @property
 
 @discussion ad current UnitId .
 */
@property (nonatomic, readonly) NSString * _Nonnull currentUnitId;
/*!
 @property
 
 @discussion The current ViewController of display ad. 
 the "ViewController" parameters are assigned as calling the init or Registerview method
 */
@property (nonatomic, weak) UIViewController * _Nullable  viewController;


/*!
 @method

 @abstract Initialize the native ads manager which is for loading ads. (MTGCampaign)

 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param fbPlacementId The Facebook PlacementID is used to request ads from Facebook. You can also set the placementID in our portal. The ID you set in our web portal will replace the ID you set here in future.
 @param numAdsRequested The number of ads you would like the native ad manager to retrieve. Max number is 10. If you pass any number bigger than 10, it will be reset to 10.
 @param viewController The UIViewController that will be used to present SKStoreProductViewController
 (iTunes Store product information) or the in-app browser. If not set, it will be the root viewController of your current UIWindow. But it may failed to present our view controller if your rootViewController is presenting other view controller. So set this property is necessary.
 */
- (nonnull instancetype)initWithUnitID:(nonnull NSString *)unitId
                         fbPlacementId:(nullable NSString *)fbPlacementId
                    forNumAdsRequested:(NSUInteger)numAdsRequested
              presentingViewController:(nullable UIViewController *)viewController;

/*!
 @method
 
 @abstract Initialize the native ads manager which is for loading ads. (MTGCampaign)
 
 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param fbPlacementId The Facebook PlacementID is used to request ads from Facebook. You can also set the placementID in our portal. The ID you set in our web portal will replace the ID you set here in future.
 @param videoSupport DEPRECATED_ATTRIBUTE Mintegral support configuration： https://www.mintegral.net
 @param numAdsRequested The number of ads you would like the native ad manager to retrieve. Max number is 10. If you pass any number bigger than 10, it will be reset to 10.
 @param viewController The UIViewController that will be used to present SKStoreProductViewController
 (iTunes Store product information) or the in-app browser. If not set, it will be the root viewController of your current UIWindow. But it may failed to present our view controller if your rootViewController is presenting other view controller. So set this property is necessary.
 */
- (nonnull instancetype)initWithUnitID:(nonnull NSString *)unitId
                         fbPlacementId:(nullable NSString *)fbPlacementId
                          videoSupport:(BOOL)videoSupport
                    forNumAdsRequested:(NSUInteger)numAdsRequested
              presentingViewController:(nullable UIViewController *)viewController;

/*!
 @method
 
 @abstract Initialize the native ads manager which is for loading ads with more options.
 
 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param fbPlacementId The Facebook PlacementID is used to request ads from Facebook. You can also set the placementID in our portal. The ID you set in our web portal will replace the ID you set here in future.
 @param templates This array contains objects of MTGTemplate. See more detail in definition of MTGTemplate.
 @param autoCacheImage If you pass YES, SDK will download the image resource automatically when you get the campaign. The default is NO.
 @param adCategory Decide what kind of ads you want to retrieve. Games, apps or all of them. The default is All.
 @param viewController The UIViewController that will be used to present SKStoreProductViewController
 (iTunes Store product information) or the in-app browser. If not set, it will be the root viewController of your current UIWindow. But it may failed to present our view controller if your rootViewController is presenting other view controller. So set this property is necessary.
 */
- (nonnull instancetype)initWithUnitID:(nonnull NSString *)unitId
                         fbPlacementId:(nullable NSString *)fbPlacementId
                    supportedTemplates:(nullable NSArray *)templates
                        autoCacheImage:(BOOL)autoCacheImage
                            adCategory:(MTGAdCategory)adCategory
              presentingViewController:(nullable UIViewController *)viewController;

/*!
 @method
 
 @abstract The method that kicks off the loading of ads. It may be called again in the future to refresh the ads manually.
 
 @discussion It only works if you init the manager by the 2 method above.
 */
- (void)loadAds;

/*!
 @method
 
 @abstract Initialize the native ads manager which is for loading frames (MTGFrame).
 
 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param fbPlacementId The Facebook PlacementID is used to request ads from Facebook. You can also set the placementID in our portal. The ID you set in our web portal will replace the ID you set here in future.
 @param frameNum The number of frame you would like the native ad manager to retrieve.
 @param templates This array contains objects of MTGTemplate. See more detail in definition of MTGTemplate.
 @param autoCacheImage If you pass YES, SDK will download the image resource automatically when you get the campaign. The default is NO.
 @param adCategory Decide what kind of ads you want to retrieve. Games, apps or all of them. The default is All.
 @param viewController The UIViewController that will be used to present SKStoreProductViewController
 (iTunes Store product information) or the in-app browser. If not set, it will be the root viewController of your current UIWindow. But it may failed to present our view controller if your rootViewController is presenting other view controller. So set this property is necessary.
 
 @discussion It's different with the method initWithUnitID:fbPlacementId:forNumAdsRequested:presentingViewController: We will return arrays of MTGFrame rather than MTGCampaign to you. A MTGFrame may contain multiple MTGCampaigns. See more detail in MTGFrame.
 
 @deprecated This method has been deprecated.
 */
- (nonnull instancetype)initWithUnitID:(nonnull NSString *)unitId
                         fbPlacementId:(nullable NSString *)fbPlacementId
                              frameNum:(NSUInteger)frameNum
                    supportedTemplates:(nullable NSArray *)templates
                        autoCacheImage:(BOOL)autoCacheImage
                            adCategory:(MTGAdCategory)adCategory
              presentingViewController:(nullable UIViewController *)viewController DEPRECATED_ATTRIBUTE;


/*!
 @method
 
 @abstract The method that kicks off the loading of frames. It may be called again in the future to refresh the frames manually.
 
 @discussion It only works if you init the manager by the the method above.

 @deprecated This method has been deprecated.
 */
- (void)loadFrames DEPRECATED_ATTRIBUTE;

/*!
 @method
 
 @abstract
 This is a method to associate a MTGCampaign with the UIView you will use to display the native ads.
 
 @param view The UIView you created to render all the native ads data elements.
 @param campaign The campaign you associate with the view.
 
 @discussion The whole area of the UIView will be clickable.
 */
- (void)registerViewForInteraction:(nonnull UIView *)view
                      withCampaign:(nonnull MTGCampaign *)campaign;

/*!
 @method
 
 @abstract
 This is a method to disconnect a MTGCampaign with the UIView you used to display the native ads.
 
 @param view The UIView you created to render all the native ads data elements.

 */
- (void)unregisterView:(nonnull UIView *)view;

/*!
 @method
 
 @abstract
 This is a method to associate a MTGCampaign with the UIView you will use to display the native ads and set clickable areas.
 
 @param view The UIView you created to render all the native ads data elements.
 @param clickableViews An array of UIView you created to render the native ads data element, e.g. CallToAction button, Icon image, which you want to specify as clickable.
 @param campaign The campaign you associate with the view.
 
 */
- (void)registerViewForInteraction:(nonnull UIView *)view
                withClickableViews:(nonnull NSArray *)clickableViews
                      withCampaign:(nonnull MTGCampaign *)campaign;

/*!
 @method
 
 @abstract
 This is a method to disconnect a MTGCampaign with the UIView you used to display the native ads.
 
 @param view The UIView you created to render all the native ads data elements.
 @param clickableViews An array of UIView you created to render the native ads data element, e.g. CallToAction button, Icon image, which you want to specify as clickable.
 
 */
- (void)unregisterView:(nonnull UIView *)view clickableViews:(nonnull NSArray *)clickableViews;

/*!
 @method
 
 This is a method to clean the cache nativeAd .
 
 */
- (void)cleanAdsCache;

/*!
 @method

 Set the video display area size.
 
 @param size The display area size.
 
 */
-(void)setVideoViewSize:(CGSize)size;

/*!
 @method
 
 @abstract
 Set the video display area size.
 
 @param width The display area width.
 @param height The display area height.
 */
-(void)setVideoViewSizeWithWidth:(CGFloat)width height:(CGFloat)height;


@end

