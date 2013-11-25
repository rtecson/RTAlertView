//
//  mzxViewController.m
//  RTAlertView
//
//  Created by Roland on 11/23/2013.
//  Copyright (c) 2013 MoozX Internet Ventures. All rights reserved.
//


#import "mzxViewController.h"
#import "RTAlertView.h"


@interface mzxViewController ()

@end


@implementation mzxViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nativeButtonTapped:(id)sender
{
/*
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Test"
                                                        message:@"Message here"
                                                       delegate:nil
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil];
*/
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Test"
                                                        message:@"Message here"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    [alertView addButtonWithTitle:@"Button 1"];
    [alertView addButtonWithTitle:@"Button 2"];
    NSLog(@"cancelButtonIndex = %d", alertView.cancelButtonIndex);

	[alertView show];
}


- (IBAction)customButtonTapped:(id)sender
{
/*
	RTAlertView *customAlertView = [[RTAlertView alloc] initWithTitle:@"Test"
                                                              message:@"Message here"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Done"
                                                    otherButtonTitles:nil];
*/
    RTAlertView *customAlertView = [[RTAlertView alloc] initWithTitle:@"Test"
                                                              message:@"Message here"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];
    [customAlertView addButtonWithTitle:@"Button A"];
//    [customAlertView addButtonWithTitle:@"Button B"];
    customAlertView.cancelButtonIndex = [customAlertView addButtonWithTitle:@"Done"];
    NSLog(@"cancelButtonIndex = %d", customAlertView.cancelButtonIndex);
//    customAlertView.otherButtonColor = [UIColor colorWithRed:(255.0f/255.0f) green:(104.0f/255.0f) blue:(14.0f/255.0f) alpha:1.0f];
    customAlertView.cancelButtonColor = [UIColor colorWithRed:(255.0f/255.0f) green:(104.0f/255.0f) blue:(14.0f/255.0f) alpha:1.0f];

	[customAlertView show];
}


@end
