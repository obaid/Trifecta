//
//  PauseViewController.m
//  Trifecta
//
//  Created by Ran Tao on 10.14.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "PauseViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface PauseViewController ()

@end

@implementation PauseViewController

- (id)init
{
    NSString *nibName = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        nibName = @"PauseViewController";
    } else {
        nibName = @"PauseViewController-iPad";
    }
    NSBundle *bundle = nil;
    self = [super initWithNibName:nibName bundle:bundle];
    if (self) {

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pauseView.layer.backgroundColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] CGColor];
    self.pauseView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.pauseView.layer.borderWidth = 1;
    self.pauseView.layer.cornerRadius = 10;
    self.pauseView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.pauseView.layer.shadowOpacity = 0.6;
    self.pauseView.layer.shadowOffset = CGSizeMake(0.0,0.0);
    self.pauseLabel.font = [UIFont fontWithName:@"04b03" size:24];

    self.continueButton.titleLabel.font = [UIFont fontWithName:@"04b03" size:18];
    self.continueButton.backgroundColor = [UIColor clearColor];
;
    self.giveUpButton.titleLabel.font = [UIFont fontWithName:@"04b03" size:18];
    self.giveUpButton.backgroundColor = [UIColor clearColor];

}

-(void) viewWillAppear:(BOOL)animated {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPauseLabel:nil];
    [self setPauseView:nil];
    [self setContinueButton:nil];
    [self setGiveUpButton:nil];
    [super viewDidUnload];
}

- (IBAction)giveUpButtonPressed:(UIButton *)sender {
    [self.delegate giveUpButtonPressed]; 
}

- (IBAction)continueButtonPressed:(UIButton *)sender {
    [self.delegate continueButtonPressed];
}
@end
