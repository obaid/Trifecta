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

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation GameBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.columns = [NSArray new];
        self.score = 0;
        self.backgroundColor = UIColorFromRGB(0xD7F6FD);
    }
    return self;
}

-(void) frameEachCellWithCell:(Cell*) cell {
    CGPoint gameCornerPosition = CGPointMake(0,self.bounds.size.height);
    
    cell.cellLayer.frame = CGRectMake(cell.size*cell.column, gameCornerPosition.y- cell.size*(cell.row+1), cell.size, cell.size);
}

-(void) drawGameBoard {
    [self positionEachColumn];
    [self setNeedsDisplay]; //check if actually needed?
}


-(void) positionEachCellWithCell:(Cell*) cell {
    CGPoint gameCornerPosition = CGPointMake(0,self.bounds.size.height);
    
    cell.cellLayer.position = CGPointMake(cell.size*cell.column + (cell.size/2.0), gameCornerPosition.y- cell.size*(cell.row+1) + (cell.size/2.0));
}

-(void) positionEachColumn {
    for (Column* column in self.columns) {
        for (Cell* cell in column.cells) {
            [self positionEachCellWithCell:cell];
        }
    }
    
}

-(void) touchedAtPoint:(CGPoint) point {
    int cellAtColumnNumber = floor((point.x / self.frame.size.width) * self.numColumns);
    int cellAtRowNumber = floor(((self.bounds.size.height - point.y) / self.frame.size.height * self.numRows));
    if (!(cellAtRowNumber >= [[[self.columns objectAtIndex:cellAtColumnNumber] cells] count])) {
        Cell *cell = [self touchedACellAtPoint:point withCellAtColumnNumber:cellAtColumnNumber withRowAtColumnNumber:cellAtRowNumber];
        NSMutableSet *cellsToDelete = [NSMutableSet setWithObject:cell];
        NSArray *neighborsToDelete = [self findNeighbors:cell withCellsToDelete:cellsToDelete];
        if([neighborsToDelete count] > 2) {
            //calculate score
            [self calculateScore:[neighborsToDelete count]];
            [self deleteCells:neighborsToDelete];
       }
    }
}

-(Cell *) touchedACellAtPoint:(CGPoint)point withCellAtColumnNumber:(int)cellAtColumnNumber withRowAtColumnNumber:(int)cellAtRowNumber {

    Cell *cell = [[[self.columns objectAtIndex:cellAtColumnNumber] cells] objectAtIndex:cellAtRowNumber];
    return cell;
}

-(void) calculateScore:(int) totalToDelete {
    int scoredPoints = totalToDelete*totalToDelete*100;
    self.score += scoredPoints;
}

-(NSArray *) findNeighbors:(Cell *)cell withCellsToDelete:(NSMutableSet *)cellsToDelete {

    //search for similar neighbors in same column
    Column *columnOfCell = [self.columns objectAtIndex:cell.column];
    NSMutableArray *matchingNeighbors = [NSMutableArray new];
    // check cell below
    if (cell.row > 0) {
        Cell *cellToCompare = [columnOfCell.cells objectAtIndex:cell.row-1];
        [matchingNeighbors addObject:cellToCompare];
    }
    //check cell above
    if (cell.row + 1 < [columnOfCell.cells count]) {
        Cell *cellToCompare = [columnOfCell.cells objectAtIndex:cell.row+1];
        [matchingNeighbors addObject:cellToCompare];
    }
    //check cell to the left
    if (cell.column > 0){
        Column *columnLeftOfCell = [self.columns objectAtIndex:cell.column - 1];
        if (cell.row < [columnLeftOfCell.cells count]) {
            Cell *cellToCompare = [columnLeftOfCell.cells objectAtIndex:cell.row];
            [matchingNeighbors addObject:cellToCompare];
        }
    }
    //check cell to the right
    if (cell.column + 1 < [self.columns count]){
        Column *columnRightOfCell = [self.columns objectAtIndex:cell.column + 1];
        if (cell.row < [columnRightOfCell.cells count]) {
            Cell *cellToCompare = [columnRightOfCell.cells objectAtIndex:cell.row];
            [matchingNeighbors addObject:cellToCompare];
        }
    }
    
    for (Cell* neighborCell in matchingNeighbors){
        if (![cellsToDelete containsObject:neighborCell]) {
            if ([self compareCell:cell withOtherCell:neighborCell]) {
                [cellsToDelete addObject:neighborCell];
                [self findNeighbors:neighborCell withCellsToDelete:cellsToDelete];
            }
        }
    }
    
    NSArray *letsKillTheseCells = [NSArray arrayWithArray:[cellsToDelete allObjects]];
    return letsKillTheseCells;
}

-(BOOL)compareCell:(Cell *)cell withOtherCell:(Cell *)otherCell
{
    if ([cell.color isEqual:otherCell.color]) {
        return YES;
    }
    return NO;
}
-(BOOL) haveEnoughNeighbors {
    
    return YES;
}

-(void) deleteCells: (NSArray *) cells {
    for (Cell* cell in cells) {
        Column *columnCellIsIn = [self.columns objectAtIndex:cell.column];
        for (int i = cell.row+1; i < [columnCellIsIn.cells count]; i++) {
            Cell* cellToChange = [columnCellIsIn.cells objectAtIndex:i];
            cellToChange.row -= 1;
        }
        [cell.cellLayer removeFromSuperlayer];
        [[[self.columns objectAtIndex:cell.column] cells] removeObject:cell];
        [self drawGameBoard];

    }
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
