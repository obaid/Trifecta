//
//  TrifectaViewController.m
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.6.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//

#import "TrifectaViewController.h"
#import "GameViewController.h"

@interface TrifectaViewController ()
@property (nonatomic) int gameType;
@end

@implementation TrifectaViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.gameType = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setGameTypeSegmentedControl:nil];
    [super viewDidUnload];
}

- (IBAction)startButtonPressed:(UIButton *)sender {
    
    GameViewController *gameViewController = [GameViewController new];
    gameViewController.gameType = self.gameType;
    if (sender.tag == 0) {
        gameViewController.numColumns = 8;
    } else if (sender.tag == 1) {
        gameViewController.numColumns = 14;
    } else if (sender.tag == 2) {
        gameViewController.numColumns = 20;
    } else {
        gameViewController.numColumns = 40;
    }
    [self presentModalViewController:gameViewController animated:YES];
}

- (IBAction)gameTypeValueChanged:(UISegmentedControl *)sender {
    if ([self.gameTypeSegmentedControl selectedSegmentIndex] == 0) {
        self.gameType = 0;
    } else {
        self.gameType = 1;
    }
    
}
@end
