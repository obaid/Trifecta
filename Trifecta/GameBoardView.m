//
//  GameBoardView.m
//  Trifecta
//
//  Created by Ran Tao on 9.5.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "GameBoardView.h"
#import "Column.h"
#import "Cell.h"
#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/QuartzCore.h>

@implementation GameBoardView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.columns = [NSArray new];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void) drawGameBoard {
    [self positionEachColumn];
    //[self setNeedsDisplay]; //check if actually needed?
}


-(void) positionEachCellWithCell:(Cell*) cell {
    CGPoint gameCornerPosition = CGPointMake(0,self.bounds.size.height);
    cell.cellLayer.frame = CGRectMake(cell.size*cell.column, gameCornerPosition.y- cell.size*(cell.row+1), cell.size, cell.size);
}

-(void) positionEachColumn {
    for (Column* column in self.columns) {
        for (Cell* cell in column.cells) {
            [self positionEachCellWithCell:cell];
        }
    }
    
}

-(void) touchedAtPoint:(CGPoint) point {
    Cell *cell = [self touchedACellAtPoint:point];
    NSLog(@"Cell Column, Row = %d, %d", cell.column, cell.row);
//    [self findNeighbors:cell];
//        if([self haveEnoughNeighbors]) {
//            [self deleteCells];
//    }
}

-(Cell *) touchedACellAtPoint:(CGPoint)point {
    int cellAtColumnNumber = floor((point.x / self.frame.size.width) * self.numColumns);
    int cellAtRowNumber = floor(((self.bounds.size.height - point.y) / self.frame.size.height * self.numRows));
    NSLog(@"cellAtColumnNumber =  %d", cellAtColumnNumber);
    NSLog(@"cellAtRowNumber = %d", cellAtRowNumber);
    Cell *cell = [[[self.columns objectAtIndex:cellAtColumnNumber] cells] objectAtIndex:cellAtRowNumber];
    return cell;
}

-(NSMutableArray *) findNeighbors:(Cell *)cell {
    
    
}

-(BOOL) haveEnoughNeighbors {
    
    return YES;
}

-(void) deleteCells {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
