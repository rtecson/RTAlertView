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

@property (weak, nonatomic) IBOutlet UIView *gaussianBlurContainerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberOfOtherButtonsControl;
@property (nonatomic) NSInteger numberOfOtherButtons;

@end


@implementation mzxViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIToolbar *gaussianBlurView = [[UIToolbar alloc] initWithFrame:self.gaussianBlurContainerView.bounds];
	gaussianBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.gaussianBlurContainerView addSubview:gaussianBlurView];

    [self.numberOfOtherButtonsControl addTarget:self
                                         action:@selector(numberOfOtherButtonsSelected:)
                               forControlEvents:UIControlEventValueChanged];
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
    
    for (int i=0; i<self.numberOfOtherButtons; i++)
    {
        [alertView addButtonWithTitle:[NSString stringWithFormat:@"Button %d", i]];
    }
    alertView.cancelButtonIndex = [alertView addButtonWithTitle:@"Done"];
    NSLog(@"cancelButtonIndex = %ld", (long)alertView.cancelButtonIndex);

	[alertView show];
}


- (IBAction)customButtonTapped:(id)sender
{
    RTAlertView *customAlertView = [[RTAlertView alloc] initWithTitle:@"Test"
                                                              message:@"Message here"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (int i=0; i<self.numberOfOtherButtons; i++)
    {
        [customAlertView addButtonWithTitle:[NSString stringWithFormat:@"Button %d", i]];
    }
    customAlertView.cancelButtonIndex = [customAlertView addButtonWithTitle:@"Done"];
    NSLog(@"cancelButtonIndex = %ld", (long)customAlertView.cancelButtonIndex);
//    customAlertView.otherButtonColor = [UIColor colorWithRed:(255.0f/255.0f) green:(104.0f/255.0f) blue:(14.0f/255.0f) alpha:1.0f];
//    customAlertView.cancelButtonColor = [UIColor colorWithRed:(255.0f/255.0f) green:(104.0f/255.0f) blue:(14.0f/255.0f) alpha:1.0f];

	[customAlertView show];
}


- (IBAction)numberOfOtherButtonsSelected:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

    self.numberOfOtherButtons = selectedSegment;
    NSLog(@"Number of other buttons = %ld", (long)self.numberOfOtherButtons);
}


@end
