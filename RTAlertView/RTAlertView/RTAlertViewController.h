//
//  RTAlertViewController.h
//  RTAlertView
//
//  Created by Roland Tecson on 12/7/2013.
//  Copyright (c) 2013 12 Harmonic Studios. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RTAlertView.h"


@interface RTAlertViewController : UIViewController

- (NSInteger)addButtonWithTitle:(NSString *)title;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex
                             animated:(BOOL)animated;

@property (strong, nonatomic) RTAlertView *alertView;
@property (weak, nonatomic) id<RTAlertViewDelegate> delegate;

@property (nonatomic) RTAlertViewStyle alertViewStyle;
@property (strong, nonatomic) NSString *alertViewTitle;
@property (strong, nonatomic) NSString *alertViewMessage;

@property (nonatomic, readonly, getter=isAlertViewVisible) BOOL alertViewVisible;

@property (nonatomic, readonly) NSInteger numberOfButtons;
@property (strong, nonatomic) NSString *cancelButtonTitle;
@property (nonatomic) NSInteger cancelButtonIndex;
@property (nonatomic, readonly) NSInteger firstOtherButtonIndex;

@property (nonatomic) BOOL dismissesWhenAppGoesToBackground;

@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *messageColor;
@property (strong, nonatomic) UIFont *messageFont;
@property (strong, nonatomic) UIColor *cancelButtonColor;
@property (strong, nonatomic) UIFont *cancelButtonFont;
@property (strong, nonatomic) UIColor *otherButtonColor;
@property (strong, nonatomic) UIFont *otherButtonFont;
@property (strong, nonatomic) UIFont *textFieldPlaceholderFont;
@property (strong, nonatomic) NSString *textField0PlaceholderText;
@property (strong, nonatomic) NSString *textField1PlaceholderText;


@end
