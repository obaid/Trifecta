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

typedef void (^animationCompletionBlock)(void);
#define kAnimationCompletionBlock @"animationCompletionBlock"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface GameBoardView ()

@end
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
    cell.cellLayer.frame = CGRectMake(cell.size*cell.column, self.bounds.size.height - cell.size*(cell.row+1), cell.size, cell.size);
}

-(void) drawGameBoard {
    [self positionEachColumn];
}


-(void) positionEachCellWithCell:(Cell*) cell {
    [CATransaction begin];
    if (cell.isFalling) {
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    }   
    cell.cellLayer.position = CGPointMake(cell.size*cell.column + (cell.size/2.0), self.bounds.size.height - cell.size*(cell.row+1) + (cell.size/2.0));

    [CATransaction commit];
}

-(void) positionEachColumn {
    for (Column* column in self.columns) {
        for (Cell* cell in column.cells) {
            [self positionEachCellWithCell:cell];
        }
    }
    
}

-(void) touchedAtPoint:(CGPoint) point andEndedMove:(BOOL)didEndMove {
    int cellAtColumnNumber = floor((point.x / self.frame.size.width) * self.numColumns);
    int cellAtRowNumber = floor(((self.bounds.size.height - point.y) / self.frame.size.height * self.numRows));
    if (!(cellAtRowNumber >= [[[self.columns objectAtIndex:cellAtColumnNumber] cells] count])) {
        Cell *cell = [self touchedACellAtPoint:point withCellAtColumnNumber:cellAtColumnNumber withRowAtColumnNumber:cellAtRowNumber];
        if (didEndMove) {
            NSMutableSet *cellsToDelete = [NSMutableSet setWithObject:cell];
            NSArray *neighborsToDelete = [self findNeighbors:cell withCellsToDelete:cellsToDelete];
            if([neighborsToDelete count] > 2) {
                //calculate score
                [self calculateScore:[neighborsToDelete count]];
                [self deleteCells:neighborsToDelete];
           }
        } else {
//            [self animateCell:cell.cellLayer];
//            [self changeOpacityLevel:cell];
        }
    }
}
-(void) addNewCellWithColor:(UIColor *)color withSize:(double)size
{
    self.counter ++;
    int columnNumberToAddTo = arc4random() % self.numColumns;
    //check if column is full
    Column *columnToAddTo = [self.columns objectAtIndex:columnNumberToAddTo];
    if ([columnToAddTo.cells count] < columnToAddTo.numRows) {
        Cell *cell = [[Cell alloc]initWithBoard:self withColor:color withRow:[columnToAddTo.cells count] withColumn:columnNumberToAddTo withSize:size];
        cell.isFalling = YES;
        [columnToAddTo.cells addObject:cell];
        [self frameEachCellWithCell:cell];
        double startPosition = self.frame.size.height -  columnToAddTo.numRows * cell.size;
        double endPosition = self.frame.size.height - (cell.size * [columnToAddTo.cells count] - cell.size/2);
        [self animateCellAsItDrops:cell withStartPosition:startPosition withEndPosition:endPosition];
        
        
    }
    else {
        //you lose motherfucker
        NSLog(@"YOU LOSE");
    }
}
-(void)animateCellAsItDrops:(Cell*)cell withStartPosition:(double)startPosition withEndPosition:(double)endPosition
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //animation.duration = (endPosition - startPosition)*(.05-(.01 *(self.counter/10)));
    [animation setFromValue:@(startPosition)];
    [animation setToValue:@(endPosition)];
    int rowToGoTo = cell.row;
    animationCompletionBlock theBlock = ^void(void)
    {
        //Code to execute after the animation completes goes here
        if (cell.row == rowToGoTo) {
//            [self positionEachCellWithCell:cell];
            cell.isFalling = NO;
        } else {
            //repeat animation
            double newStartPosition = endPosition;
            double newEndPosition = endPosition + (cell.size*(rowToGoTo-cell.row));
            [self animateCellAsItDrops:cell withStartPosition:newStartPosition withEndPosition:newEndPosition];
        }
        
    };
    animation.delegate = self;
    [animation setValue: theBlock forKey: kAnimationCompletionBlock];
    [cell.cellLayer addAnimation:animation forKey:nil];
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    animationCompletionBlock theBlock = [theAnimation valueForKey: kAnimationCompletionBlock];
    if (theBlock)
        theBlock();
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

-(void) deleteCells: (NSArray *) cells {
    for (Cell* cell in cells) {
        Column *columnCellIsIn = [self.columns objectAtIndex:cell.column];
        for (int i = cell.row+1; i < [columnCellIsIn.cells count]; i++) {
            Cell* cellToChange = [columnCellIsIn.cells objectAtIndex:i];
            cellToChange.row -= 1;
        }
        if (!cell.isFalling) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self animateCellUponDeletion:cell];
            });
        }
    }
}

- (void)animateCellUponDeletion:(Cell *)cell
{
    [CATransaction begin];
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D forward = CATransform3DMakeScale(9.3, 9.3, 21);
    [bounce setValues:@[                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         [NSValue valueWithCATransform3D:forward]]
     ];
    // Set the duration
    [bounce setDuration:20];
    // Animate the layer
    dispatch_async(dispatch_get_main_queue(), ^{
//        [[cell cellLayer] addAnimation:bounce forKey:@"bounceAnimation"];
        [CATransaction setCompletionBlock:^{
            [self deleteCell:(Cell *)cell];
        }];
    });
//    CAKeyframeAnimation *changeOpacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//    [changeOpacity setDuration:0.1];
//    [changeOpacity setValues:@[@1.0, @0.5, @0.0]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//    [[cell cellLayer] addAnimation:changeOpacity forKey:@"changeOpacity"];
//    });

    [CATransaction commit];
    
}
-(void) deleteCell: (Cell *)cell {
    [cell.cellLayer removeFromSuperlayer];
    [[[self.columns objectAtIndex:cell.column] cells] removeObject:cell];
    [self drawGameBoard];
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
