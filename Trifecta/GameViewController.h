//
//  GameViewController.h
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.5.12.
//  Copyright (c) 2012 Kris Fields  & Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
@property (nonatomic) int numColumns;
@property (nonatomic) int gameType;
@property (nonatomic) int timePast;
-(void) lossByBlocks;
@end
