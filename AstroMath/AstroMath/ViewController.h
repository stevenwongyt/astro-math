//
//  ViewController.h
//  AstroMath
//
//  Created by steven wong on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *background2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scTouchTiltOutlet;
@property (weak, nonatomic) IBOutlet UILabel *gameTitle;
@property (weak, nonatomic) IBOutlet UIImageView *asteroid3;
@property (weak, nonatomic) IBOutlet UIImageView *asteroid2;
@property (weak, nonatomic) IBOutlet UIImageView *asteroid1;
@property (weak, nonatomic) IBOutlet UIButton *backBtnOutlet;
- (IBAction)backButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *shuttle;
@property (weak, nonatomic) IBOutlet UIButton *HighscoreOutlet;
@property (weak, nonatomic) IBOutlet UIButton *settingOutlet;
@property (weak, nonatomic) IBOutlet UIButton *playBtnOutlet;
- (IBAction)highScoreButton:(id)sender;
- (IBAction)settingsButton:(id)sender;
- (IBAction)playButton:(id)sender;
- (IBAction)scTouchTilt:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIImageView *wall1;
@property (weak, nonatomic) IBOutlet UIImageView *wall2;
@property (weak, nonatomic) IBOutlet UIImageView *wall3;
@property (weak, nonatomic) IBOutlet UIImageView *wallUnderAns1And2;
@property (weak, nonatomic) IBOutlet UIImageView *wall;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UILabel *answer3;
@property (weak, nonatomic) IBOutlet UILabel *answer2;
@property (weak, nonatomic) IBOutlet UILabel *answer1;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
