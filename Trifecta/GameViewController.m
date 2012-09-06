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
    NSMutableArray *tempColumns = [NSMutableArray new];
    GameBoardView *gbv = [[GameBoardView alloc] initWithFrame:CGRectMake(12, 20, 296, 440)];
    [self.view addSubview:gbv];


    NSArray *arrayOfColors = @[UIColorFromRGB(0xAD00FF), UIColorFromRGB(0xFF0095), UIColorFromRGB(0x0040FF), UIColorFromRGB(0x12C100), UIColorFromRGB(0xFF9000), UIColorFromRGB(0xFFEE00)];
    for (int c=0; c < 8; c++) {
        Column *column = [Column new];
        column.columnPosition = c;
        for (int r=0; r < 12; r++) {
            Cell *cell = [[Cell alloc] initWithBoard:gbv withColor:[arrayOfColors objectAtIndex:arc4random() % 6] withRow:r withColumn:c withSize:gbv.frame.size.width / 8];
            [column.cells addObject:cell];
        }
        [tempColumns addObject:column];
    }
    gbv.columns = tempColumns;
    [gbv drawGameBoard];
    [gbv setNeedsDisplay];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
