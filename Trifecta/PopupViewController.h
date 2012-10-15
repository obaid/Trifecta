//
//  PopupViewController.h
//  Trifecta
//
//  Created by Kris Fields on 10/14/12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpViewDelegate <NSObject>

-(void)noButtonPressed;
-(void)yesButtonPressed;

@end

@interface PopupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) id <PopUpViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *noButtonLabel;

- (id)initWithFirstLabel:(NSString *)firstLabel andSecondLabel:(NSString *)secondLabel andNoButtonText:(NSString *)noButton andYesButtonText: (NSString *)yesButton;
- (IBAction)yesButton:(id)sender;
- (IBAction)noButton:(id)sender;

@end
