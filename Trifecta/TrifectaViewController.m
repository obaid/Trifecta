//
//  TrifectaViewController.m
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.6.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//

#import "TrifectaViewController.h"
#import "GameViewController.h"
#import "HighScoresViewController.h"
#import "InfoViewController.h"

@interface TrifectaViewController ()
@property (nonatomic) int gameType;
@property (nonatomic) int boardSize;
@end


@implementation TrifectaViewController
@synthesize boardSizeSegmentedControl = _boardSizeSegmentedControl;
@synthesize highScoresButton = _highScoresButton;
@synthesize gameTypeSegmentedControl = _gameTypeSegmentedControl;
@synthesize buttonsView = _buttonsView;
@synthesize backgroundView = _backgroundView;

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
    
    UIFont *font = [UIFont fontWithName:@"04b03" size:14];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    
    [self.gameTypeSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.boardSizeSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.highScoresButton.titleLabel.font = font;
   
}

-(void) viewWillAppear:(BOOL)animated {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.backgroundView.image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
        self.buttonsView.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/3.0*2.0);
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 568)
        {
            // iPhone 5
            self.backgroundView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
        }

    }

}

- (void)viewDidUnload
{
    [self setBoardSizeSegmentedControl:nil];
    [self setGameTypeSegmentedControl:nil];
    [self setHighScoresButton:nil];
    [self setButtonsView:nil];
    [self setBackgroundView:nil];
    [super viewDidUnload];
}

- (IBAction)boardSizeChanged:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex] == 0) {
        self.boardSize = 8;
    } else if ([sender selectedSegmentIndex] == 1) {
        self.boardSize = 12;
    } else if ([sender selectedSegmentIndex] == 2) {
        self.boardSize = 16;
    } else if ([sender selectedSegmentIndex] == 3) {
        self.boardSize = 20;
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

- (IBAction)infoButtonPressed:(UIButton *)sender {
    InfoViewController *infoViewController = [InfoViewController new];
    infoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:infoViewController animated:YES];
}

- (IBAction)highScoresButtonPressed:(UIButton *)sender {
    HighScoresViewController *highScoresViewController = [HighScoresViewController new];
    highScoresViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:highScoresViewController animated:YES];
    
}
@end
