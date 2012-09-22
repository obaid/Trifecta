//
//  GameViewController.m
//  Trifecta
//
//  Created by Ran Tao on 9.5.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//
#import "GameViewController.h"
#import "Column.h"
#import "Cell.h"
#import "GameBoardView.h"
#import <QuartzCore/QuartzCore.h>

@interface GameViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) GameBoardView* gameBoard;
@property (nonatomic) UILabel *scoreTextLabel;
@property (nonatomic) CALayer *timeBar;
@property (nonatomic) int timePast;
@property (nonatomic) NSInteger highScore;
@property (nonatomic, strong) NSTimer *timeBarTimer;
@property (nonatomic, strong) NSTimer *addCellsTimer;
@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self setUpGame];
}

-(void) viewWillAppear:(BOOL)animated {
    [self setUpGame];

}

-(void) countdownTimeBar {
    if (self.timePast <= self.view.frame.size.width) {
        self.timeBar.frame = CGRectMake(0,0, self.view.frame.size.width - self.timePast, 5);
        self.timePast +=10;
    } else {
        [self.timeBarTimer invalidate];
        [self.addCellsTimer invalidate];
        self.highScore = [self getHighScoreFromUserDefaults];
        if (self.gameBoard.score > self.highScore) {
            self.highScore = self.gameBoard.score;
            [self saveLocationsToUserDefaults:self.gameBoard.score];
        }
        [[[UIAlertView alloc] initWithTitle:@"Time's up! Play again?" message:[NSString stringWithFormat:@"Your final score was: %d\nYour high score is: %d",self.gameBoard.score, self.highScore] delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles: @"Yes please", nil] show];
       
    }
}


-(NSInteger) getHighScoreFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger score = [userDefaults integerForKey:@"score"];
    return score;
}

-(void) saveLocationsToUserDefaults:(NSInteger) score {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:score forKey:@"score"];
}


-(void) addNewCells {
    [self.gameBoard addNewCellWithColor:[self randomColor]withSize:self.gameBoard.frame.size.width / self.numColumns];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if (buttonIndex == 0) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        [self tearDownGame];
        [self setUpGame];
    }
}

-(void)tearDownGame
{
    [self.gameBoard removeFromSuperview];
}


-(void)setUpGame
{
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
    self.gameBoard.numColumns = self.numColumns;
    [self.view addSubview:self.gameBoard];
    
    self.scoreTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width -20, 40)];
    self.scoreTextLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:24];
    self.scoreTextLabel.textColor = UIColorFromRGB(0xFF0095);
    self.scoreTextLabel.text=[NSString stringWithFormat:@"Score: %d",self.gameBoard.score];
    self.scoreTextLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:self.scoreTextLabel];
    
    self.timeBar = [CALayer new];
    self.timeBar.backgroundColor = [[UIColor redColor] CGColor];
    self.timeBar.frame = CGRectMake(0,0, self.view.frame.size.width, 5);
    [self.view.layer addSublayer:self.timeBar];
    
    self.timeBarTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTimeBar) userInfo:nil repeats:YES];
    self.addCellsTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addNewCells) userInfo:nil repeats:YES];
    
    
    for (int c=0; c < self.numColumns; c++) {
        Column *column = [Column new];
        column.columnPosition = c;
        column.numRows = numRows;
        for (int r=0; r < numRows; r++) {
            Cell *cell = [[Cell alloc] initWithBoard:self.gameBoard withColor:[self randomColor] withRow:r withColumn:c withSize:self.gameBoard.frame.size.width / self.numColumns];
            cell.isFalling = NO;
            [self.gameBoard frameEachCellWithCell:cell];
            [column.cells addObject:cell];
        }
        [tempColumns addObject:column];
    }
    self.gameBoard.columns = tempColumns;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(UIColor *)randomColor
{
    NSArray *arrayOfColors = [NSArray new];
    if (self.numColumns < 10) {
         arrayOfColors = @[UIColorFromRGB(0xAD00FF), UIColorFromRGB(0xFF0095), UIColorFromRGB(0x0040FF)];
        return [arrayOfColors objectAtIndex:arc4random() % 3];

    } else if (self.numColumns < 20){
        arrayOfColors = @[UIColorFromRGB(0x12C100), UIColorFromRGB(0xAD00FF), UIColorFromRGB(0xFF0095), UIColorFromRGB(0x0040FF)];
        return [arrayOfColors objectAtIndex:arc4random() % 4];
        
    } else {
    arrayOfColors = @[UIColorFromRGB(0xAD00FF), UIColorFromRGB(0xFF0095), UIColorFromRGB(0x0040FF), UIColorFromRGB(0x12C100), UIColorFromRGB(0xFF9000), UIColorFromRGB(0xFFEE00)];
        return [arrayOfColors objectAtIndex:arc4random() % 6];

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
