//
//  TrifectaViewController.m
//  Trifecta
//
//  Created by Ran Tao on 9.6.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "TrifectaViewController.h"
#import "GameViewController.h"

@interface TrifectaViewController ()

@end

@implementation TrifectaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
 
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (IBAction)smallButtonPressed:(UIButton *)sender {
    GameViewController *gameViewController = [GameViewController new];
    gameViewController.numColumns = 8;
    [self presentModalViewController:gameViewController animated:YES];
}

- (IBAction)mediumButtonPressed:(UIButton *)sender {
    GameViewController *gameViewController = [GameViewController new];
    gameViewController.numColumns = 14;
    [self presentModalViewController:gameViewController animated:YES];
}

- (IBAction)largeButtonPressed:(UIButton *)sender {
    GameViewController *gameViewController = [GameViewController new];
    gameViewController.numColumns = 20;
    [self presentModalViewController:gameViewController animated:YES];
}

- (IBAction)extraLargeButtonPressed:(UIButton *)sender {
    GameViewController *gameViewController = [GameViewController new];
    gameViewController.numColumns = 40;
    [self presentModalViewController:gameViewController animated:YES];
}
@end
