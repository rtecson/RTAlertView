//
//  ViewController.m
//  RTAlertView
//
//  Created by Roland Tecson on 11/23/2013.
//  Copyright (c) 2013 12 Harmonic Studios. All rights reserved.
//


#import "ViewController.h"
#import "RTAlertView.h"


#define kCustomColor [UIColor colorWithRed:(55.0f/255.0f) green:(130.0f/255.0f) blue:(75.0f/255.0f) alpha:1.0f]


@interface ViewController () <UIAlertViewDelegate,
                                 RTAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *gaussianBlurContainerView;
@property (weak, nonatomic) IBOutlet UIView *gaussianBlurDividerLine;
@property (weak, nonatomic) IBOutlet UISwitch *dismissOnBackgroundSwitch;

@property (nonatomic) NSInteger numberOfOtherButtons;
@property (nonatomic) UIAlertViewStyle alertViewStyle;

@property (weak, nonatomic) UIAlertView *alertView;

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIToolbar *gaussianBlurView = [[UIToolbar alloc] initWithFrame:self.gaussianBlurContainerView.bounds];
	gaussianBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.gaussianBlurContainerView addSubview:gaussianBlurView];
    
    self.alertViewStyle = UIAlertViewStyleDefault;
    self.numberOfOtherButtons = 0;
    self.dismissOnBackgroundSwitch.onTintColor = [UIColor colorWithRed:(55.0f / 255.0f)
                                                                 green:(130.0f / 255.0f)
                                                                  blue:(75.0f / 255.0f)
                                                                 alpha:1.0f];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

- (IBAction)nativeButtonTapped:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Test"
                                                        message:@"Message here"
//                                                        message:@"Message here. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    alertView.delegate = self;

    alertView.alertViewStyle = self.alertViewStyle;

    for (int i=0; i<self.numberOfOtherButtons; i++)
    {
        [alertView addButtonWithTitle:[NSString stringWithFormat:@"Button %d", i]];
    }
    alertView.cancelButtonIndex = [alertView addButtonWithTitle:@"Done"];
    NSLog(@"cancelButtonIndex = %ld", (long)alertView.cancelButtonIndex);

	[alertView show];
    
    self.alertView = alertView;
}


- (IBAction)customButtonTapped:(id)sender
{
    RTAlertView *customAlertView = [[RTAlertView alloc] initWithTitle:@"Test"
                                                              message:@"Message here"
//                                                                                            message:@"Message here. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog."
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];
    customAlertView.delegate = self;

    customAlertView.alertViewStyle = self.alertViewStyle;

    for (int i=0; i<self.numberOfOtherButtons; i++)
    {
        [customAlertView addButtonWithTitle:[NSString stringWithFormat:@"Button %d", i]];
    }
    customAlertView.cancelButtonIndex = [customAlertView addButtonWithTitle:@"Done"];
    NSLog(@"cancelButtonIndex = %ld", (long)customAlertView.cancelButtonIndex);
    
    customAlertView.otherButtonColor = kCustomColor;
    customAlertView.cancelButtonColor = kCustomColor;

	[customAlertView show];
    
    customAlertView.dismissesWhenAppGoesToBackground = self.dismissOnBackgroundSwitch.on;
    self.alertView = (UIAlertView *)customAlertView;
}


- (IBAction)numberOfOtherButtonsSelected:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

    self.numberOfOtherButtons = selectedSegment;
    NSLog(@"Number of other buttons = %ld", (long)self.numberOfOtherButtons);
}


- (IBAction)alertViewStyleSelected:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

    switch (selectedSegment)
    {
        case 3:
            self.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            break;
        case 2:
            self.alertViewStyle = UIAlertViewStyleSecureTextInput;
            break;
        case 1:
            self.alertViewStyle = UIAlertViewStylePlainTextInput;
            break;
        case 0:
        default:
            self.alertViewStyle = UIAlertViewStyleDefault;
            break;
    }

    NSString *alertViewStyleString = nil;
    switch (self.alertViewStyle)
    {
        case UIAlertViewStylePlainTextInput:
            alertViewStyleString = @"Plain Text";
            break;
        case UIAlertViewStyleSecureTextInput:
            alertViewStyleString = @"Secure Text";
            break;
        case UIAlertViewStyleLoginAndPasswordInput:
            alertViewStyleString = @"Login/Password";
            break;
        case UIAlertViewStyleDefault:
        default:
            alertViewStyleString = @"Default";
            break;
    }
    NSLog(@"Alert view style selected = %@", alertViewStyleString);
}


#pragma mark - RTAlertView Delegate methods

-     (void)alertView:(RTAlertView *)alertView
 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked button at index %d in %@", buttonIndex, [[alertView class] description]);
}


- (void)willPresentAlertView:(RTAlertView *)alertView
{
    NSLog(@"Will present %@", [[alertView class] description]);
}


- (void)didPresentAlertView:(RTAlertView *)alertView
{
    NSLog(@"Did present %@", [[alertView class] description]);
}


-           (void)alertView:(RTAlertView *)alertView
 willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Will dismiss %@ with button index %d", [[alertView class] description], buttonIndex);
}


-          (void)alertView:(RTAlertView *)alertView
 didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Did dismiss %@ with button index %d", [[alertView class] description], buttonIndex);
}


- (void)alertViewCancel:(RTAlertView *)alertView
{
    NSLog(@"Will cancel %@", [[alertView class] description]);
    [self displayTextFieldsContent];
}


#pragma mark - Private methods

- (void)displayTextFieldsContent
{
    int numTextFields = 0;
    switch (self.alertViewStyle)
    {
        case UIAlertViewStylePlainTextInput:
        case UIAlertViewStyleSecureTextInput:
            numTextFields = 1;
            break;
        case UIAlertViewStyleLoginAndPasswordInput:
            numTextFields = 2;
            break;
        case UIAlertViewStyleDefault:
        default:
            numTextFields = 0;
            break;
    }
    
    for (int i=0; i < numTextFields; i++)
    {
        UITextField *textField = [self.alertView textFieldAtIndex:i];
        NSLog(@"TextField %d = %@", i, textField.text);
    }
}


@end
