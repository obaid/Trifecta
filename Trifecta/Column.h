//
//  Column.h
//  Trifecta
//
//  Created by Ran Tao on 9.5.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Column : NSObject
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic) int numRows;
@property (nonatomic) int columnPosition;
@end
