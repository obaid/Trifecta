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

@interface GameViewController ()
@property (nonatomic, strong) GameBoardView* gameBoard;
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
    
    self.numColumns = 3;
    double sizeOfCell = 296.0/self.numColumns;
    int numRows = 456/sizeOfCell;
    int boardGameWidth = self.numColumns * sizeOfCell;
    int boardGameHeight = numRows * sizeOfCell;
    double boardGameYStart = (self.view.frame.size.height - boardGameHeight)/2.0;
    double boardGameXStart = (self.view.frame.size.width - boardGameWidth)/2.0;
    NSMutableArray *tempColumns = [NSMutableArray new];
    self.gameBoard = [[GameBoardView alloc] initWithFrame:CGRectMake(boardGameXStart, boardGameYStart, boardGameWidth, boardGameHeight)];
    self.gameBoard.numRows = numRows;
    self.gameBoard.numColumns = self.numColumns;
    [self.view addSubview:self.gameBoard];


    NSArray *arrayOfColors = @[UIColorFromRGB(0xAD00FF), UIColorFromRGB(0xFF0095), UIColorFromRGB(0x0040FF), UIColorFromRGB(0x12C100), UIColorFromRGB(0xFF9000), UIColorFromRGB(0xFFEE00)];
    
    for (int c=0; c < self.numColumns; c++) {
        Column *column = [Column new];
        column.columnPosition = c;
        column.numRows = numRows;
        for (int r=0; r < numRows; r++) {
            Cell *cell = [[Cell alloc] initWithBoard:self.gameBoard withColor:[arrayOfColors objectAtIndex:arc4random() % 6] withRow:r withColumn:c withSize:self.gameBoard.frame.size.width / self.numColumns];
            [column.cells addObject:cell];
        }
        [tempColumns addObject:column];
    }
    self.gameBoard.columns = tempColumns;
    [self.gameBoard drawGameBoard];
    //[self.gameBoard setNeedsDisplay];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.gameBoard];
    NSLog(@"touch ended at: %f, %f", touchPoint.x, touchPoint.y);
    if (CGRectContainsPoint(self.gameBoard.bounds, touchPoint)){
        [self.gameBoard touchedAtPoint:touchPoint];
    }
}


@end
