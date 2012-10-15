//
//  PopupViewController.m
//  Trifecta
//
//  Created by Kris Fields on 10/14/12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "PopupViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface PopupViewController ()
@property (strong, nonatomic) NSString* firstLabelText;
@property (strong, nonatomic) NSString *secondLabelText;
@property (strong, nonatomic) NSString *yesButtonText;
@property (strong, nonatomic) NSString *noButtonText;
@end

@implementation PopupViewController

- (id)init
{
    NSString *nibName = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        nibName = @"PopupViewController";
    } else {
        nibName = @"PopupViewController-iPad";
    }
    NSBundle *bundle = nil;
    self = [super initWithNibName:nibName bundle:bundle];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    return [self init];
}


-(id)initWithFirstLabel:(NSString *)firstLabel andSecondLabel:(NSString *)secondLabel andNoButtonText:(NSString *)noButton andYesButtonText:(NSString *)yesButton
{
    self = [super init];
    if (self) {
        self.firstLabelText = firstLabel;
        self.secondLabelText = secondLabel;
        self.noButtonText = noButton;
        self.yesButtonText = yesButton;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.popUpView.layer.backgroundColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] CGColor];
    self.popUpView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.popUpView.layer.borderWidth = 1;
    self.popUpView.layer.cornerRadius = 10;
    self.popUpView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.popUpView.layer.shadowOpacity = 0.6;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0,0.0);
    self.firstLabel.font = [UIFont fontWithName:@"04b03" size:16];
    self.secondLabel.font = [UIFont fontWithName:@"04b03" size:16];
    self.noButtonLabel.titleLabel.font = [UIFont fontWithName:@"04b03" size:18];
    self.yesButtonLabel.titleLabel.font = [UIFont fontWithName:@"04b03" size:18];
    self.noButtonLabel.backgroundColor = [UIColor clearColor];
    self.yesButtonLabel.backgroundColor = [UIColor clearColor];
    self.firstLabel.text = self.firstLabelText;
    self.secondLabel.text = self.secondLabelText;
    self.noButtonLabel.titleLabel.text = self.noButtonText;
    self.yesButtonLabel.titleLabel.text = self.yesButtonText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFirstLabel:nil];
    [self setSecondLabel:nil];
    [self setYesButtonLabel:nil];
    [self setNoButtonLabel:nil];
    [super viewDidUnload];
}
- (IBAction)yesButton:(id)sender {
    [self.delegate yesButtonPressed];
}

- (IBAction)noButton:(id)sender {
    [self.delegate noButtonPressed];
}

@end
