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
}

- (IBAction)startButtonPressed:(UIButton *)sender {
    
    GameViewController *gameViewController = [GameViewController new];
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
@end
