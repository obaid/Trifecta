//
//  HighScore.h
//  Trifecta
//
//  Created by Ran Tao on 9.11.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HighScore : NSManagedObject

@property (nonatomic, retain) NSNumber * score;

@end
