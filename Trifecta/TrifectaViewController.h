//
//  TrifectaViewController.h
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.6.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrifectaViewController : UIViewController
- (IBAction)boardSizeChanged:(UISegmentedControl *)sender;
- (IBAction)startButtonPressed:(UIButton *)sender;
- (IBAction)gameTypeValueChanged:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *boardSizeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *highScoresButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
- (IBAction)infoButtonPressed:(UIButton *)sender;
- (IBAction)highScoresButtonPressed:(UIButton *)sender;

@end
