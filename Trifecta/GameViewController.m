//
//  GameViewController.m
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.5.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//
#import "GameViewController.h"
#import "Column.h"
#import "Cell.h"
#import "GameBoardView.h"
#import <QuartzCore/QuartzCore.h>

@interface GameViewController () <UIAlertViewDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) GameBoardView* gameBoard;
@property (nonatomic) UILabel *scoreTextLabel;
@property (nonatomic) UIButton *pauseButton;
@property (nonatomic) CALayer *timeBar; 
@property (nonatomic) NSInteger highScore;
@property (nonatomic, strong) NSTimer *timeBarTimer;
@property (nonatomic, strong) NSTimer *addCellsTimer;
@property (nonatomic) BOOL hasHighScore;
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
    [self setUpGame];
}

-(void) countdownTimeBar {
    if (self.timePast <= self.view.frame.size.width) {
        self.timeBar.frame = CGRectMake(0,0, self.view.frame.size.width - self.timePast, 5);
        self.timePast +=5;
    } else {
        [self gameOver];
        if (self.hasHighScore) {
            [[[UIAlertView alloc] initWithTitle:@"Time's up! Play again?\nNew high score!" message:[NSString stringWithFormat:@"Your final score was: %d", self.gameBoard.score] delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles: @"Yes please", nil] show];
        } else {
        [[[UIAlertView alloc] initWithTitle:@"Time's up! Play again?" message:[NSString stringWithFormat:@"Your final score was: %d\nYour high score is: %d",self.gameBoard.score, self.highScore] delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles: @"Yes please", nil] show];
        }
        
    }
}
-(void) lossByBlocks {
    if (self.gameType == 1) {
        [self gameOver];
        if (self.hasHighScore) {
            [[[UIAlertView alloc] initWithTitle:@"Too many blocks! Play again?\nNew high score!" message:[NSString stringWithFormat:@"Your final score was: %d", self.gameBoard.score] delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles: @"Yes please", nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Too many blocks! Play again?" message:[NSString stringWithFormat:@"Your final score was: %d\nYour high score is: %d",self.gameBoard.score, self.highScore] delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles: @"Yes please", nil] show];
        }
    }
}
-(void) gameOver {
    [self.timeBarTimer invalidate];
    [self.addCellsTimer invalidate];
    self.highScore = [self getHighScoreFromUserDefaultsForSize:self.numColumns withGameType:self.gameType];
    if (self.gameBoard.score > self.highScore) {
        self.hasHighScore = YES;
        self.highScore = self.gameBoard.score;
        [self saveLocationsToUserDefaultsForSize:self.numColumns withGameType:self.gameType withScore:self.gameBoard.score];
    }
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1) {
        if (buttonIndex == 0) {
            [self setupCellsTimerWithInterval:0.3];
            [self setupTimerBarWithInterval:1.0];
        } else if (buttonIndex == 1){
            //end game
            [self dismissModalViewControllerAnimated:YES];
        }
    } else {
            if (buttonIndex == 0) {
                [self dismissModalViewControllerAnimated:YES];
            }
            else {
                [self tearDownGame];
                [self setUpGame];
            }
       }
}
//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    [self tearDownGame];
//    [self setUpGame];
////    [self dismissModalViewControllerAnimated:YES];
//    
//}
-(void)tearDownGame
{
//    self.view.layer.sublayers = nil;
    self.hasHighScore = NO;
    [self.gameBoard removeFromSuperview];
}


-(void)setUpGame
{
//    self.numColumns = 20;
    self.timePast = 0;
    double sizeOfCell = 296.0/self.numColumns;
    int numRows = 416/sizeOfCell;
    int boardGameWidth = self.numColumns * sizeOfCell;
    int boardGameHeight = numRows * sizeOfCell;
    double boardGameYStart = (self.view.frame.size.height - boardGameHeight)/2.0 + 20.0;
    double boardGameXStart = (self.view.frame.size.width - boardGameWidth)/2.0;
    NSMutableArray *tempColumns = [NSMutableArray new];
    self.gameBoard = [[GameBoardView alloc] initWithFrame:CGRectMake(boardGameXStart, boardGameYStart, boardGameWidth, boardGameHeight)];
    self.gameBoard.counter = 0;
    self.gameBoard.numRows = numRows;
    self.gameBoard.gameViewController = self;
    
    [self.view addSubview:self.gameBoard];
    int randomSeedNumber = arc4random();
    srand(42);
    self.scoreTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width -20, 40)];
    self.scoreTextLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:24];
    self.scoreTextLabel.textColor = UIColorFromRGB(0xFF0095);
    self.scoreTextLabel.text=[NSString stringWithFormat:@"Score: %d",self.gameBoard.score];
    self.scoreTextLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:self.scoreTextLabel];
    
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    self.pauseButton.frame = CGRectMake(self.view.frame.size.width -30, 20, 20 , 20);
    [self.pauseButton addTarget:self action:@selector(pauseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseButton];
    

    if (self.gameType == 0) {
        self.timeBar = [CALayer new];
        self.timeBar.backgroundColor = [[UIColor redColor] CGColor];
        self.timeBar.frame = CGRectMake(0,0, self.view.frame.size.width, 5);
        [self.view.layer addSublayer:self.timeBar];
        [self setupTimerBarWithInterval:1.0];
        
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
-(void) pauseButtonPressed:(UIButton*) button {
    [self.timeBarTimer invalidate];
    [self.addCellsTimer invalidate];
    
    //Use an action sheet instead of an alertview
    UIActionSheet *pauseAction = [[UIActionSheet alloc] initWithTitle:@"TRIFECTA PAUSED" delegate:self cancelButtonTitle:@"I Give Up" destructiveButtonTitle:nil otherButtonTitles: @"Continue Playing",nil];
    [pauseAction showInView:self.view];
//    UIAlertView *pauseAlert = [[UIAlertView alloc] initWithTitle:@"Trifecta" message:@"Game is Paused" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"I give up", nil];
//    pauseAlert.tag = 1;
//    [pauseAlert show];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self setupCellsTimerWithInterval:0.3];
        [self setupTimerBarWithInterval:1.0];
    } else if (buttonIndex == 1){
        //end game
        [self dismissModalViewControllerAnimated:YES];
    }
}

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
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.gameBoard];
    if (CGRectContainsPoint(self.gameBoard.bounds, touchPoint)){
        [self.gameBoard touchedAtPoint:touchPoint andEndedMove:NO];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.gameBoard];
    if (CGRectContainsPoint(self.gameBoard.bounds, touchPoint)){
        [self.gameBoard touchedAtPoint:touchPoint andEndedMove:YES];
        self.scoreTextLabel.text = [NSString stringWithFormat:@"Score: %d",self.gameBoard.score];
    }
}


@end
