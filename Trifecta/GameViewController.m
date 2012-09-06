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
    GameBoardView *gbv = [[GameBoardView alloc] initWithFrame:CGRectMake(12, 12, 296, 296)];
    [self.view addSubview:gbv];
    NSArray *arrayOfColors = @[[UIColor redColor], [UIColor purpleColor], [UIColor blueColor], [UIColor orangeColor]];
    for (int c=0; c < 8; c++) {
        Column *column = [Column new];
        column.columnPosition = c;
        for (int r=0; r < 3; r++) {
            Cell *cell = [[Cell alloc] initWithBoard:gbv withColor:[arrayOfColors objectAtIndex:arc4random() % 4] withRow:r withColumn:c withSize:gbv.frame.size.width / 8];
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
