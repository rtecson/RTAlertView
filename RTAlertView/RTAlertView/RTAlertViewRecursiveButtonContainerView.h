//
//  RTAlertViewRecursiveButtonContainerView.h
//  RTAlertView
//
//  Created by Roland Tecson on 12/13/2013.
//  Copyright (c) 2013 12 Harmonic Studios. All rights reserved.
//


#import <UIKit/UIKit.h>


@class RTAlertViewRecursiveButtonContainerView;

@protocol RTAlertViewRecursiveButtonContainerViewDelegate <NSObject>

- (void)rtAlertViewRecursiveButtonContainerView:(RTAlertViewRecursiveButtonContainerView *)rtAlertViewRecursiveButtonContainerView
                             tappedButtonNumber:(NSInteger)buttonNumber;

@end


@interface RTAlertViewRecursiveButtonContainerView : UIView

// Recursively add RTAlertViewRecursiveButtonContainerViews, useSplitRow
// only applies if numButtons==2 (put two buttons in one row)

- (void)recursivelyAddButtons:(NSInteger)numButtons
                  useSplitRow:(BOOL)useSplitRow;       // YES: two buttons in one row, NO: one button per row

// Must call recursivelyAddButtons (if numButtons > 1) before calling these setTitle... methods

- (void)setTitle:(NSString *)buttonTitle
       forButton:(NSInteger)buttonNumber;

- (void)setTitleColor:(UIColor *)buttonTitleColor
            forButton:(NSInteger)buttonNumber;

- (void)setTitleFont:(UIFont *)buttonTitleFont
           forButton:(NSInteger)buttonNumber;

@property (weak, nonatomic) id<RTAlertViewRecursiveButtonContainerViewDelegate> delegate;

@property (nonatomic, readonly) NSInteger numButtons;
@property (nonatomic, readonly) BOOL button1Enabled;

@property (strong, nonatomic) UIColor *button0Color;
@property (strong, nonatomic) UIFont *button0Font;
@property (strong, nonatomic) UIColor *button1Color;
@property (strong, nonatomic) UIFont *button1Font;

@end
