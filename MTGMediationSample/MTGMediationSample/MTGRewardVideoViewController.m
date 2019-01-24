//
//  MTGRewardVideoViewController.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/24.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGRewardVideoViewController.h"
#import "MTGRewardVideo.h"

@interface MTGRewardVideoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@end

@implementation MTGRewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"RewardVideo";
    self.showButton.userInteractionEnabled = NO;
}

- (IBAction)loadRewardVideoAction:(id)sender {
    
    self.showButton.userInteractionEnabled = YES;

    return;
    [MTGRewardVideo loadRewardVideoAdWithAdUnitID:nil mediationSettings:nil];
}

- (IBAction)showRewardVideoAction:(id)sender {
    [MTGRewardVideo presentRewardVideoAdForAdUnitID:nil fromViewController:self];
}


@end
