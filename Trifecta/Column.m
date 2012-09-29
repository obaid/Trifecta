//
//  Column.m
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.5.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
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
