//
//  HighScoresViewController.m
//  Trifecta
//
//  Created by Ran Tao on 10.8.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "HighScoresViewController.h"
#import "GameBoardView.h"
#import "Column.h"
#import "Cell.h"

@interface HighScoresViewController () <UIScrollViewDelegate>
@property (nonatomic) int numColumns;
@property (nonatomic, strong) GameBoardView* gameBoard;
@property (nonatomic, strong) NSTimer *addCellsTimer;
@property (nonatomic, strong) UIScrollView *highScoreScrollView;
@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation HighScoresViewController

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
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    backgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    
    self.highScoreScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, height/16.0*3.0, width-40, height/8.0*5.0)];
    self.highScoreScrollView.pagingEnabled = YES;
    self.highScoreScrollView.contentSize = CGSizeMake(self.highScoreScrollView.frame.size.width, self.view.frame.size.height /8.0*10.0);
    self.highScoreScrollView.showsHorizontalScrollIndicator = NO;
    self.highScoreScrollView.showsVerticalScrollIndicator = YES;
    self.highScoreScrollView.scrollsToTop = YES;
    self.highScoreScrollView.clipsToBounds = YES;
    self.highScoreScrollView.delegate = self;
        
    UILabel *highscoresTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/16.0, self.view.frame.size.width - 40, 50.0)];
    highscoresTitle.font = [UIFont fontWithName:@"04b03" size:32];
    highscoresTitle.backgroundColor = [UIColor clearColor];
    highscoresTitle.textColor = UIColorFromRGB(0xFF0095);
    highscoresTitle.text = @"HIGH SCORES";
    highscoresTitle.textAlignment = UITextAlignmentCenter;
    
    UILabel *timedTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.highScoreScrollView.frame.size.width, 50.0)];
    timedTitle.font = [UIFont fontWithName:@"04b03" size:18];
    timedTitle.backgroundColor = [UIColor clearColor];
    timedTitle.textColor = UIColorFromRGB(0x000000);
    timedTitle.text = @"Timed";
    timedTitle.textAlignment = UITextAlignmentCenter;

    UILabel *lLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/8.0, self.highScoreScrollView.frame.size.width/4.0, 50.0)];
    lLabel.font = [UIFont fontWithName:@"04b03" size:18];
    lLabel.backgroundColor = [UIColor clearColor];
    lLabel.textColor = UIColorFromRGB(0x000000);
    lLabel.text = @"L";
    lLabel.textAlignment = UITextAlignmentCenter;

    UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/8.0*2.0, self.highScoreScrollView.frame.size.width/4.0, 50.0)];
    mLabel.font = [UIFont fontWithName:@"04b03" size:18];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.textColor = UIColorFromRGB(0x000000);
    mLabel.text = @"M";
    mLabel.textAlignment = UITextAlignmentCenter;
    
    UILabel *sLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/8.0*3.0, self.highScoreScrollView.frame.size.width/4.0, 50.0)];
    sLabel.font = [UIFont fontWithName:@"04b03" size:18];
    sLabel.backgroundColor = [UIColor clearColor];
    sLabel.textColor = UIColorFromRGB(0x000000);
    sLabel.text = @"S";
    sLabel.textAlignment = UITextAlignmentCenter;
    
    UILabel *xsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/8.0*4.0, self.highScoreScrollView.frame.size.width/4.0, 50.0)];
    xsLabel.font = [UIFont fontWithName:@"04b03" size:18];
    xsLabel.backgroundColor = [UIColor clearColor];
    xsLabel.textColor = UIColorFromRGB(0x000000);
    xsLabel.text = @"XS";
    xsLabel.textAlignment = UITextAlignmentCenter;
    
    UILabel *lScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.highScoreScrollView.frame.size.width/4.0, self.view.frame.size.height/8.0, self.highScoreScrollView.frame.size.width/8.0*5.0, 50.0)];
    lScoreLabel.font = [UIFont fontWithName:@"04b03" size:18];
    lScoreLabel.backgroundColor = [UIColor clearColor];
    lScoreLabel.textColor = UIColorFromRGB(0xFF0095);
    NSInteger lScore = [self getHighScoreFromUserDefaultsForSize:8 withGameType:0];
    if (lScore) {
        lScoreLabel.text = [NSString stringWithFormat:@"%d",lScore];
    } else {
        lScoreLabel.text = @"-";
    }
    lScoreLabel.textAlignment = UITextAlignmentRight;
    
    UILabel *mScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.highScoreScrollView.frame.size.width/4.0, self.view.frame.size.height/8.0*2.0, self.highScoreScrollView.frame.size.width/8.0*5.0, 50.0)];
    mScoreLabel.font = [UIFont fontWithName:@"04b03" size:18];
    mScoreLabel.backgroundColor = [UIColor clearColor];
    mScoreLabel.textColor = UIColorFromRGB(0xFF0095);
    NSInteger mScore = [self getHighScoreFromUserDefaultsForSize:12 withGameType:0];
    if (mScore) {
        mScoreLabel.text = [NSString stringWithFormat:@"%d",mScore];
    }else {
        mScoreLabel.text = @"-";
    }
    mScoreLabel.textAlignment = UITextAlignmentRight;
    
    UILabel *sScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.highScoreScrollView.frame.size.width/4.0, self.view.frame.size.height/8.0*3.0, self.highScoreScrollView.frame.size.width/8.0*5.0, 50.0)];
    sScoreLabel.font = [UIFont fontWithName:@"04b03" size:18];
    sScoreLabel.backgroundColor = [UIColor clearColor];
    sScoreLabel.textColor = UIColorFromRGB(0xFF0095);
    NSInteger sScore = [self getHighScoreFromUserDefaultsForSize:16 withGameType:0];
    if (sScore) {
        sScoreLabel.text = [NSString stringWithFormat:@"%d",sScore];
    }else {
        sScoreLabel.text = @"-";
    }
    sScoreLabel.textAlignment = UITextAlignmentRight;
    
    UILabel *xsScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.highScoreScrollView.frame.size.width/4.0, self.view.frame.size.height/8.0*4.0, self.highScoreScrollView.frame.size.width/8.0*5.0, 50.0)];
    xsScoreLabel.font = [UIFont fontWithName:@"04b03" size:18];
    xsScoreLabel.backgroundColor = [UIColor clearColor];
    xsScoreLabel.textColor = UIColorFromRGB(0xFF0095);
    NSInteger xsScore = [self getHighScoreFromUserDefaultsForSize:20 withGameType:0];
    if (xsScore) {
        xsScoreLabel.text = [NSString stringWithFormat:@"%d",xsScore];
    }else {
        xsScoreLabel.text = @"-";
    }
    xsScoreLabel.textAlignment = UITextAlignmentRight;
    
    
    UILabel *unlimitedTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/8.0*5.0, self.highScoreScrollView.frame.size.width, 50.0)];
    unlimitedTitle.font = [UIFont fontWithName:@"04b03" size:18];
    unlimitedTitle.backgroundColor = [UIColor clearColor];
    unlimitedTitle.textColor = UIColorFromRGB(0x000000);
    unlimitedTitle.text = @"Unlimited";
    unlimitedTitle.textAlignment = UITextAlignmentCenter;
    
    UILabel *lUnlimitedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/8.0*6.0, self.highScoreScrollView.frame.size.width/4.0, 50.0)];
    lUnlimitedLabel.font = [UIFont fontWithName:@"04b03" size:18];
    lUnlimitedLabel.backgroundColor = [UIColor clearColor];
    lUnlimitedLabel.textColor = UIColorFromRGB(0x000000);
    lUnlimitedLabel.text = @"L";
    lUnlimitedLabel.textAlignment = UITextAlignmentCenter;
    
    UILabel *mUnlimitedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/8.0*7.0, self.highScoreScrollView.frame.size.width/4.0, 50.0)];
    mUnlimitedLabel.font = [UIFont fontWithName:@"04b03" size:18];
    mUnlimitedLabel.backgroundColor = [UIColor clearColor];
    mUnlimitedLabel.textColor = UIColorFromRGB(0x000000);
    mUnlimitedLabel.text = @"M";
    mUnlimitedLabel.textAlignment = UITextAlignmentCenter;
    
    UILabel *sUnlimitedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/8.0*8.0, self.highScoreScrollView.frame.size.width/4.0, 50.0)];
    sUnlimitedLabel.font = [UIFont fontWithName:@"04b03" size:18];
    sUnlimitedLabel.backgroundColor = [UIColor clearColor];
    sUnlimitedLabel.textColor = UIColorFromRGB(0x000000);
    sUnlimitedLabel.text = @"S";
    sUnlimitedLabel.textAlignment = UITextAlignmentCenter;
    
    UILabel *xsUnlimitedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/8.0*9.0,self.highScoreScrollView.frame.size.width/4.0, 50.0)];
    xsUnlimitedLabel.font = [UIFont fontWithName:@"04b03" size:18];
    xsUnlimitedLabel.backgroundColor = [UIColor clearColor];
    xsUnlimitedLabel.textColor = UIColorFromRGB(0x000000);
    xsUnlimitedLabel.text = @"XS";
    xsUnlimitedLabel.textAlignment = UITextAlignmentCenter;
    
    
    UILabel *lUnlimitedScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.highScoreScrollView.frame.size.width/4.0, self.view.frame.size.height/8.0*6.0, self.highScoreScrollView.frame.size.width/8.0*5.0, 50.0)];
    lUnlimitedScoreLabel.font = [UIFont fontWithName:@"04b03" size:18];
    lUnlimitedScoreLabel.backgroundColor = [UIColor clearColor];
    lUnlimitedScoreLabel.textColor = UIColorFromRGB(0xFF0095);
    NSInteger lUnlimitedScore = [self getHighScoreFromUserDefaultsForSize:8 withGameType:1];
    if (lUnlimitedScore) {
        lUnlimitedScoreLabel.text = [NSString stringWithFormat:@"%d",lUnlimitedScore];
    } else {
        lUnlimitedScoreLabel.text = @"-";
    }
    lUnlimitedScoreLabel.textAlignment = UITextAlignmentRight;
    
    UILabel *mUnlimitedScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.highScoreScrollView.frame.size.width/4.0, self.view.frame.size.height/8.0*7.0, self.highScoreScrollView.frame.size.width/8.0*5.0, 50.0)];
    mUnlimitedScoreLabel.font = [UIFont fontWithName:@"04b03" size:18];
    mUnlimitedScoreLabel.backgroundColor = [UIColor clearColor];
    mUnlimitedScoreLabel.textColor = UIColorFromRGB(0xFF0095);
    NSInteger mUnlimitedScore = [self getHighScoreFromUserDefaultsForSize:12 withGameType:1];
    if (mUnlimitedScore) {
        mUnlimitedScoreLabel.text = [NSString stringWithFormat:@"%d",mUnlimitedScore];
    }else {
        mUnlimitedScoreLabel.text = @"-";
    }
    mUnlimitedScoreLabel.textAlignment = UITextAlignmentRight;
    
    UILabel *sUnlimitedScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.highScoreScrollView.frame.size.width/4.0, self.view.frame.size.height/8.0*8.0, self.highScoreScrollView.frame.size.width/8.0*5.0, 50.0)];
    sUnlimitedScoreLabel.font = [UIFont fontWithName:@"04b03" size:18];
    sUnlimitedScoreLabel.backgroundColor = [UIColor clearColor];
    sUnlimitedScoreLabel.textColor = UIColorFromRGB(0xFF0095);
    NSInteger sUnlimitedScore = [self getHighScoreFromUserDefaultsForSize:16 withGameType:1];
    if (sUnlimitedScore) {
        sUnlimitedScoreLabel.text = [NSString stringWithFormat:@"%d",sUnlimitedScore];
    }else {
        sUnlimitedScoreLabel.text = @"-";
    }
    sUnlimitedScoreLabel.textAlignment = UITextAlignmentRight;
    
    UILabel *xsUnlimitedScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.highScoreScrollView.frame.size.width/4.0, self.view.frame.size.height/8.0*9.0, self.highScoreScrollView.frame.size.width/8.0*5.0, 50.0)];
    xsUnlimitedScoreLabel.font = [UIFont fontWithName:@"04b03" size:18];
    xsUnlimitedScoreLabel.backgroundColor = [UIColor clearColor];
    xsUnlimitedScoreLabel.textColor = UIColorFromRGB(0xFF0095);
    NSInteger xsUnlimitedScore = [self getHighScoreFromUserDefaultsForSize:20 withGameType:1];
    if (xsUnlimitedScore) {
        xsUnlimitedScoreLabel.text = [NSString stringWithFormat:@"%d",xsUnlimitedScore];
    }else {
        xsUnlimitedScoreLabel.text = @"-";
    }
    xsUnlimitedScoreLabel.textAlignment = UITextAlignmentRight;
    
    
    UIButton *goBack = [UIButton buttonWithType:UIButtonTypeCustom];
    goBack.frame = CGRectMake(self.view.frame.size.width/2.0 - 85.0, self.view.frame.size.height/16.0*13.0, 170.0, 40.0);
    [goBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:backgroundView];
    [self.view addSubview:self.highScoreScrollView];
    
    [self.highScoreScrollView addSubview:timedTitle];
    [self.highScoreScrollView addSubview:lLabel];
    [self.highScoreScrollView addSubview:mLabel];
    [self.highScoreScrollView addSubview:sLabel];
    [self.highScoreScrollView addSubview:xsLabel];
    [self.highScoreScrollView addSubview:unlimitedTitle];
    [self.highScoreScrollView addSubview:lUnlimitedLabel];
    [self.highScoreScrollView addSubview:mUnlimitedLabel];
    [self.highScoreScrollView addSubview:sUnlimitedLabel];
    [self.highScoreScrollView addSubview:xsUnlimitedLabel];
    [self.highScoreScrollView addSubview:lScoreLabel];
    [self.highScoreScrollView addSubview:mScoreLabel];
    [self.highScoreScrollView addSubview:sScoreLabel];
    [self.highScoreScrollView addSubview:xsScoreLabel];
    [self.highScoreScrollView addSubview:lUnlimitedScoreLabel];
    [self.highScoreScrollView addSubview:mUnlimitedScoreLabel];
    [self.highScoreScrollView addSubview:sUnlimitedScoreLabel];
    [self.highScoreScrollView addSubview:xsUnlimitedScoreLabel];
    [self.view addSubview:highscoresTitle];
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

-(NSInteger) getHighScoreFromUserDefaultsForSize:(int) size withGameType:(int) type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger score = [userDefaults integerForKey:[NSString stringWithFormat:@"%dscore%d",size, type]];
    return score;
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
