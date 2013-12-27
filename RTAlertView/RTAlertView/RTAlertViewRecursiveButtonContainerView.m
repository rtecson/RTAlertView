//
//  RTAlertViewRecursiveButtonContainerView.m
//  RTAlertView
//
//  Created by Roland Tecson on 12/13/2013.
//  Copyright (c) 2013 12 Harmonic Studios. All rights reserved.
//


#import "RTAlertViewRecursiveButtonContainerView.h"


static CGFloat kRtAlertViewWidthButton1Enabled = 135.0f;
static CGFloat kRtAlertViewWidthButton1Disabled = 0.0f;
static CGFloat kRtAlertViewThicknessDividerRetina = 0.5f;
static CGFloat kRtAlertViewThicknessDividerNonRetina = 1.0f;
static CGFloat kRtAlertViewTopConstraintConstantAdjustmentHorizontalDivider = -0.5f;

#define kRtAlertViewDefaultColourButton [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kRtAlertViewDefaultFontButton  [UIFont systemFontOfSize:17.0f]


@interface RTAlertViewRecursiveButtonContainerView () <RTAlertViewRecursiveButtonContainerViewDelegate>

// IBOutlets

@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIView *horizontalDividerLine;
@property (weak, nonatomic) IBOutlet UIView *verticalDividerLine;
@property (weak, nonatomic) IBOutlet UIView *nextButtonContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraintForButton1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintForHorizontalDividerLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraintForVerticalDividerLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintForHorizontalDividerLine;

// Overridden readonly public properties

@property (nonatomic, readwrite) BOOL button1Enabled;
@property (nonatomic, readwrite) NSInteger numButtons;

// Private properties

@property (nonatomic) BOOL button1EnabledFlagHasChanged;
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
    _button1EnabledFlagHasChanged = NO;
    
    // Check for retina?
    if (self.displayIsRetina == YES)
    {
        // Update width constraints of divider lines
        self.heightConstraintForHorizontalDividerLine.constant = kRtAlertViewThicknessDividerRetina;
        self.widthConstraintForVerticalDividerLine.constant = kRtAlertViewThicknessDividerRetina;
        
        // Update top constraint of horizontal divider line
        self.topConstraintForHorizontalDividerLine.constant -= kRtAlertViewTopConstraintConstantAdjustmentHorizontalDivider;
    }
    else
    {
        // Update width constraints of divider lines
        self.heightConstraintForHorizontalDividerLine.constant = kRtAlertViewThicknessDividerNonRetina;
        self.widthConstraintForVerticalDividerLine.constant = kRtAlertViewThicknessDividerNonRetina;
    }

    // Set default button colours and fonts
    self.button0Color = kRtAlertViewDefaultColourButton;
    self.button0Font = kRtAlertViewDefaultFontButton;
    self.button1Color = kRtAlertViewDefaultColourButton;
    self.button1Font = kRtAlertViewDefaultFontButton;
    
    self.numButtons = 1;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    NSLog(@"In RTAlertViewRecursiveButtonContainerView awakeFromNib");
//    NSLog(@"self frame: %@", NSStringFromCGRect(self.frame));
    [self initialiseProperties];
}

/*
- (void)dealloc
{
    NSLog(@"In RTAlertViewRecursiveButtonContainerView dealloc");
}
*/

#pragma mark - Setter methods

- (void)setButton1Enabled:(BOOL)button2Enabled
{
    if (button2Enabled != _button1Enabled)
    {
        _button1Enabled = button2Enabled;
        _button1EnabledFlagHasChanged = YES;
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
//    NSLog(@"In recursivelyAddButtons:(%d) useSplitRow:(%d)", numButtons, useSplitRow);
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
        self.button0Color = buttonTitleColor;
    }
    else if ((buttonNumber == 1) &&
             (self.button1Enabled == YES))
    {
        self.button1Color = buttonTitleColor;
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
        self.button0Font = buttonTitleFont;
    }
    else if ((buttonNumber == 1) &&
             (self.button1Enabled == YES))
    {
        self.button1Font = buttonTitleFont;
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
    // Has button1Enabled flag changed?
    if (self.button1EnabledFlagHasChanged == YES)
    {
        // Clear flag
        self.button1EnabledFlagHasChanged = NO;

        // Enabling or disabling?
        CGFloat button1Width;
        if (self.button1Enabled == YES)
        {
            // Enabling, show button1 and vertical divider
            self.button1.hidden = NO;
            self.verticalDividerLine.hidden = NO;

            // Set button1 width
            button1Width = kRtAlertViewWidthButton1Enabled;
        }
        else
        {
            // Disabling, hide button1 and vertical divider
            self.button1.hidden = YES;
            self.verticalDividerLine.hidden = YES;

            // Set button1 width
            button1Width = kRtAlertViewWidthButton1Disabled;
        }

        // Update constraint for button1 width
        self.widthConstraintForButton1.constant = button1Width;
    }
    
    // Call super after we're done
    [super updateConstraints];
}


#pragma mark - IBAction methods

- (IBAction)button0Tapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rtAlertViewRecursiveButtonContainerView:tappedButtonNumber:)] == YES)
    {
        [self.delegate rtAlertViewRecursiveButtonContainerView:self
                                            tappedButtonNumber:0];
    }
}


- (IBAction)button1Tapped:(id)sender
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
