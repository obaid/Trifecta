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
@property (nonatomic) int boardSize;
@end

@implementation TrifectaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.gameType = 0;
        self.boardSize = 8;
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

- (IBAction)boardSizeChanged:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex] == 0) {
        self.boardSize = 8;
    } else if ([sender selectedSegmentIndex] == 1) {
        self.boardSize = 14;
    } else if ([sender selectedSegmentIndex] == 2) {
        self.boardSize = 20;
    } else if ([sender selectedSegmentIndex] == 3) {
        self.boardSize = 40;
    }

}

- (IBAction)startButtonPressed:(UIButton *)sender {
    
    GameViewController *gameViewController = [GameViewController new];
    gameViewController.gameType = self.gameType;
    gameViewController.numColumns = self.boardSize;
    [self presentModalViewController:gameViewController animated:YES];
}

- (IBAction)gameTypeValueChanged:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex] == 0) {
        self.gameType = 0;
    } else {
        self.gameType = 1;
    }
    
}
@end
