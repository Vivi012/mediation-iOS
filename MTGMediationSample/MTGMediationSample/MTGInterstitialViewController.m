//
//  MTGInterstitialViewController.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/24.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGInterstitialViewController.h"

@interface MTGInterstitialViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@end

@implementation MTGInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Interstitial";
    self.showButton.userInteractionEnabled = NO;
}

- (IBAction)loadInterstitialAction:(id)sender {
}

- (IBAction)showInterstitialAction:(id)sender {
}

@end
