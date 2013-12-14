//
//  RTAlertViewRecursiveButtonContainerView.m
//  RTAlertView
//
//  Created by Roland Tecson on 12/13/2013.
//  Copyright (c) 2013 MoozX Internet Ventures. All rights reserved.
//


#import "RTAlertViewRecursiveButtonContainerView.h"


@implementation RTAlertViewRecursiveButtonContainerView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        // Initialization code
        NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"RTAlertViewRecursiveButtonContainerView"
                                                          owner:self
                                                        options:nil];

        for (id xibObject in xibArray)
        {
            // Find object in XIB
            if ([xibObject isKindOfClass:[RTAlertViewRecursiveButtonContainerView class]])
            {
                //Use casting to cast (id) to (MyCustomView *)
                self = xibObject;
            }
        }
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil)
    {
        // Init
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)dealloc
{
    NSLog(@"In RTAlertViewRecursiveButtonContainerView dealloc");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
