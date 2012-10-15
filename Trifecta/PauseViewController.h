//
//  PauseViewController.h
//  Trifecta
//
//  Created by Ran Tao on 10.14.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PauseViewDelegate <NSObject>

-(void) continueButtonPressed;
-(void) giveUpButtonPressed;

@end

@interface PauseViewController : UIViewController
@property (weak, nonatomic) id <PauseViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *pauseView;
@property (weak, nonatomic) IBOutlet UILabel *pauseLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *giveUpButton;
- (IBAction)giveUpButtonPressed:(UIButton *)sender;
- (IBAction)continueButtonPressed:(UIButton *)sender;

@end
