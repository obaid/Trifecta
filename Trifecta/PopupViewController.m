//
//  PopupViewController.m
//  Trifecta
//
//  Created by Kris Fields on 10/14/12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "PopupViewController.h"

@interface PopupViewController ()
@property (strong, nonatomic) NSString* firstLabelText;
@property (strong, nonatomic) NSString *secondLabelText;
@property (strong, nonatomic) NSString *yesButtonText;
@property (strong, nonatomic) NSString *noButtonText;
@end

@implementation PopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    self.popUpView.alpha = .9;
    self.firstLabel.text = self.firstLabelText;
    self.secondLabel.text = self.secondLabelText;
    self.noButtonLabel.titleLabel.text = self.noButtonText;
    self.yesButtonLabel.titleLabel.text = self.yesButtonText;
    // Do any additional setup after loading the view from its nib.
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
