//
//  Cell.m
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.5.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//

#import "Cell.h"
#import "GameBoardView.h"
#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/QuartzCore.h>

@implementation Cell


-(id) initWithBoard:(GameBoardView*) board withColor:(UIColor*) color withRow:(int) row withColumn: (int) column withSize:(float) size {
    self = [super init];
    
    if (self != nil)
    {
        self.cellLayer = [CALayer new];
        [board.layer addSublayer:self.cellLayer];
        self.color = color;
        self.row = row;
        self.column = column;
        self.size = size;
        self.cellLayer.opaque = YES;
        self.cellLayer.backgroundColor = [self.color CGColor];
        self.cellLayer.borderWidth = 1;
        self.cellLayer.borderColor = [[UIColor whiteColor] CGColor];
    }
    return self;

}


@end
