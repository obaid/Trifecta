//
//  GameViewController.m
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.5.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "GameViewController.h"
#import "Column.h"
#import "Cell.h"
#import "GameBoardView.h"
#import "PopupViewController.h"
#import "PauseViewController.h"

@interface GameViewController () </*UIAlertViewDelegate,UIActionSheetDelegate,*/ PopUpViewDelegate, PauseViewDelegate>
@property (nonatomic, strong) GameBoardView* gameBoard;

@property (nonatomic) UIButton *pauseButton;
@property (nonatomic) UIButton *soundButton;
@property (nonatomic) CALayer *timeBar;
@property (nonatomic) NSInteger highScore;
@property (nonatomic, strong) NSTimer *timeBarTimer;
@property (nonatomic) BOOL timeBarIsNotRed;
@property (nonatomic, strong) NSTimer *runningOutOfTimeTimer;
@property (nonatomic, strong) NSTimer *addCellsTimer;
@property (nonatomic) BOOL hasHighScore;
@property (nonatomic, strong) AVAudioPlayer *playerFail;
@property (nonatomic, strong) PopupViewController *popUpViewController;
@property (nonatomic, strong) PauseViewController *pauseViewController;

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation GameViewController

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
    self.view.backgroundColor = [UIColor whiteColor];

    if ([self getSoundSettingFromUserDefaults]) {
        self.sound = [[self getSoundSettingFromUserDefaults] boolValue];
    } else {
        self.sound = YES;
    }
    [self setUpGame];
}

-(void) countdownTimeBar {
    int timePastCounter = self.view.frame.size.width/64;
    if (self.timePast <= self.view.frame.size.width) {
        self.timeBar.frame = CGRectMake(0,0, self.view.frame.size.width - self.timePast, timePastCounter);
        self.timePast +=timePastCounter;
//        [self countdownTimeBarBlinkingWithColor:UIColorFromRGB(0xAD00FF)];
    } else {
        [self gameOver];
        if (self.hasHighScore) {
//            [[[UIAlertView alloc] initWithTitle:@"Time's up! Play again?\nNew high score!" message:[NSString stringWithFormat:@"Your final score was: %d", self.gameBoard.score] delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles: @"Yes please", nil] show];
            self.popUpViewController = [[PopupViewController alloc] initWithFirstLabel:@"Time's up! Play again?\nNew high score!" andSecondLabel:[NSString stringWithFormat:@"Your final score was: %d", self.gameBoard.score] andNoButtonText:@"No thanks" andYesButtonText:@"Yes please"];
        } else {
//            [[[UIAlertView alloc] initWithTitle:@"Time's up! Play again?" message:[NSString stringWithFormat:@"Your final score was: %d\nYour high score is: %d",self.gameBoard.score, self.highScore] delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles: @"Yes please", nil] show];
            self.popUpViewController = [[PopupViewController alloc] initWithFirstLabel:@"Time's up! Play again?" andSecondLabel:[NSString stringWithFormat:@"Your final score was: %d\nYour high score is: %d",self.gameBoard.score, self.highScore] andNoButtonText:@"No thanks" andYesButtonText:@"Yes please"];        }
        self.popUpViewController.delegate = self;
        [self.view addSubview:self.popUpViewController.view];
    
    
    }
}
-(void) countdownTimeBarBlinkingWithColor:(UIColor *)color {
    if (self.timeBarIsNotRed) {
        self.timeBar.backgroundColor = [[UIColor redColor] CGColor];
        self.view.backgroundColor = [UIColor whiteColor];
    } else {
        self.timeBar.backgroundColor = [color CGColor];
        self.view.backgroundColor = UIColorFromRGB(0xFFE2F3);
    }
    self.timeBarIsNotRed = !self.timeBarIsNotRed;
}
- (void) disableGameBoard
{
    self.gameBoard.userInteractionEnabled = NO;
    self.pauseButton.userInteractionEnabled = NO;
    self.soundButton.userInteractionEnabled = NO;
}
-(void) lossByBlocks {
    if (self.gameType == 1) {
        [self gameOver];
        if (self.hasHighScore) {
//            [[[UIAlertView alloc] initWithTitle:@"Too many blocks! Play again?\nNew high score!" message:[NSString stringWithFormat:@"Your final score was: %d", self.gameBoard.score] delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles: @"Yes please", nil] show];
            self.popUpViewController = [[PopupViewController alloc] initWithFirstLabel:@"Too many blocks! Play again?\nNew high score!" andSecondLabel:[NSString stringWithFormat:@"Your final score was: %d", self.gameBoard.score] andNoButtonText:@"No thanks" andYesButtonText:@"Yes please"];
        } else {
//            [[[UIAlertView alloc] initWithTitle:@"Too many blocks! Play again?" message:[NSString stringWithFormat:@"Your final score was: %d\nYour high score is: %d",self.gameBoard.score, self.highScore] delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles: @"Yes please", nil] show];
            self.popUpViewController = [[PopupViewController alloc] initWithFirstLabel:@"Too many blocks! Play again?" andSecondLabel:[NSString stringWithFormat:@"Your final score was: %d\nYour high score is: %d",self.gameBoard.score, self.highScore] andNoButtonText:@"No thanks" andYesButtonText:@"Yes please"];
        }
        self.popUpViewController.delegate = self;
        [self.view addSubview:self.popUpViewController.view];
    }
}
-(void) gameOver {
    [self.timeBarTimer invalidate];
    [self.addCellsTimer invalidate];
    [self.runningOutOfTimeTimer invalidate];
    [self disableGameBoard];
    self.highScore = [self getHighScoreFromUserDefaultsForSize:self.numColumns withGameType:self.gameType];
    if (self.gameBoard.score > self.highScore) {
        self.hasHighScore = YES;
        self.highScore = self.gameBoard.score;
        [self saveLocationsToUserDefaultsForSize:self.numColumns withGameType:self.gameType withScore:self.gameBoard.score];
    }
}

-(NSNumber*) getSoundSettingFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults objectForKey:@"sound"];
    NSNumber *sound = [userDefaults objectForKey:@"sound"];
    return sound;
}

-(void) saveSoundSettingToUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:self.sound forKey:@"sound"];
}


-(NSInteger) getHighScoreFromUserDefaultsForSize:(int) size withGameType:(int) type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger score = [userDefaults integerForKey:[NSString stringWithFormat:@"%dscore%d",size, type]];
    return score;
}

-(void) saveLocationsToUserDefaultsForSize:(int) size withGameType:(int) type withScore:(NSInteger) score {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:score forKey:[NSString stringWithFormat:@"%dscore%d",size,type]];
}

-(void) addNewCells {
    [self.gameBoard addNewCellWithColor:[self randomColor]withSize:self.gameBoard.frame.size.width / self.numColumns];
}



-(void)tearDownGame
{
    //    self.view.layer.sublayers = nil;
    self.hasHighScore = NO;
    [self.gameBoard removeFromSuperview];
    [self.scoreTextLabel removeFromSuperview];
    [self.soundButton removeFromSuperview];
    [self.pauseButton removeFromSuperview];
}


-(void)setUpGame
{
    //    self.numColumns = 20;
    self.timePast = 0;
    self.timeBarIsNotRed = NO;
//    [self countdownTimeBarBlinkingWithColor:UIColorFromRGB(0xAD00FF)];
    double sizeOfCell = (self.view.frame.size.width-(self.view.frame.size.width*.075))/self.numColumns;
    int numRows = (self.view.frame.size.height-(self.view.frame.size.height*.13333))/sizeOfCell;
    int boardGameHeight = self.view.frame.size.height*0.8671875;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        numRows = boardGameHeight/sizeOfCell;
    } 
    
    int boardGameWidth = self.numColumns * sizeOfCell;
    boardGameHeight = numRows * sizeOfCell;
    double boardGameYStart = (self.view.frame.size.height - boardGameHeight)/2.0 + 20.0;
    double boardGameXStart = (self.view.frame.size.width - boardGameWidth)/2.0;
    NSMutableArray *tempColumns = [NSMutableArray new];
    self.gameBoard = [[GameBoardView alloc] initWithFrame:CGRectMake(boardGameXStart, boardGameYStart, boardGameWidth, boardGameHeight)];
    self.gameBoard.counter = 0;
    self.gameBoard.numRows = numRows;
    self.gameBoard.gameViewController = self;
    self.gameBoard.numColumns = self.numColumns;
    [self.view addSubview:self.gameBoard];
    int randomSeedNumber = arc4random();
    srand(randomSeedNumber);
    self.scoreTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/40.0, self.view.frame.size.width -20, 40)];
    self.scoreTextLabel.font = [UIFont fontWithName:@"04b03" size:24];
    self.scoreTextLabel.textColor = UIColorFromRGB(0xFF0095);
    self.scoreTextLabel.text=[NSString stringWithFormat:@"Score: %d",self.gameBoard.score];
    self.scoreTextLabel.backgroundColor = [UIColor clearColor];
    self.scoreTextLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:self.scoreTextLabel];
    
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"pause24.png"] forState:UIControlStateNormal];
    self.pauseButton.frame = CGRectMake(self.view.frame.size.width/16.0*15.0-20, self.view.frame.size.height/24.0, 24 , 24);
    self.pauseButton.contentMode = UIViewContentModeCenter;
    [self.pauseButton addTarget:self action:@selector(pauseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseButton];
    
    self.soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.sound) {
        [self.soundButton setBackgroundImage:[UIImage imageNamed:@"sound24.png"] forState:UIControlStateNormal];
    } else {
        [self.soundButton setBackgroundImage:[UIImage imageNamed:@"mute24.png"] forState:UIControlStateNormal];
    }
    self.soundButton.frame = CGRectMake(self.view.frame.size.width/16.0, self.view.frame.size.height/24.0, 24 , 24);
    self.soundButton.contentMode = UIViewContentModeCenter;
    [self.soundButton addTarget:self action:@selector(soundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.soundButton];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSString *music = [[NSBundle mainBundle] pathForResource:@"failed" ofType:@"wav"];
    self.playerFail = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:music] error:NULL];
    [self.playerFail prepareToPlay];
    
    
    if (self.gameType == 0) {
        self.timeBar = [CALayer new];
        self.timeBar.backgroundColor = [[UIColor redColor] CGColor];
        self.timeBar.frame = CGRectMake(0,0, self.view.frame.size.width, 5);
        [self.view.layer addSublayer:self.timeBar];
        [self setupTimerBarWithInterval:1.0];
        [self setupRunningOutOfTimeTimer];
        
    }
    [self setupCellsTimerWithInterval:0.3];
    
    
    
    for (int c=0; c < self.numColumns; c++) {
        Column *column = [Column new];
        column.columnPosition = c;
        column.numRows = numRows;
        for (int r=0; r < numRows/(self.gameType+1); r++) {
            Cell *cell = [[Cell alloc] initWithBoard:self.gameBoard withColor:[self randomColor] withRow:r withColumn:c withSize:self.gameBoard.frame.size.width / self.numColumns];
            cell.isFalling = NO;
            //            [self.gameBoard frameEachCellWithCell:cell];
            [column.cells addObject:cell];
        }
        [tempColumns addObject:column];
    }
    self.gameBoard.columns = tempColumns;
    [self.gameBoard drawGameBoard];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


-(void) setupTimerBarWithInterval:(double) interval  {
    self.timeBarTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(countdownTimeBar) userInfo:nil repeats:YES];
}

-(void) setupCellsTimerWithInterval:(double) interval {
    self.addCellsTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(addNewCells) userInfo:nil repeats:YES];
    
}
-(void) setupRunningOutOfTimeTimer {
    self.runningOutOfTimeTimer = [NSTimer scheduledTimerWithTimeInterval:.15 target:self selector:@selector(runningOutOfTime) userInfo:nil repeats:YES];
}
-(void) runningOutOfTime {
    if (self.view.frame.size.width - self.timePast < (5*(self.view.frame.size.width/64))) {
        [self countdownTimeBarBlinkingWithColor:[UIColor whiteColor]];
    } else {
        if (self.timeBarIsNotRed) {
            self.view.backgroundColor = [UIColor whiteColor];
            self.timeBar.backgroundColor = [[UIColor redColor] CGColor];
        }
    }
}
-(void) soundButtonPressed:(UIButton *) button {
    if (self.sound) {
        [self.soundButton setBackgroundImage:[UIImage imageNamed:@"mute24.png"] forState:UIControlStateNormal];

    } else {
        [self.soundButton setBackgroundImage:[UIImage imageNamed:@"sound24.png"] forState:UIControlStateNormal];
    }
    self.sound =!self.sound;
    [self saveSoundSettingToUserDefaults];
}

-(void) pauseButtonPressed:(UIButton*) button {
    [self.timeBarTimer invalidate];
    [self.addCellsTimer invalidate];
    [self.runningOutOfTimeTimer invalidate];
    
    self.pauseViewController = [[PauseViewController alloc] initWithNibName:@"PauseViewController" bundle:nil];
    self.pauseViewController.delegate = self;
    [self.view addSubview:self.pauseViewController.view];
    
    //Use an action sheet instead of an alertview
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        // The device is an iPad running iPhone 3.2 or later.
//        UIActionSheet *pauseAction = [[UIActionSheet alloc] initWithTitle:@"TRIFECTA PAUSED" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: @"Continue Playing", @"I Give Up", nil];
//        [pauseAction showInView:self.view];
//    }
//    else
//    {
//        // The device is an iPhone or iPod touch.
//        UIActionSheet *pauseAction = [[UIActionSheet alloc] initWithTitle:@"TRIFECTA PAUSED" delegate:self cancelButtonTitle:@"I Give Up" destructiveButtonTitle:nil otherButtonTitles: @"Continue Playing",nil];
//        [pauseAction showInView:self.view];
//    }
}

//-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        [self setupCellsTimerWithInterval:0.3];
//        [self setupTimerBarWithInterval:1.0];
//        [self setupRunningOutOfTimeTimer];
//    } else if (buttonIndex == 1){
//        //end game
//        [self dismissModalViewControllerAnimated:YES];
//    } else {
//        if (self.sound) {
//            NSString *music = [[NSBundle mainBundle] pathForResource:@"failed" ofType:@"wav"];
//            self.playerFail = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:music] error:NULL];
//            [self.playerFail play];
//        }
//        UIButton *randomButton = [UIButton new];
//        [self pauseButtonPressed:randomButton];
//        //        [self actionSheet:actionSheet clickedButtonAtIndex:0];
//    }
//}

-(UIColor *)randomColor
{
    NSArray *arrayOfColors = [NSArray new];
    if (self.numColumns < 10) {
        arrayOfColors = @[UIColorFromRGB(0xAD00FF), UIColorFromRGB(0xFF0095), UIColorFromRGB(0x0040FF)];
        return [arrayOfColors objectAtIndex:rand() % 3];
        
    } else if (self.numColumns < 14){
        arrayOfColors = @[UIColorFromRGB(0x12C100), UIColorFromRGB(0xAD00FF), UIColorFromRGB(0xFF0095), UIColorFromRGB(0x0040FF)];
        return [arrayOfColors objectAtIndex:rand() % 4];
        
    } else if (self.numColumns < 20){
        arrayOfColors = @[UIColorFromRGB(0x12C100), UIColorFromRGB(0xAD00FF), UIColorFromRGB(0xFF0095), UIColorFromRGB(0x0040FF),UIColorFromRGB(0xFFEE00)];
        return [arrayOfColors objectAtIndex:rand() % 5];
        
    }else {
        arrayOfColors = @[UIColorFromRGB(0xAD00FF), UIColorFromRGB(0xFF0095), UIColorFromRGB(0x0040FF), UIColorFromRGB(0x12C100), UIColorFromRGB(0xFF9000), UIColorFromRGB(0xFFEE00)];
        return [arrayOfColors objectAtIndex:rand() % 6];
        
    }
    
}
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint touchPoint = [[touches anyObject] locationInView:self.gameBoard];
//    if (CGRectContainsPoint(self.gameBoard.bounds, touchPoint)){
//        [self.gameBoard touchedAtPoint:touchPoint andEndedMove:NO];
//    }
//}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint touchPoint = [[touches anyObject] locationInView:self.gameBoard];
//    if (CGRectContainsPoint(self.gameBoard.bounds, touchPoint)){
//        [self.gameBoard touchedAtPoint:touchPoint andEndedMove:YES];
//        self.scoreTextLabel.text = [NSString stringWithFormat:@"Score: %d",self.gameBoard.score];
//    }
//}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag ==1) {
//        if (buttonIndex == 0) {
//            [self setupCellsTimerWithInterval:0.3];
//            [self setupTimerBarWithInterval:1.0];
//            [self setupRunningOutOfTimeTimer];
//        } else if (buttonIndex == 1){
//            //end game
//            [self dismissModalViewControllerAnimated:YES];
//        }
//    } else {
//        if (buttonIndex == 0) {
//            [self dismissModalViewControllerAnimated:YES];
//        }
//        else {
//            [self tearDownGame];
//            [self setUpGame];
//        }
//    }
//}

- (void)noButtonPressed
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)yesButtonPressed
{
    [self tearDownGame];
    [self setUpGame];
}

-(void) continueButtonPressed {
    [self.pauseViewController.view removeFromSuperview];
    [self setupCellsTimerWithInterval:0.3];
    [self setupTimerBarWithInterval:1.0];
    [self setupRunningOutOfTimeTimer];
    
}
-(void) giveUpButtonPressed {
    [self dismissModalViewControllerAnimated:YES];

}

@end
