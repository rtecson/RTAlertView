//
//  RTAlertView.m
//  RTAlertView
//
//  Created by Roland Tecson on 11/22/2013.
//  Copyright (c) 2013 12 Harmonic Studios. All rights reserved.
//


#import "RTAlertView.h"
#import "RTAlertViewController.h"


@interface RTAlertView ()

@property (strong, nonatomic) RTAlertViewController *alertViewController;

@end


@implementation RTAlertView


#pragma mark - Init

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super init];
    if (self != nil)
    {
        // Initialise properties
        self.alertViewController.alertViewTitle = title;
        self.alertViewController.alertViewMessage = message;
        self.alertViewController.delegate = delegate;
        
        // Create cancel button if specified
        if (cancelButtonTitle != nil)
        {
            self.alertViewController.cancelButtonTitle = cancelButtonTitle;
            self.alertViewController.cancelButtonIndex = [self.alertViewController addButtonWithTitle:cancelButtonTitle];
        }

        // Variable number of otherButtonTitles
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
        {
            [self.alertViewController addButtonWithTitle:arg];
        }
        va_end(args);
    }

    return self;
}


#pragma mark - Public methods

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    return [self.alertViewController addButtonWithTitle:title];
}


- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    return [self.alertViewController buttonTitleAtIndex:buttonIndex];
}


- (void)show
{
    [self.alertViewController show];
}


- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex
{
    return [self.alertViewController textFieldAtIndex:textFieldIndex];
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex
                             animated:(BOOL)animated
{
    [self.alertViewController dismissWithClickedButtonIndex:buttonIndex
                                                   animated:animated];
}


#pragma mark - Public Getters

- (id<RTAlertViewDelegate>)delegate
{
    return self.alertViewController.delegate;
}


- (RTAlertViewStyle)alertViewStyle
{
    return self.alertViewController.alertViewStyle;
}


- (NSString *)title
{
    return self.alertViewController.alertViewTitle;
}


- (NSString *)message
{
    return self.alertViewController.alertViewMessage;
}


- (BOOL)isVisible
{
    return self.alertViewController.isAlertViewVisible;
}


- (NSInteger)numberOfButtons
{
    return self.alertViewController.numberOfButtons;
}


- (NSInteger)cancelButtonIndex
{
    return self.alertViewController.cancelButtonIndex;
}


- (NSInteger)firstOtherButtonIndex
{
    return self.alertViewController.firstOtherButtonIndex;
}


- (BOOL)dismissesWhenAppGoesToBackground
{
    return self.alertViewController.dismissesWhenAppGoesToBackground;
}


- (UIColor *)titleColor
{
    return self.alertViewController.titleColor;
}


- (UIFont *)titleFont
{
    return self.alertViewController.titleFont;
}


- (UIColor *)messageColor
{
    return self.alertViewController.messageColor;
}


- (UIFont *)messageFont
{
    return self.alertViewController.messageFont;
}


- (UIColor *)cancelButtonColor
{
    return self.alertViewController.cancelButtonColor;
}


- (UIFont *)cancelButtonFont
{
    return self.alertViewController.cancelButtonFont;
}


- (UIColor *)otherButtonColor
{
    return self.alertViewController.otherButtonColor;
}


- (UIFont *)otherButtonFont
{
    return self.alertViewController.otherButtonFont;
}


- (UIFont *)textFieldPlaceholderFont
{
    return self.alertViewController.textFieldPlaceholderFont;
}


- (NSString *)textField0PlaceholderText
{
    return self.alertViewController.textField0PlaceholderText;
}


- (NSString *)textField1PlaceholderText
{
    return self.alertViewController.textField1PlaceholderText;
}


#pragma mark - Public Setters

- (void)setDelegate:(id<RTAlertViewDelegate>)delegate
{
    self.alertViewController.delegate = delegate;
}


- (void)setAlertViewStyle:(RTAlertViewStyle)alertViewStyle
{
    self.alertViewController.alertViewStyle = alertViewStyle;
}


- (void)setTitle:(NSString *)title
{
    self.alertViewController.alertViewTitle = title;
}


- (void)setMessage:(NSString *)message
{
    self.alertViewController.alertViewMessage = message;
}


- (void)setCancelButtonIndex:(NSInteger)cancelButtonIndex
{
    self.alertViewController.cancelButtonIndex = cancelButtonIndex;
}


- (void)setDismissesWhenAppGoesToBackground:(BOOL)dismissesWhenAppGoesToBackground
{
    self.alertViewController.dismissesWhenAppGoesToBackground = dismissesWhenAppGoesToBackground;
}


- (void)setTitleColor:(UIColor *)titleColor
{
    self.alertViewController.titleColor = titleColor;
}


- (void)setTitleFont:(UIFont *)titleFont
{
    self.alertViewController.titleFont = titleFont;
}


- (void)setMessageColor:(UIColor *)messageColor
{
    self.alertViewController.messageColor = messageColor;
}


- (void)setMessageFont:(UIFont *)messageFont
{
    self.alertViewController.messageFont = messageFont;
}


- (void)setCancelButtonColor:(UIColor *)cancelButtonColor
{
    self.alertViewController.cancelButtonColor = cancelButtonColor;
}


- (void)setCancelButtonFont:(UIFont *)cancelButtonFont
{
    self.alertViewController.cancelButtonFont = cancelButtonFont;
}


- (void)setOtherButtonColor:(UIColor *)otherButtonColor
{
    self.alertViewController.otherButtonColor = otherButtonColor;
}


- (void)setOtherButtonFont:(UIFont *)otherButtonFont
{
    self.alertViewController.otherButtonFont = otherButtonFont;
}


- (void)setTextFieldPlaceholderFont:(UIFont *)textFieldPlaceholderFont
{
    self.alertViewController.textFieldPlaceholderFont = textFieldPlaceholderFont;
}


- (void)setTextField0PlaceholderText:(NSString *)textField0PlaceholderText
{
    self.alertViewController.textField0PlaceholderText = textField0PlaceholderText;
}


- (void)setTextField1PlaceholderText:(NSString *)textField1PlaceholderText
{
    self.alertViewController.textField1PlaceholderText = textField1PlaceholderText;
}


#pragma mark - Private Getters

- (RTAlertViewController *)alertViewController
{
    if (_alertViewController == nil)
    {
        _alertViewController = [[RTAlertViewController alloc] initWithNibName:nil
                                                                       bundle:nil];
        _alertViewController.alertView = self;
    }
    
    return _alertViewController;
}


@end
