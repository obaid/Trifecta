//
//  InfoViewController.m
//  Trifecta
//
//  Created by Ran Tao on 10.3.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "InfoViewController.h"
#import "GameBoardView.h"
#import "Column.h"
#import "Cell.h"

@interface InfoViewController ()
@property (nonatomic) int numColumns;
@property (nonatomic, strong) GameBoardView* gameBoard;
@property (nonatomic, strong) NSTimer *addCellsTimer;
@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hex.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setUpBackgroundGame];
    
    UILabel *copywrite = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/4.0, self.view.frame.size.width - 40, 200.0)];
    copywrite.font = [UIFont fontWithName:@"04b03" size:18];
    copywrite.backgroundColor = [UIColor clearColor];
    copywrite.textColor = UIColorFromRGB(0x000000);
//    copywrite.textColor = UIColorFromRGB(0xFF0095);
    copywrite.numberOfLines = 7;
    copywrite.text = @"Copyright (c) 2012\n\nKris Fields\n&\nRan Tao\n\nin San Francisco";
    copywrite.textAlignment = UITextAlignmentCenter;
    
    UIButton *goBack = [UIButton buttonWithType:UIButtonTypeCustom];
    goBack.frame = CGRectMake(self.view.frame.size.width/2.0 - 85.0, self.view.frame.size.height/4.0*3.0, 170.0, 40.0);
    [goBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:copywrite];
    [self.view addSubview:goBack];
    
    
}


-(void)setUpBackgroundGame
{
    self.numColumns = 40;
    double sizeOfCell = self.view.frame.size.width/self.numColumns;
    int numRows = self.view.frame.size.height/sizeOfCell;
    double boardGameWidth = self.numColumns * sizeOfCell;
    double boardGameHeight = numRows * sizeOfCell;
    NSMutableArray *tempColumns = [NSMutableArray new];
    self.gameBoard = [[GameBoardView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, boardGameWidth, boardGameHeight)];
    self.gameBoard.counter = 0;
    self.gameBoard.numRows = numRows;
    self.gameBoard.numColumns = self.numColumns;
    //self.gameBoard.gameViewController = self;
    
    [self.view addSubview:self.gameBoard];
    int randomSeedNumber = arc4random();
    srand(randomSeedNumber);

   
    [self setupCellsTimerWithInterval:0.02];
    
    
    
    for (int c=0; c < self.numColumns; c++) {
        Column *column = [Column new];
        column.columnPosition = c;
        column.numRows = numRows;
        for (int r=0; r < numRows/8; r++) {
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

-(void) setupCellsTimerWithInterval:(double) interval {
    self.addCellsTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(addNewCells) userInfo:nil repeats:YES];
}

-(void) addNewCells {
    [self.gameBoard addNewCellWithColor:[self randomColor]withSize:self.gameBoard.frame.size.width / self.numColumns];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) backButtonPressed:(UIButton *) button {
    [self.addCellsTimer invalidate];
    [self dismissModalViewControllerAnimated:YES];
}

@end
