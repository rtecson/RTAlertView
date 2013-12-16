//
//  RTAlertViewDoubleTextFieldView.m
//  RTAlertView
//
//  Created by Roland Tecson on 12/15/2013.
//  Copyright (c) 2013 12 Harmonic Studios. All rights reserved.
//


#import "RTAlertViewDoubleTextFieldView.h"


@implementation RTAlertViewDoubleTextFieldView


#pragma mark - Initialisers and dealloc

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        // Load XIB
        NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"RTAlertViewDoubleTextFieldView"
                                                          owner:self
                                                        options:nil];
        
        for (id xibObject in xibArray)
        {
            // Find object in XIB
            if ([xibObject isKindOfClass:[RTAlertViewDoubleTextFieldView class]])
            {
                self = xibObject;
            }
        }
    }

    return self;
}


@end
