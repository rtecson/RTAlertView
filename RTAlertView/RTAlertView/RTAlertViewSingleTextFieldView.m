//
//  RTAlertViewSingleTextFieldView.m
//  RTAlertView
//
//  Created by Roland Tecson on 12/15/2013.
//  Copyright (c) 2013 12 Harmonic Studios. All rights reserved.
//


#import "RTAlertViewSingleTextFieldView.h"


@interface RTAlertViewSingleTextFieldView ()

@end


@implementation RTAlertViewSingleTextFieldView


#pragma mark - Initialisers and dealloc

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        // Load XIB
        NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"RTAlertViewSingleTextFieldView"
                                                          owner:self
                                                        options:nil];
        
        for (id xibObject in xibArray)
        {
            // Find object in XIB
            if ([xibObject isKindOfClass:[RTAlertViewSingleTextFieldView class]])
            {
                self = xibObject;
            }
        }
    }

    return self;
}


#pragma mark - UIView methods

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(270.f,
                      48.0f);
}


@end
