//
//  RTAlertViewController.m
//  RTAlertView
//
//  Created by Roland Tecson on 12/7/2013.
//  Copyright (c) 2013 12 Harmonic Studios. All rights reserved.
//


#import "RTAlertViewController.h"
#import "RTAlertViewRecursiveButtonContainerView.h"
#import "RTAlertViewSingleTextFieldView.h"
#import "RTAlertViewDoubleTextFieldView.h"
#import <RBBSpringAnimation.h>


// Constants
#define kRtAlertViewColourTitle [UIColor blackColor]
#define kRtAlertViewFontTitle  [UIFont boldSystemFontOfSize:17.0f]
#define kRtAlertViewColourMessage [UIColor blackColor]
#define kRtAlertViewFontMessage  [UIFont systemFontOfSize:14.0f]
#define kRtAlertViewColourCancelButton [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kRtAlertViewFontCancelButton  [UIFont boldSystemFontOfSize:17.0f]
#define kRtAlertViewColourOtherButton [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kRtAlertViewFontOtherButton  [UIFont systemFontOfSize:17.0f]
#define kRtAlertViewFontTextFieldPlacholder [UIFont systemFontOfSize:13.0f]


static CGFloat kRtAlertViewRadiusCorner = 7.0f;
static CGFloat kRtAlertViewHeightKeyboardHidden = 0.0f;
static CGFloat kRtAlertViewMotionEffectRelativeValue = 15.0f;


@interface RTAlertViewController () <RTAlertViewRecursiveButtonContainerViewDelegate>

// Override public read-only properties

@property (nonatomic, readwrite, getter=isAlertViewVisible) BOOL alertViewVisible;
@property (nonatomic, readwrite) NSInteger firstOtherButtonIndex;

// IBOutlets

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *blackTransparentContainerView;
@property (weak, nonatomic) IBOutlet UIView *alertContainerView;
@property (weak, nonatomic) IBOutlet UIView *gaussianBlurContainerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintForKeyboardSizeMirroringView;


// Private properties

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIWindow *appKeyWindow;
@property (strong, nonatomic) RTAlertViewRecursiveButtonContainerView *recursiveButtonContainerView;

@property (strong, nonatomic) NSMutableArray *buttonTitleArray;
@property (nonatomic) NSInteger clickedButtonIndex;
@property (strong, nonatomic) NSMutableArray *textFieldArray;

@end


@implementation RTAlertViewController


#pragma mark - UIViewController methods

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RTAlertViewController"
                           bundle:nibBundleOrNil];
    if (self != nil)
    {
        // Initialize properties to default values
        self.titleColor = kRtAlertViewColourTitle;
        self.titleFont = kRtAlertViewFontTitle;
        self.messageColor = kRtAlertViewColourMessage;
        self.messageFont = kRtAlertViewFontMessage;
        self.cancelButtonColor = kRtAlertViewColourCancelButton;
        self.cancelButtonFont = kRtAlertViewFontCancelButton;
        self.otherButtonColor = kRtAlertViewColourOtherButton;
        self.otherButtonFont = kRtAlertViewFontOtherButton;
        self.textFieldPlaceholderFont = kRtAlertViewFontTextFieldPlacholder;

        self.alertViewVisible = NO;
        self.cancelButtonIndex = -1;
        self.firstOtherButtonIndex = -1;
        self.clickedButtonIndex = -1;
        self.dismissesWhenAppGoesToBackground = YES;
    }

    return self;
}


#pragma mark - UIView methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Initialise keyboard height constraint
    self.heightConstraintForKeyboardSizeMirroringView.constant = kRtAlertViewHeightKeyboardHidden;

    [self setupAlertView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Register for keyboard show notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // De-register for keyboard show notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public Getters

- (NSInteger)numberOfButtons
{
    return self.buttonTitleArray.count;
}


- (NSInteger)firstOtherButtonIndex
{
    if ((self.cancelButtonIndex == 0) &&
        (self.numberOfButtons > 1))
    {
        // Cancel button is first button, two or more buttons exist
        return 1;
    }
    else if ((self.cancelButtonIndex == -1) &&
             (self.numberOfButtons > 0))
    {
        // No cancel button, one or more buttons exist
        return 0;
    }
    else if ((self.cancelButtonIndex > 0) &&
             (self.numberOfButtons > 1))
    {
        // Cancel button is not first button
        return 0;
    }
    else
    {
        return -1;
    }
}


#pragma mark - Public Setters

- (void)setAlertViewStyle:(RTAlertViewStyle)alertViewStyle
{
    _alertViewStyle = alertViewStyle;
    
    // Reinitialize internal data structures for text fields
    _textFieldArray = nil;
    
    if (alertViewStyle == RTAlertViewStyleDoublePlainTextInput)
    {
        self.textField0PlaceholderText = @"";
        self.textField1PlaceholderText = @"";
    }
}


- (void)setCancelButtonIndex:(NSInteger)cancelButtonIndex
{
    // Is cancelButtonIndex valid?
    if (cancelButtonIndex < self.numberOfButtons)
    {
        // Yes, save it
        _cancelButtonIndex = cancelButtonIndex;
    }
}


- (void)setDismissesWhenAppGoesToBackground:(BOOL)dismissesWhenAppGoesToBackground
{
    if (_dismissesWhenAppGoesToBackground == dismissesWhenAppGoesToBackground)
    {
        return;
    }

    _dismissesWhenAppGoesToBackground = dismissesWhenAppGoesToBackground;
    if (dismissesWhenAppGoesToBackground == YES)
    {
        [self registerForApplicationDidEnterBackgroundNotification];
    }
    else
    {
        [self deregisterForApplicationDidEnterBackgroundNotification];
    }
}


#pragma mark - Private Getters

- (NSMutableArray *)buttonTitleArray
{
    if (_buttonTitleArray == nil)
    {
        // Lazy instantiation
        _buttonTitleArray = [[NSMutableArray alloc] init];
    }
    
    return _buttonTitleArray;
}


#pragma mark - Public methods

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    if (title != nil)
    {
        [self.buttonTitleArray addObject:title];
        
        // Return index of just-added button
        return (self.numberOfButtons - 1);
    }
    else
    {
        return -1;
    }
}


- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    if ((buttonIndex < self.numberOfButtons) &&
        (buttonIndex > -1))
    {
        return [self.buttonTitleArray objectAtIndex:buttonIndex];
    }
    else
    {
        return nil;
    }
}


- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex
{
    // TODO: Raise NSRangeException if textFieldIndex is inconsistent with alertViewStyle
    if (self.alertViewStyle == RTAlertViewStyleDefault)
    {
        return nil;
    }

    if (textFieldIndex < 0)
    {
        // textFieldIndex is valid
        return nil;
    }
    
    if (((self.alertViewStyle == RTAlertViewStyleLoginAndPasswordInput) ||
         (self.alertViewStyle == RTAlertViewStyleDoublePlainTextInput)) &&
        (textFieldIndex > 1))
    {
        // textFieldIndex is valid
        return nil;
    }
    
    if (((self.alertViewStyle == RTAlertViewStylePlainTextInput) ||
         (self.alertViewStyle == RTAlertViewStyleSecureTextInput)) &&
        (textFieldIndex > 0))
    {
        // textFieldIndex is valid
        return nil;
    }
    
    return [self.textFieldArray objectAtIndex:textFieldIndex];
}


- (void)show
{
    if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)])
    {
        [self.delegate willPresentAlertView:self.alertView];
    }

    [self setAsRootViewController];
    [self showAlertView];
    
    self.alertViewVisible = YES;
    
    if ([self.delegate respondsToSelector:@selector(didPresentAlertView:)])
    {
        [self.delegate didPresentAlertView:self.alertView];
    }
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex
                             animated:(BOOL)animated
{
    if (buttonIndex < self.numberOfButtons)
    {
        self.clickedButtonIndex = buttonIndex;
    }

    [self dismiss];
}


#pragma mark - RTAlertViewRecursiveButtonContainerViewDelegate methods

- (void)rtAlertViewRecursiveButtonContainerView:(RTAlertViewRecursiveButtonContainerView *)rtAlertViewRecursiveButtonContainerView
                             tappedButtonNumber:(NSInteger)buttonNumber
{
//    NSLog(@"Button %d tapped", buttonNumber);
    self.clickedButtonIndex = buttonNumber;
    
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
    {
        [self.delegate alertView:self.alertView
            clickedButtonAtIndex:self.clickedButtonIndex];
    }

    [self dismiss];
}


#pragma mark - Private methods

- (void)setupAlertView
{
    // Set up blur view
    UIView *blurView;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        // iOS 6.1 or earlier
        blurView = [[UIView alloc] init];
        blurView.backgroundColor = [UIColor whiteColor];
        blurView.alpha = 0.95f;
    }
    else
    {
        // iOS 7 or later
        blurView = [[UIToolbar alloc] init];
    }
	[self.gaussianBlurContainerView addSubview:blurView];
    blurView.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = NSDictionaryOfVariableBindings(blurView);
    [self.gaussianBlurContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|"
                                                                                           options:0
                                                                                           metrics:0
                                                                                             views:views]];
    [self.gaussianBlurContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|"
                                                                                           options:0
                                                                                           metrics:0
                                                                                             views:views]];

    [self setupLabels];
    [self setupTextFields];
    [self setupButtons];
    [self setupParallax];

	[self.alertContainerView.layer setMasksToBounds:YES];
	[self.alertContainerView.layer setCornerRadius:kRtAlertViewRadiusCorner];
}


- (void)setupLabels
{
    self.titleLabel.text = self.alertViewTitle;
    self.titleLabel.textColor = self.titleColor;
    self.titleLabel.font = self.titleFont;
    self.messageLabel.text = self.alertViewMessage;
    self.messageLabel.textColor = self.messageColor;
    self.messageLabel.font = self.messageFont;
}


- (void)setupTextFields
{
    switch (self.alertViewStyle)
    {
        case RTAlertViewStylePlainTextInput:
        case RTAlertViewStyleSecureTextInput:
        {
            // Create singleTextFieldView
            RTAlertViewSingleTextFieldView *singleTextFieldView = [[RTAlertViewSingleTextFieldView alloc] init];
            [self.textFieldContainerView addSubview:singleTextFieldView];
            
            // Set up autolayout constraints
            singleTextFieldView.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = NSDictionaryOfVariableBindings(singleTextFieldView);
            [self.textFieldContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[singleTextFieldView]|"
                                                                                                options:0
                                                                                                metrics:0
                                                                                                  views:views]];
            [self.textFieldContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[singleTextFieldView]|"
                                                                                                options:0
                                                                                                metrics:0
                                                                                                  views:views]];

            // Set up textField properties
            singleTextFieldView.textField.backgroundColor = [UIColor clearColor];
            singleTextFieldView.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
            singleTextFieldView.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            singleTextFieldView.textField.returnKeyType = UIReturnKeyNext;
            singleTextFieldView.textField.borderStyle = UITextBorderStyleNone;
            singleTextFieldView.textField.font = self.textFieldPlaceholderFont;
            if (self.alertViewStyle == RTAlertViewStylePlainTextInput)
            {
                singleTextFieldView.textField.secureTextEntry = NO;
            }
            else
            {
                singleTextFieldView.textField.secureTextEntry = YES;
            }
            
            // Set first responder (keyboard shows)
            [singleTextFieldView.textField becomeFirstResponder];
            
            // Set up textFieldArray
            self.textFieldArray = [[NSMutableArray alloc] initWithCapacity:1];
            [self.textFieldArray addObject:singleTextFieldView.textField];
        }
            break;
        case RTAlertViewStyleLoginAndPasswordInput:
        case RTAlertViewStyleDoublePlainTextInput:
        {
            // Create doubleTextFieldView
            RTAlertViewDoubleTextFieldView *doubleTextFieldView = [[RTAlertViewDoubleTextFieldView alloc] init];
            [self.textFieldContainerView addSubview:doubleTextFieldView];
            
            // Set up autolayout constraints
            doubleTextFieldView.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = NSDictionaryOfVariableBindings(doubleTextFieldView);
            [self.textFieldContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[doubleTextFieldView]|"
                                                                                                options:0
                                                                                                metrics:0
                                                                                                  views:views]];
            [self.textFieldContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[doubleTextFieldView]|"
                                                                                                options:0
                                                                                                metrics:0
                                                                                                  views:views]];
            
            // Set up textField properties
            doubleTextFieldView.textField0.backgroundColor = [UIColor clearColor];
            doubleTextFieldView.textField0.keyboardAppearance = UIKeyboardAppearanceAlert;
            doubleTextFieldView.textField0.clearButtonMode = UITextFieldViewModeWhileEditing;
            doubleTextFieldView.textField0.returnKeyType = UIReturnKeyNext;
            doubleTextFieldView.textField0.borderStyle = UITextBorderStyleNone;
            doubleTextFieldView.textField0.font = self.textFieldPlaceholderFont;
            doubleTextFieldView.textField0.secureTextEntry = NO;
            doubleTextFieldView.textField0.placeholder = self.textField0PlaceholderText == nil ? @"Login" : self.textField0PlaceholderText;
            doubleTextFieldView.textField1.backgroundColor = [UIColor clearColor];
            doubleTextFieldView.textField1.keyboardAppearance = UIKeyboardAppearanceAlert;
            doubleTextFieldView.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
            doubleTextFieldView.textField1.returnKeyType = UIReturnKeyNext;
            doubleTextFieldView.textField1.borderStyle = UITextBorderStyleNone;
            doubleTextFieldView.textField1.font = self.textFieldPlaceholderFont;
            if (self.alertViewStyle == RTAlertViewStyleLoginAndPasswordInput)
            {
                doubleTextFieldView.textField1.secureTextEntry = YES;
            }
            else
            {
                doubleTextFieldView.textField1.secureTextEntry = NO;
            }
            doubleTextFieldView.textField1.placeholder = self.textField1PlaceholderText == nil ? @"Password" : self.textField1PlaceholderText;

            // Set first responder (keyboard shows)
            [doubleTextFieldView.textField0 becomeFirstResponder];

            // Set up textFieldArray
            self.textFieldArray = [[NSMutableArray alloc] initWithCapacity:1];
            [self.textFieldArray addObject:doubleTextFieldView.textField0];
            [self.textFieldArray addObject:doubleTextFieldView.textField1];
        }
            break;
        case RTAlertViewStyleDefault:
        default:
        {
            // Do nothing
        }
            break;
    }
}


- (void)setupButtons
{
    // Any buttons added?
    if (self.numberOfButtons == 0)
    {
        return;
    }

    // Create first recursiveButtonContainerView
    self.recursiveButtonContainerView = [[RTAlertViewRecursiveButtonContainerView alloc] init];
    self.recursiveButtonContainerView.delegate = self;
    [self.buttonContainerView addSubview:self.recursiveButtonContainerView];
//    NSLog(@"recursiveButtonContainerView frame=%@", NSStringFromCGRect(recursiveButtonContainerView.frame));

    // Set up autolayout constraints
    self.recursiveButtonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    RTAlertViewRecursiveButtonContainerView *recursiveButtonContainerView = self.recursiveButtonContainerView;
    NSDictionary *views = NSDictionaryOfVariableBindings(recursiveButtonContainerView);
    [self.buttonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[recursiveButtonContainerView]|"
                                                                                     options:0
                                                                                     metrics:0
                                                                                       views:views]];
    [self.buttonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[recursiveButtonContainerView]|"
                                                                                     options:0
                                                                                     metrics:0
                                                                                       views:views]];

    // Add rest of recursiveButtonContainerViews
    [self.recursiveButtonContainerView recursivelyAddButtons:(self.numberOfButtons - 1)
                                                 useSplitRow:YES];
    
    // Set up button titles, button title colours, button title fonts
    for (int i=0; i<self.numberOfButtons; i++)
    {
        [self.recursiveButtonContainerView setTitle:[self buttonTitleAtIndex:i]
                                          forButton:i];

        if (i == self.cancelButtonIndex)
        {
            [self.recursiveButtonContainerView setTitleColor:self.cancelButtonColor
                                                   forButton:i];
            [self.recursiveButtonContainerView setTitleFont:self.cancelButtonFont
                                                  forButton:i];
        }
        else
        {
            [self.recursiveButtonContainerView setTitleColor:self.otherButtonColor
                                                   forButton:i];
            [self.recursiveButtonContainerView setTitleFont:self.otherButtonFont
                                                  forButton:i];
        }
    }
}


- (void)setAsRootViewController
{
	id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
	self.window = [[UIWindow alloc] initWithFrame:[appDelegate window].frame];

	self.window.rootViewController = self;
	// Without this, the alert background will appear black on rotation
	self.window.backgroundColor = [UIColor clearColor];
	self.window.windowLevel = UIWindowLevelAlert;
	self.window.hidden = NO;

    // Save current app keyWindow
    self.appKeyWindow = [[UIApplication sharedApplication] keyWindow];

	[self.window makeKeyAndVisible];
}


- (void)showAlertView
{
    [CATransaction begin]; {
		CATransform3D transformFrom = CATransform3DMakeScale(1.26, 1.26, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(1.0, 1.0, 1.0);
		
		RBBSpringAnimation *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		self.alertContainerView.layer.transform = transformTo;
		
		// Zoom in the modal
		[self.alertContainerView.layer addAnimation:modalTransformAnimation
                                             forKey:@"transform"];
		RBBSpringAnimation *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
		opacityAnimation.fromValue = @0.0f;
		opacityAnimation.toValue = @1.0f;
		self.blackTransparentContainerView.layer.opacity = 1.0f;
		self.gaussianBlurContainerView.layer.opacity = 1.0f;
		self.contentView.layer.opacity = 1.0f;
		
		// Fade in
		[self.blackTransparentContainerView.layer addAnimation:opacityAnimation
                                              forKey:@"opacity"];
		[self.gaussianBlurContainerView.layer addAnimation:opacityAnimation
                                                    forKey:@"opacity"];
		[self.contentView.layer addAnimation:opacityAnimation
                                      forKey:@"opacity"];
	} [CATransaction commit];

    // Set tintColor of all controls behind alert view to dimmed
    if ([self.appKeyWindow respondsToSelector:@selector(tintAdjustmentMode)])
    {
        self.appKeyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    }
}


- (void)dismiss
{
    [self deregisterForApplicationDidEnterBackgroundNotification];
    
    if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
    {
        [self.delegate alertView:self.alertView
      willDismissWithButtonIndex:self.clickedButtonIndex];
    }
    
    if ((self.cancelButtonIndex == self.clickedButtonIndex) &&
        ([self.delegate respondsToSelector:@selector(alertViewCancel:)]))
    {
        [self.delegate alertViewCancel:self.alertView];
    }
    
    [self dismissAlertView];

    // Release keyboard for each text field
    for (int i=0; i<self.textFieldArray.count; i++)
    {
        UITextField *textField = [self.textFieldArray objectAtIndex:i];
        [textField resignFirstResponder];
    }

    if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
    {
        [self.delegate alertView:self.alertView
       didDismissWithButtonIndex:self.clickedButtonIndex];
    }
}


- (void)dismissAlertView
{
	[CATransaction begin]; {
		CATransform3D transformFrom = CATransform3DMakeScale(1.0, 1.0, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(0.840, 0.840, 1.0);

		RBBSpringAnimation *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		modalTransformAnimation.delegate = self;
		self.alertContainerView.layer.transform = transformTo;

		// Zoom out the modal
		[self.alertContainerView.layer addAnimation:modalTransformAnimation
                                             forKey:@"transform"];

		RBBSpringAnimation *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
		opacityAnimation.fromValue = @1.0f;
		opacityAnimation.toValue = @0.0f;
		self.blackTransparentContainerView.layer.opacity = 0.0;
		self.gaussianBlurContainerView.layer.opacity = 0.0;
		self.contentView.layer.opacity = 0.0;

		// Fade out
		[self.blackTransparentContainerView.layer addAnimation:opacityAnimation
                                                    forKey:@"opacity"];
		[self.gaussianBlurContainerView.layer addAnimation:opacityAnimation
                                                    forKey:@"opacity"];
		[self.contentView.layer addAnimation:opacityAnimation
                                      forKey:@"opacity"];
	} [CATransaction commit];
    
    // Set tintColor of all controls behind alert view to normal
    if ([self.appKeyWindow respondsToSelector:@selector(tintAdjustmentMode)])
    {
        self.appKeyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    }
}


- (id)springAnimationForKeyPath:(NSString *)keyPath
{
	RBBSpringAnimation *animation = [[RBBSpringAnimation alloc] init];

    // Copied from LMAlertView, https://github.com/lmcd/LMAlertView

	// Values reversed engineered from iOS 7 UIAlertView
	animation.keyPath = keyPath;
	animation.velocity = 0.0;
	animation.mass = 3.0;
	animation.stiffness = 1000.0;
	animation.damping = 500.0;
	// todo - figure out how iOS is deriving this number
	animation.duration = 0.5058237314224243;
	
	return animation;
}


- (void)animationDidStop:(CAAnimation *)theAnimation
                finished:(BOOL)flag
{
    self.alertViewVisible = NO;
    
	// Release window from memory
	self.window.hidden = YES;
	self.window = nil;

    // Release RTAlertView, important or retain cycle is not broken
    self.alertView = nil;
}


- (void)registerForApplicationDidEnterBackgroundNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}


- (void)deregisterForApplicationDidEnterBackgroundNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}


- (void)setupParallax
{
    // Check if parallax classes are available (iOS 7+)
    if (NSClassFromString(@"UIInterpolatingMotionEffect") != nil)
    {
        // iOS 7 or later, ok. Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                            type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-1.0f * kRtAlertViewMotionEffectRelativeValue);
        verticalMotionEffect.maximumRelativeValue = @(kRtAlertViewMotionEffectRelativeValue);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                              type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-1.0f * kRtAlertViewMotionEffectRelativeValue);
        horizontalMotionEffect.maximumRelativeValue = @(kRtAlertViewMotionEffectRelativeValue);
        
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        // Add both effects to view
        [self.alertContainerView addMotionEffect:group];
    }
}


#pragma mark - UINotification handlers

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];

    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGFloat keyboardHeight = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;
    
    // Change bottom layout constraint of height adjustable container view
    self.heightConstraintForKeyboardSizeMirroringView.constant = keyboardHeight;
}


- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    self.clickedButtonIndex = -1;
    [self dismiss];
}


@end
