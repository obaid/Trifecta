//
//  GameBoardView.h
//  Trifecta
//
//  Created by Ran Tao on 9.5.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Cell;

@interface GameBoardView : UIView
@property (nonatomic, strong) NSArray *columns;
@property (nonatomic) int numColumns;
@property (nonatomic) int numRows;
-(void) frameEachCellWithCell:(Cell*) cell;
-(void) touchedAtPoint:(CGPoint) point;
@end
