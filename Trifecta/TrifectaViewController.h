//
//  TrifectaViewController.h
//  Trifecta
//
//  Created by Kris Fields & Ran Tao on 9.6.12.
//  Copyright (c) 2012 Kris Fields & Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrifectaViewController : UIViewController
- (IBAction)startButtonPressed:(UIButton *)sender;
- (IBAction)gameTypeValueChanged:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentedControl;

@end
