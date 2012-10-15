//
//  GameBoardView.m
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.5.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//

#import "GameBoardView.h"
#import "Column.h"
#import "Cell.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GameViewController.h"

typedef void (^animationCompletionBlock)(void);
#define kAnimationCompletionBlock @"animationCompletionBlock"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface GameBoardView ()
@property (nonatomic) CGPoint touchPoint;
@property (nonatomic, strong) AVAudioPlayer *playerFail;
@property (nonatomic, strong) AVAudioPlayer *playerSucess;
@property (nonatomic, strong) AVAudioPlayer *playerBonus;
@end
@implementation GameBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.columns = [NSArray new];
        self.score = 0;
        //self.backgroundColor = UIColorFromRGB(0xD7F6FD);
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hex.png"]];
        self.clipsToBounds = YES;
        
        NSString *music = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"];
        self.playerSucess = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:music] error:NULL];
        [self.playerSucess prepareToPlay];

        NSString *musicFail = [[NSBundle mainBundle] pathForResource:@"failed" ofType:@"wav"];
        self.playerFail = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicFail] error:NULL];
        [self.playerFail prepareToPlay];
        
        NSString *musicBonus = [[NSBundle mainBundle] pathForResource:@"bonus" ofType:@"wav"];
        self.playerBonus = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicBonus] error:NULL];
        [self.playerBonus prepareToPlay];
        
        
    }
    return self;
}

-(void) drawGameBoard {
    [self positionEachColumn];
}

-(void) positionEachColumn {
    for (Column* column in self.columns) {
        for (Cell* cell in column.cells) {
            [self frameEachCellWithCell:cell];
        }
    }
    
}

-(void) frameEachCellWithCell:(Cell*) cell {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    int cellRow = [[[self.columns objectAtIndex:cell.column] cells] indexOfObject:cell];
    cell.cellLayer.frame = CGRectMake(cell.size*cell.column, self.bounds.size.height - cell.size*(cellRow+1), cell.size, cell.size);
    [CATransaction commit];
}

-(void) touchedAtPoint:(CGPoint) point andEndedMove:(BOOL)didEndMove {
    self.touchPoint = point;
    int cellAtColumnNumber = floor((point.x / self.frame.size.width) * self.numColumns);
    int cellAtRowNumber = floor(((self.bounds.size.height - point.y) / self.frame.size.height * self.numRows));
    if (!(cellAtRowNumber >= [[[self.columns objectAtIndex:cellAtColumnNumber] cells] count])) {
        Cell *cell = [[[self.columns objectAtIndex:cellAtColumnNumber] cells] objectAtIndex:cellAtRowNumber];
        if (didEndMove) {
            NSMutableSet *cellsToDelete = [NSMutableSet setWithObject:cell];
            NSArray *neighborsToDelete = [self findNeighbors:cell withCellsToDelete:cellsToDelete];
            if([neighborsToDelete count] > 2) {
                //calculate score
                [self calculateScore:[neighborsToDelete count]];
                [self deleteCells:neighborsToDelete];
            } else {
                if (self.gameViewController.sound) {
                    [self playFailSound];
                }
            }
        } else {
            
//            [self animateCell:cell.cellLayer];
//            [self changeOpacityLevel:cell];
        }
    }
}

-(void) playSuccessfulSound {

    [self.playerSucess play];
}

-(void) playFailSound {
    [self.playerFail play];
}

-(void) playBonusSound {
   [self.playerBonus play];
}

-(void) addNewCellWithColor:(UIColor *)color withSize:(double)size
{
    self.counter ++;
    int columnNumberToAddTo = rand() % self.numColumns;
    //check if column is full
    Column *columnToAddTo = [self.columns objectAtIndex:columnNumberToAddTo];
    if ([columnToAddTo.cells count] < columnToAddTo.numRows) {
        Cell *cell = [[Cell alloc]initWithBoard:self withColor:color withRow:[columnToAddTo.cells count] withColumn:columnNumberToAddTo withSize:size];
        cell.isFalling = YES;
        [columnToAddTo.cells addObject:cell];
        [self frameEachCellWithCell:cell];
//        cell.cellLayer.frame = CGRectMake(cell.size*cell.column, 0.0, cell.size, cell.size);
        //kinda cool - makes blocks rise from below:
        double startPosition = cell.cellLayer.position.y + (cell.size / 2);
//        double startPosition = self.frame.size.height -  columnToAddTo.numRows * cell.size;
        double endPosition = self.frame.size.height - (cell.size * [columnToAddTo.cells count] - cell.size/2);
        
        //[self insertSublayer:cell.cellLayer above:self];
        [self animateCellAsItDrops:cell withStartPosition:startPosition withEndPosition:endPosition withSpeed:.003];
    }
    if ([columnToAddTo.cells count] >= columnToAddTo.numRows) {
        [self.gameViewController lossByBlocks];
    }
}
-(void)animateCellAsItDrops:(Cell*)cell withStartPosition:(double)startPosition withEndPosition:(double)endPosition withSpeed:(double)speed
{
    cell.isFalling = YES;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = (endPosition - startPosition)*speed /**(self.counter/10)))*/;
    [animation setFromValue:@(startPosition)];
    int rowToGoTo = [[[self.columns objectAtIndex:cell.column] cells] indexOfObject:cell];
    animationCompletionBlock theBlock = ^void(void)
    {
        int cellRow = [[[self.columns objectAtIndex:cell.column] cells] indexOfObject:cell];
        //Code to execute after the animation completes 
        if (cellRow == rowToGoTo) {
            cell.isFalling = NO;
        } else {
            //repeat animation
            cell.isFalling = YES;    
            double newStartPosition = endPosition;
            double newEndPosition = endPosition + (cell.size*(rowToGoTo-cellRow));
            [self animateCellAsItDrops:cell withStartPosition:newStartPosition withEndPosition:newEndPosition withSpeed:speed];
        }
    };
    animation.delegate = self;
    [animation setValue: theBlock forKey: kAnimationCompletionBlock];
    [cell.cellLayer addAnimation:animation forKey:nil];
    [self frameEachCellWithCell:cell];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    animationCompletionBlock theBlock = [theAnimation valueForKey: kAnimationCompletionBlock];
    if (theBlock)
        theBlock();
}

-(void) calculateScore:(int) totalToDelete {
    double levelMultiplier = (self.numColumns/8.0)*(self.numColumns/8.0);
    int scoredPoints = totalToDelete*totalToDelete*10*levelMultiplier;
    self.score += scoredPoints;
    if (totalToDelete > 6) {
        if (self.gameViewController.gameType == 0) {
            [self addBonus:(totalToDelete-6)*levelMultiplier toScoreOrTime:@"time"];

        } else {
            [self addBonus:(totalToDelete-6) toScoreOrTime:@"score"];
        }
        if (self.gameViewController.sound) {
            [self playBonusSound];

        }
    } else {
        if (self.gameViewController.sound) {
            [self playSuccessfulSound];
        }
    }
}

-(void) addBonus: (int) bonus toScoreOrTime:(NSString *)scoreOrTime {
    // draw bonus
    CATextLayer *bonusLayer = [CATextLayer new];
    [bonusLayer setFont:@"04b03"];
    [bonusLayer setFontSize:14];
    bonusLayer.frame = CGRectMake(0,0, 150, 50);
    bonusLayer.contentsScale = [[UIScreen mainScreen] scale];
    [bonusLayer setAlignmentMode:kCAAlignmentCenter];
    [bonusLayer setString:[NSString stringWithFormat:@"x%d\n%@ bonus", bonus, scoreOrTime]];
    [bonusLayer setForegroundColor:[UIColorFromRGB(0xFFffff) CGColor]];
    [bonusLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [bonusLayer setMasksToBounds:YES];
    [bonusLayer setShadowRadius:5.0];
    //bonusLayer.opacity = 0.0;
    
    CALayer *shadowLayer = [CALayer new];
    if (self.touchPoint.x < 75) {
        self.touchPoint = CGPointMake(75, self.touchPoint.y);
    }
    if (self.touchPoint.x > self.frame.size.width - 75) {
        self.touchPoint = CGPointMake(self.frame.size.width - 75, self.touchPoint.y);
    }
    shadowLayer.frame = CGRectMake(self.touchPoint.x, self.touchPoint.y, 150, 50);
    shadowLayer.position = self.touchPoint;
    shadowLayer.backgroundColor = [[UIColor clearColor] CGColor];
    shadowLayer.shadowColor = [[UIColor blackColor] CGColor];
    shadowLayer.shadowOpacity = 0.8;
    shadowLayer.shadowOffset = CGSizeMake(0,0);
    shadowLayer.shadowRadius = 3;
    shadowLayer.zPosition = 1000;
    
    [shadowLayer addSublayer:bonusLayer];
    [self.layer addSublayer:shadowLayer];
    [self transformLayer:shadowLayer withBonus:bonus];
    [self translatePositionWithLayer:shadowLayer];
    [self changeOpacityOfLayer:shadowLayer];
    if (self.gameViewController.sound) {
        [self playBonusSound];
    }
    
    self.gameViewController.timePast -= 5 * bonus;
    

}

-(void)changeOpacityOfLayer:(CALayer *)bonusLayer
{
    [CATransaction begin];
    CAKeyframeAnimation *changeOpacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [changeOpacity setDuration:2.1];
    [changeOpacity setValues:@[@0.0, @1.0, @0.0]];
//    animationCompletionBlock theBlock = ^void(void)
//    {
//        [bonusLayer removeFromSuperlayer];
//    };
//    changeOpacity.delegate = self;
//    [changeOpacity setValue: theBlock forKey: kAnimationCompletionBlock];
    [bonusLayer addAnimation:changeOpacity forKey:@"opacity"];
    [CATransaction commit];
}

-(void)translatePositionWithLayer: (CALayer *) bonusLayer {
    [CATransaction begin];
    CAKeyframeAnimation *translateLayer = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    [translateLayer setDuration:2];
    [translateLayer setValues:@[[NSNumber numberWithFloat: bonusLayer.position.y], [NSNumber numberWithFloat:self.frame.origin.y]]];
    animationCompletionBlock theBlock = ^void(void)
    {
        [bonusLayer removeFromSuperlayer];
    };
    translateLayer.delegate = self;
    [translateLayer setValue: theBlock forKey: kAnimationCompletionBlock];
    [bonusLayer addAnimation:translateLayer forKey:@"position.y"];
    [CATransaction commit];
}
-(void) transformLayer: (CALayer *) bonusLayer withBonus:(int)bonus {
    [CATransaction begin];
    CAKeyframeAnimation *transformLayer = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D forward = CATransform3DMakeScale(1+(log10f(bonus))*1.3, 1+(log10f(bonus))*1.3, 1);
    CATransform3D back = CATransform3DMakeScale(1.0, 1.0, 1);
    [transformLayer setValues:@[                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    [NSValue valueWithCATransform3D:back],                                                                                                                                                                                                                                                                       [NSValue valueWithCATransform3D:forward],                                                                                                                                                                                                                                                                       [NSValue valueWithCATransform3D:back]]
     ];
    [transformLayer setDuration:2];
    transformLayer.delegate = self;
    [bonusLayer addAnimation:transformLayer forKey:@"transform"];
    [CATransaction commit];
}

-(NSArray *) findNeighbors:(Cell *)cell withCellsToDelete:(NSMutableSet *)cellsToDelete {
    //search for similar neighbors in same column
    Column *columnOfCell = [self.columns objectAtIndex:cell.column];
    NSMutableArray *matchingNeighbors = [NSMutableArray new];
    // check cell below
    int cellRow = [[columnOfCell cells] indexOfObject:cell];
    if (cellRow > 0) {
        Cell *cellToCompare = [columnOfCell.cells objectAtIndex:cellRow-1];
        [matchingNeighbors addObject:cellToCompare];
    }
    //check cell above
    if (cellRow + 1 < [columnOfCell.cells count]) {
        Cell *cellToCompare = [columnOfCell.cells objectAtIndex:cellRow+1];
        [matchingNeighbors addObject:cellToCompare];
    }
    //check cell to the left
    if (cell.column > 0){
        Column *columnLeftOfCell = [self.columns objectAtIndex:cell.column - 1];
        if (cellRow < [columnLeftOfCell.cells count]) {
            Cell *cellToCompare = [columnLeftOfCell.cells objectAtIndex:cellRow];
            [matchingNeighbors addObject:cellToCompare];
        }
    }
    //check cell to the right
    if (cell.column + 1 < [self.columns count]){
        Column *columnRightOfCell = [self.columns objectAtIndex:cell.column + 1];
        if (cellRow < [columnRightOfCell.cells count]) {
            Cell *cellToCompare = [columnRightOfCell.cells objectAtIndex:cellRow];
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
        if (cell.isFalling || otherCell.isFalling) {
            return NO;
        }
        return YES;
    }
    return NO;
}

-(void) deleteCells: (NSArray *) cells {
    NSMutableSet *cellsToChange = [NSMutableSet new];
    for (Cell* cell in cells) {
        Column *columnCellIsIn = [self.columns objectAtIndex:cell.column];
        int cellRow = [[columnCellIsIn cells] indexOfObject:cell];
        int numCellsInColumn = [columnCellIsIn.cells count];
        for (int i = cellRow+1; i < numCellsInColumn; i++) {
            Cell* cellToChange = [columnCellIsIn.cells objectAtIndex:i];
            [cellsToChange addObject:cellToChange];
//            cellToChange.row -= 1;
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self animateCellsUponDeletion:cells withCellsToChange:cellsToChange];
    });

    

}
-(void)animateCellsUponDeletion:(NSArray *)cells withCellsToChange:(NSMutableSet *)cellsToChange
{
    [CATransaction begin];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (Cell *cell in cells) {
//            [self animateCellUponDeletion:cell];
            [self deleteCell:(Cell *)cell];
        }
        for (Cell *cellToChange in cellsToChange) {
            cellToChange.row = [[[self.columns objectAtIndex:cellToChange.column] cells] indexOfObject:cellToChange];
        }
        for (Cell *cellToChange in cellsToChange) {
            int cellToChangeRow = [[[self.columns objectAtIndex:cellToChange.column] cells] indexOfObject:cellToChange];
            if (!cellToChange.isFalling) {
                double endPosition =  self.bounds.size.height - cellToChange.size*(cellToChangeRow+1) + (cellToChange.size/2.0);
                [self animateCellAsItDrops:cellToChange withStartPosition:cellToChange.cellLayer.position.y withEndPosition:endPosition withSpeed:.002];
            }
        }
    });
    [CATransaction commit];
    
}
- (void)animateCellUponDeletion:(Cell *)cell
{
    [CATransaction begin];
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 21);
    [bounce setValues:@[                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         [NSValue valueWithCATransform3D:forward]]
     ];
    // Set the duration
    [bounce setDuration:1110];
    // Animate the layer
    dispatch_async(dispatch_get_main_queue(), ^{
        [[cell cellLayer] addAnimation:bounce forKey:@"bounceAnimation"];
        [CATransaction setCompletionBlock:^{
            [self deleteCell:(Cell *)cell];
        }];
    });
    CAKeyframeAnimation *changeOpacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [changeOpacity setDuration:0.1];
    [changeOpacity setValues:@[@1.0, @0.5, @0.0]];
    dispatch_async(dispatch_get_main_queue(), ^{
    [[cell cellLayer] addAnimation:changeOpacity forKey:@"changeOpacity"];
    });

    [CATransaction commit];
    
}
-(void) deleteCell: (Cell *)cell {
    [cell.cellLayer removeFromSuperlayer];
    [[[self.columns objectAtIndex:cell.column] cells] removeObject:cell];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint)){
        [self touchedAtPoint:touchPoint andEndedMove:NO];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint)){
        [self touchedAtPoint:touchPoint andEndedMove:YES];
        self.gameViewController.scoreTextLabel.text = [NSString stringWithFormat:@"Score: %d",self.score];
    }
}

@end
