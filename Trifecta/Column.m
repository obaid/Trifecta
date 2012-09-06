//
//  Column.m
//  Trifecta
//
//  Created by Ran Tao on 9.5.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "Column.h"

@implementation Column
-(id)init{
    self = [super init];
    if (self != nil)
    {
        self.cells = [NSMutableArray new];
    }
    return self;
};
@end
