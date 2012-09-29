//
//  Cell.h
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.5.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameBoardView;

@interface Cell : NSObject
@property (nonatomic) int row;
@property (nonatomic) int column;
@property (nonatomic) float size;
@property (nonatomic) UIColor *color;
@property (nonatomic) CALayer *cellLayer;
@property (nonatomic) bool isFalling;

-(id) initWithBoard:(GameBoardView*) board withColor:(UIColor*) color withRow:(int) row withColumn: (int) column withSize:(float) size;
@end
