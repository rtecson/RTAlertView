//
//  RTAlertView.h
//  RTAlertView
//
//  Created by Roland Tecson on 11/22/2013.
//  Copyright (c) 2013 12 Harmonic Studios. All rights reserved.
//
// The MIT License (MIT)
//
// Copyright (c) <year> <copyright holders>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import <UIKit/UIKit.h>


typedef enum {
    RTAlertViewStyleDefault = UIAlertViewStyleDefault,
    RTAlertViewStyleSecureTextInput = UIAlertViewStyleSecureTextInput,
    RTAlertViewStylePlainTextInput = UIAlertViewStylePlainTextInput,
    RTAlertViewStyleLoginAndPasswordInput = UIAlertViewStyleLoginAndPasswordInput,
    RTAlertViewStyleDoublePlainTextInput
} RTAlertViewStyle;


@class RTAlertView;

@protocol RTAlertViewDelegate <NSObject>

@optional

-     (void)alertView:(RTAlertView *)alertView
 clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentAlertView:(RTAlertView *)alertView;
- (void)didPresentAlertView:(RTAlertView *)alertView;
-           (void)alertView:(RTAlertView *)alertView
 willDismissWithButtonIndex:(NSInteger)buttonIndex;
-          (void)alertView:(RTAlertView *)alertView
 didDismissWithButtonIndex:(NSInteger)buttonIndex;

- (void)alertViewCancel:(RTAlertView *)alertView;

@end


@interface RTAlertView : NSObject

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (NSInteger)addButtonWithTitle:(NSString *)title;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex
                             animated:(BOOL)animated;

@property (weak, nonatomic) id<RTAlertViewDelegate> delegate;

@property (nonatomic) RTAlertViewStyle alertViewStyle;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;

@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, readonly) NSInteger numberOfButtons;

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
