//
//  RTAlertViewRecursiveButtonContainerView.m
//  RTAlertView
//
//  Created by Roland Tecson on 12/13/2013.
//  Copyright (c) 2013 MoozX Internet Ventures. All rights reserved.
//


#import "RTAlertViewRecursiveButtonContainerView.h"


static CGFloat kButton2EnabledWidth = 135.0f;
static CGFloat kButton2DisabledWidth = 0.0f;
static CGFloat kDividerThicknessRetina = 0.5f;
static CGFloat kDividerThicknessNonRetina = 1.0f;

#define kRtAlertViewDefaultButtonColor [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kRtAlertViewDefaultButtonFont  [UIFont systemFontOfSize:17.0f]


@interface RTAlertViewRecursiveButtonContainerView () <RTAlertViewRecursiveButtonContainerViewDelegate>

// IBOutlets

@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIView *horizontalDividerLine;
@property (weak, nonatomic) IBOutlet UIView *verticalDividerLine;
@property (weak, nonatomic) IBOutlet UIView *nextButtonContainer;

// Overridden readonly public properties

@property (nonatomic, readwrite) BOOL button1Enabled;
@property (nonatomic, readwrite) NSInteger numButtons;

// Private properties

@property (nonatomic) BOOL button2EnabledFlagHasChanged;
@property (nonatomic) BOOL displayIsRetina;

@property (strong, nonatomic) RTAlertViewRecursiveButtonContainerView *recursiveButtonContainerView;

@end


@implementation RTAlertViewRecursiveButtonContainerView


#pragma mark - Initialisers and dealloc

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        // Load XIB
        NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"RTAlertViewRecursiveButtonContainerView"
                                                          owner:self
                                                        options:nil];

        for (id xibObject in xibArray)
        {
            // Find object in XIB
            if ([xibObject isKindOfClass:[RTAlertViewRecursiveButtonContainerView class]])
            {
                self = xibObject;
            }
        }
    }
    
    return self;
}


- (void)initialiseProperties
{
    _button1Enabled = NO;
    _button2EnabledFlagHasChanged = NO;
    
    // Check for retina?
    CGFloat dividerThickness;
    if (self.displayIsRetina == YES)
    {
        // Retina
        dividerThickness = kDividerThicknessRetina;
    }
    else
    {
        // Non-retina
        dividerThickness = kDividerThicknessNonRetina;
    }
    
    // Set constraint for vertical divider height
    NSLayoutConstraint *hDividerHeight = [NSLayoutConstraint constraintWithItem:self.horizontalDividerLine
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:dividerThickness];
    [self.horizontalDividerLine addConstraint:hDividerHeight];

    // Set constraint for vertical divider height
    NSLayoutConstraint *vDividerWidth = [NSLayoutConstraint constraintWithItem:self.verticalDividerLine
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:dividerThickness];
    [self.verticalDividerLine addConstraint:vDividerWidth];
    
    // Set default button colours and fonts
    self.button0Color = kRtAlertViewDefaultButtonColor;
    self.button0Font = kRtAlertViewDefaultButtonFont;
    self.button1Color = kRtAlertViewDefaultButtonColor;
    self.button1Font = kRtAlertViewDefaultButtonFont;
    
    self.numButtons = 1;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSLog(@"In RTAlertViewRecursiveButtonContainerView awakeFromNib");
    NSLog(@"self frame: %@", NSStringFromCGRect(self.frame));
    [self initialiseProperties];
}


- (void)dealloc
{
    NSLog(@"In RTAlertViewRecursiveButtonContainerView dealloc");
}


#pragma mark - Setter methods

- (void)setButton1Enabled:(BOOL)button2Enabled
{
    if (button2Enabled != _button1Enabled)
    {
        _button1Enabled = button2Enabled;
        _button2EnabledFlagHasChanged = YES;
    }
}


- (void)setButton0Color:(UIColor *)button1Color
{
    [self.button0 setTitleColor:button1Color
                       forState:UIControlStateNormal];
    [self.button0 setBackgroundImage:[self imageFromColor:[button1Color colorWithAlphaComponent:0.1f]]
                            forState:UIControlStateHighlighted];
}


- (void)setButton1Color:(UIColor *)button2Color
{
    [self.button1 setTitleColor:button2Color
                       forState:UIControlStateNormal];
    [self.button1 setBackgroundImage:[self imageFromColor:[button2Color colorWithAlphaComponent:0.1f]]
                            forState:UIControlStateHighlighted];
}


- (void)setButton0Font:(UIFont *)button1Font
{
    self.button0.titleLabel.font = button1Font;
}


- (void)setButton1Font:(UIFont *)button2Font
{
    self.button1.titleLabel.font = button2Font;
}


#pragma mark - Getter methods

- (BOOL)displayIsRetina
{
    if ([UIScreen mainScreen].scale >= 2.0f)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark - Public methods

- (void)recursivelyAddButtons:(NSInteger)numButtons
                  useSplitRow:(BOOL)useSplitRow
{
    NSLog(@"In recursivelyAddButtons:(%d) useSplitRow:(%d)", numButtons, useSplitRow);
    if (numButtons == 0)
    {
        // Do nothing, end recursion
        return;
    }
    else if ((numButtons == 1) &&
             (useSplitRow == YES))
    {
        // Enable button 2
        self.button1Enabled = YES;
        
        // End recursion
        return;
    }
    else
    {
        // Save numButtons
        self.numButtons = numButtons;

        // Add recursive button container view into nextButtonContainer
        self.recursiveButtonContainerView = [[RTAlertViewRecursiveButtonContainerView alloc] init];
        self.recursiveButtonContainerView.delegate = self;
        [self.nextButtonContainer addSubview:self.recursiveButtonContainerView];

        // Set up autolayout constraints
        self.recursiveButtonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        RTAlertViewRecursiveButtonContainerView *recursiveButtonContainerView = self.recursiveButtonContainerView;
        NSDictionary *views = NSDictionaryOfVariableBindings(recursiveButtonContainerView);
        [self.nextButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[recursiveButtonContainerView]|"
                                                                                         options:0
                                                                                         metrics:0
                                                                                           views:views]];
        [self.nextButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[recursiveButtonContainerView]|"
                                                                                         options:0
                                                                                         metrics:0
                                                                                           views:views]];

        // Recursively add additional buttons
        [self.recursiveButtonContainerView recursivelyAddButtons:(numButtons - 1)
                                                     useSplitRow:NO];
    }
    
    return;
}


- (void)setTitle:(NSString *)buttonTitle
       forButton:(NSInteger)buttonNumber
{
    // Check for valid buttonTitle
    if ((buttonTitle == nil) ||
        (buttonTitle.length == 0))
    {
        // Do nothing
        return;
    }

    if (buttonNumber == 0)
    {
        [self.button0 setTitle:buttonTitle
                      forState:UIControlStateNormal];
        self.button0.titleEdgeInsets = UIEdgeInsetsMake(1.0f,
                                                        0.0f,
                                                        0.0f,
                                                        0.0f);
    }
    else if ((buttonNumber == 1) &&
             (self.button1Enabled == YES))
    {
        [self.button1 setTitle:buttonTitle
                      forState:UIControlStateNormal];
        self.button1.titleEdgeInsets = UIEdgeInsetsMake(1.0f,
                                                        0.0f,
                                                        0.0f,
                                                        0.0f);
    }
    else
    {
        // Recursively set button title
        [self.recursiveButtonContainerView setTitle:buttonTitle
                                          forButton:(buttonNumber - 1)];
    }
}


- (void)setTitleColor:(UIColor *)buttonTitleColor
            forButton:(NSInteger)buttonNumber
{
    // Check for valid buttonTitle
    if (buttonTitleColor == nil)
    {
        // Do nothing
        return;
    }
    
    if (buttonNumber == 0)
    {
        [self setButton0Color:buttonTitleColor];
    }
    else if ((buttonNumber == 1) &&
             (self.button1Enabled == YES))
    {
        [self setButton1Color:buttonTitleColor];
    }
    else
    {
        // Recursively set button title
        [self.recursiveButtonContainerView setTitleColor:buttonTitleColor
                                               forButton:(buttonNumber - 1)];
    }
}


- (void)setTitleFont:(UIFont *)buttonTitleFont
           forButton:(NSInteger)buttonNumber
{
    // Check for valid buttonTitle
    if (buttonTitleFont == nil)
    {
        // Do nothing
        return;
    }
    
    if (buttonNumber == 0)
    {
        [self setButton0Font:buttonTitleFont];
    }
    else if ((buttonNumber == 1) &&
             (self.button1Enabled == YES))
    {
        [self setButton1Font:buttonTitleFont];
    }
    else
    {
        // Recursively set button title
        [self.recursiveButtonContainerView setTitleFont:buttonTitleFont
                                              forButton:(buttonNumber - 1)];
    }
}


#pragma mark - Layout methods

- (void)updateConstraints
{
    // Has button2Enabled flag changed?
    if (self.button2EnabledFlagHasChanged == YES)
    {
        // Clear flag
        self.button2EnabledFlagHasChanged = NO;

        // Clear button2 constraints, width should be the only existing constraint
        NSArray *button2Constraints = self.button1.constraints;
        [self.button1 removeConstraints:button2Constraints];

        // Enabling or disabling?
        CGFloat button2Width;
        if (self.button1Enabled == YES)
        {
            // Enabling, show button2 and vertical divider
            self.button1.hidden = NO;
            self.verticalDividerLine.hidden = NO;

            // Set button2 width
            button2Width = kButton2EnabledWidth;
        }
        else
        {
            // Disabling, hide button2 and vertical divider
            self.button1.hidden = YES;
            self.verticalDividerLine.hidden = YES;

            // Set button2 width
            button2Width = kButton2DisabledWidth;
        }

        // Set constraint for button2 width
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.button1
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:button2Width];
        [self.button1 addConstraint:newConstraint];
    }
    
    // Call super after we're done
    [super updateConstraints];
}

/*
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSLog(@"Button 1, frame=%@", NSStringFromCGRect(self.button1.frame));
    NSLog(@"Button 2, frame=%@", NSStringFromCGRect(self.button2.frame));
    NSLog(@"Horizontal divider line, frame=%@", NSStringFromCGRect(self.horizontalDividerLine.frame));
    NSLog(@"Vertical divider line, frame=%@", NSStringFromCGRect(self.verticalDividerLine.frame));
    NSLog(@"Next button container, frame=%@", NSStringFromCGRect(self.nextButtonContainer.frame));
}
*/

#pragma mark - IBAction methods

- (IBAction)button1Tapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rtAlertViewRecursiveButtonContainerView:tappedButtonNumber:)] == YES)
    {
        [self.delegate rtAlertViewRecursiveButtonContainerView:self
                                            tappedButtonNumber:0];
    }
}


- (IBAction)button2Tapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rtAlertViewRecursiveButtonContainerView:tappedButtonNumber:)] == YES)
    {
        [self.delegate rtAlertViewRecursiveButtonContainerView:self
                                            tappedButtonNumber:1];
    }
}


#pragma mark - RTAlertViewRecursiveButtonContainerViewDelegate methods

- (void)rtAlertViewRecursiveButtonContainerView:(RTAlertViewRecursiveButtonContainerView *)rtAlertViewRecursiveButtonContainerView
                             tappedButtonNumber:(NSInteger)buttonNumber
{
    if ([self.delegate respondsToSelector:@selector(rtAlertViewRecursiveButtonContainerView:tappedButtonNumber:)] == YES)
    {
        // Pass through to delegate
        [self.delegate rtAlertViewRecursiveButtonContainerView:self
                                            tappedButtonNumber:(buttonNumber + 1)];
    }
}


#pragma mark - Private methods

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,
                             0.0f,
                             1.0f,
                             1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}


@end
