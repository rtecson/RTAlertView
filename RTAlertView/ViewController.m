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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nativeButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberOfOtherButtonsSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *alertStyleSegmentedControl;

@property (nonatomic) NSInteger numberOfOtherButtons;
@property (nonatomic) RTAlertViewStyle alertViewStyle;

@property (weak, nonatomic) UIAlertView *alertView;

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIView *blurView;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        // iOS 6 and earlier
        blurView = [[UIView alloc] initWithFrame:self.gaussianBlurContainerView.bounds];
        blurView.backgroundColor = [UIColor whiteColor];
        blurView.alpha = 0.95f;
    }
    else
    {
        // iOS 7 and later
        blurView = [[UIToolbar alloc] initWithFrame:self.gaussianBlurContainerView.bounds];
    }
	blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.gaussianBlurContainerView addSubview:blurView];
    
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
    
    if (self.alertViewStyle == RTAlertViewStyleDoublePlainTextInput)
    {
        customAlertView.textField0PlaceholderText = @"Text field 1";
        customAlertView.textField1PlaceholderText = @"Text field 2";
    }

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
        case 4:
        {
            self.alertViewStyle = RTAlertViewStyleDoublePlainTextInput;
            break;
        }
        case 3:
        {
            self.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            break;
        }
        case 2:
        {
            self.alertViewStyle = UIAlertViewStyleSecureTextInput;
            break;
        }
        case 1:
        {
            self.alertViewStyle = UIAlertViewStylePlainTextInput;
            break;
        }
        case 0:
        default:
        {
            self.alertViewStyle = UIAlertViewStyleDefault;
            break;
        }
    }

    if (self.alertViewStyle == RTAlertViewStyleDoublePlainTextInput)
    {
        self.nativeButton.enabled = NO;
    }
    else
    {
        self.nativeButton.enabled = YES;
    }

    NSString *alertViewStyleString = nil;
    switch (self.alertViewStyle)
    {
        case RTAlertViewStyleDoublePlainTextInput:
        {
            alertViewStyleString = @"Double Plain Text";
            break;
        }
        case UIAlertViewStylePlainTextInput:
        {
            alertViewStyleString = @"Plain Text";
            break;
        }
        case UIAlertViewStyleSecureTextInput:
        {
            alertViewStyleString = @"Secure Text";
            break;
        }
        case UIAlertViewStyleLoginAndPasswordInput:
        {
            alertViewStyleString = @"Login/Password";
            break;
        }
        case UIAlertViewStyleDefault:
        default:
        {
            alertViewStyleString = @"Default";
            break;
        }
    }
    NSLog(@"Alert view style selected = %@", alertViewStyleString);
}


#pragma mark - RTAlertView Delegate methods

-     (void)alertView:(RTAlertView *)alertView
 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked button at index %ld in %@", (long)buttonIndex, [[alertView class] description]);
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
    NSLog(@"Will dismiss %@ with button index %ld", [[alertView class] description], (long)buttonIndex);
}


-          (void)alertView:(RTAlertView *)alertView
 didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Did dismiss %@ with button index %ld", [[alertView class] description], (long)buttonIndex);
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
        case RTAlertViewStyleDoublePlainTextInput:
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
