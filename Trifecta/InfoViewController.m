//
//  InfoViewController.m
//  Trifecta
//
//  Created by Ran Tao on 10.3.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hex.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UILabel *copywrite = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/4.0, self.view.frame.size.width - 40, 200.0)];
    copywrite.font = [UIFont fontWithName:@"04b03" size:18];
    copywrite.backgroundColor = [UIColor clearColor];
    copywrite.textColor = UIColorFromRGB(0xFF0095);
    copywrite.numberOfLines = 7;
    copywrite.text = @"Copyright (c) 2012\n\nKris Fields\n&\nRan Tao\n\nin San Francisco";
    copywrite.textAlignment = UITextAlignmentCenter;
    
    UIButton *goBack = [UIButton buttonWithType:UIButtonTypeCustom];
    goBack.frame = CGRectMake(self.view.frame.size.width/2.0 - 85.0, self.view.frame.size.height/4.0*3.0, 170.0, 40.0);
    [goBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:copywrite];
    [self.view addSubview:goBack];
    

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) backButtonPressed:(UIButton *) button {
    [self dismissModalViewControllerAnimated:YES];
}

@end
