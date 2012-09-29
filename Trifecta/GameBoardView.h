//
//  GameBoardView.h
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.5.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameViewController;
@class Cell;

@interface GameBoardView : UIView
@property (nonatomic, strong) NSArray *columns;
@property (nonatomic) int numColumns;
@property (nonatomic) int numRows;
@property (nonatomic) int score;
@property (nonatomic) int counter;
@property (weak, nonatomic) GameViewController *gameViewController;
-(void) frameEachCellWithCell:(Cell*) cell;
-(void) touchedAtPoint:(CGPoint) point andEndedMove:(BOOL)didEndMove;
-(void) addNewCellWithColor:(UIColor *)color withSize:(double)size;
@end
