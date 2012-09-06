//
//  Cell.h
//  Trifecta
//
//  Created by Ran Tao on 9.5.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameBoardView;

@interface Cell : NSObject
@property (nonatomic) int row;
@property (nonatomic) int column;
@property (nonatomic) float size;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) CALayer *cellLayer;

-(id) initWithBoard:(GameBoardView*) board withColor:(UIColor*) color withRow:(int) row withColumn: (int) column withSize:(float) size;
@end
