//
//  Column.h
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.5.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Column : NSObject
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic) int numRows;
@property (nonatomic) int columnPosition;
@end
