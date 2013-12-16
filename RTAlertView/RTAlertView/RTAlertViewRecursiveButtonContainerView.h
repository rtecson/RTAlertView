//
//  RTAlertViewRecursiveButtonContainerView.h
//  RTAlertView
//
//  Created by Roland Tecson on 12/13/2013.
//  Copyright (c) 2013 MoozX Internet Ventures. All rights reserved.
//


#import <UIKit/UIKit.h>


@class RTAlertViewRecursiveButtonContainerView;

@protocol RTAlertViewRecursiveButtonContainerViewDelegate <NSObject>

- (void)rtAlertViewRecursiveButtonContainerView:(RTAlertViewRecursiveButtonContainerView *)rtAlertViewRecursiveButtonContainerView
                             tappedButtonNumber:(NSInteger)buttonNumber;

@end


@interface RTAlertViewRecursiveButtonContainerView : UIView

- (void)addRecursiveButtonContainerView:(RTAlertViewRecursiveButtonContainerView *)nextRecursiveButtonContainerView;

@property (weak, nonatomic) id<RTAlertViewRecursiveButtonContainerViewDelegate> delegate;

@property (nonatomic) BOOL button2Enabled;
@property (strong, nonatomic) UIColor *button0Color;
@property (strong, nonatomic) UIFont *button0Font;
@property (strong, nonatomic) UIColor *button1Color;
@property (strong, nonatomic) UIFont *button1Font;

@end
