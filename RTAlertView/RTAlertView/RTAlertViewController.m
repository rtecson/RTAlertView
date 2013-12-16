//
//  RTAlertViewController.m
//  RTAlertView
//
//  Created by Roland Tecson on 12/7/2013.
//  Copyright (c) 2013 12 Harmonic Studios. All rights reserved.
//


#import "RTAlertViewController.h"
#import "RTAlertViewRecursiveButtonContainerView.h"


// Constants
#define kRtAlertViewTitleColor [UIColor blackColor]
#define kRtAlertViewTitleFont  [UIFont boldSystemFontOfSize:17.0f]
#define kRtAlertViewMessageColor [UIColor blackColor]
#define kRtAlertViewMessageFont  [UIFont systemFontOfSize:14.0f]
#define kRtAlertViewCancelButtonColor [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kRtAlertViewCancelButtonFont  [UIFont boldSystemFontOfSize:17.0f]
#define kRtAlertViewOtherButtonColor [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kRtAlertViewOtherButtonFont  [UIFont systemFontOfSize:17.0f]

static CGFloat kRtAlertViewCornerRadius = 7.0f;


#define RTSpringAnimation CASpringAnimation

// Animation of alert view, spring type animation
@interface CASpringAnimation : CABasicAnimation

- (float)damping;
- (double)durationForEpsilon:(double)arg1;
- (float)mass;
- (void)setDamping:(float)arg1;
- (void)setMass:(float)arg1;
- (void)setStiffness:(float)arg1;
- (void)setVelocity:(float)arg1;
- (float)stiffness;
- (float)velocity;

@end


@interface RTAlertViewController () <RTAlertViewRecursiveButtonContainerViewDelegate>

// Override public read-only properties

@property (nonatomic, readwrite, getter=isAlertViewVisible) BOOL alertViewVisible;
@property (nonatomic, readwrite) NSInteger firstOtherButtonIndex;

// IBOutlets

@property (weak, nonatomic) IBOutlet UIView *blackTransparentContainerView;
@property (weak, nonatomic) IBOutlet UIView *alertContainerView;
@property (weak, nonatomic) IBOutlet UIView *gaussianBlurContainerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;


// Private properties

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *buttonTitleArray;
@property (strong, nonatomic) NSMutableArray *buttonArray;
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
        self.titleColor = kRtAlertViewTitleColor;
        self.titleFont = kRtAlertViewTitleFont;
        self.messageColor = kRtAlertViewMessageColor;
        self.messageFont = kRtAlertViewMessageFont;
        self.cancelButtonColor = kRtAlertViewCancelButtonColor;
        self.cancelButtonFont = kRtAlertViewCancelButtonFont;
        self.otherButtonColor = kRtAlertViewOtherButtonColor;
        self.otherButtonFont = kRtAlertViewOtherButtonFont;

        self.alertViewVisible = NO;
        self.cancelButtonIndex = -1;
        self.firstOtherButtonIndex = -1;
        self.clickedButtonIndex = -1;
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupAlertView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    NSLog(@"In viewDidLayoutSubviews");
    NSLog(@"alertContainerView frame: %@", NSStringFromCGRect(self.alertContainerView.frame));
    NSLog(@"gaussianBlurContainerView frame: %@", NSStringFromCGRect(self.gaussianBlurContainerView.frame));
    NSLog(@"contentView frame: %@", NSStringFromCGRect(self.contentView.frame));
    NSLog(@"buttonContainerView frame: %@", NSStringFromCGRect(self.buttonContainerView.frame));
    NSLog(@"textFieldContainerView frame: %@", NSStringFromCGRect(self.textFieldContainerView.frame));
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    NSLog(@"In RTAlertViewController dealloc");
}


#pragma mark - Public Getters

- (BOOL)isAlertViewVisible
{
    return _alertViewVisible;
}


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

- (void)setAlertViewStyle:(UIAlertViewStyle)alertViewStyle
{
    _alertViewStyle = alertViewStyle;
    
    // Reinitialize internal data structures for text fields
    _textFieldArray = nil;
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


#pragma mark - Private Getters

- (NSMutableArray *)buttonTitleArray
{
    if (_buttonTitleArray == nil)
    {
        _buttonTitleArray = [[NSMutableArray alloc] init];
    }
    
    return _buttonTitleArray;
}


- (NSMutableArray *)textFieldArray
{
    if (_textFieldArray == nil)
    {
        switch (self.alertViewStyle)
        {
            case UIAlertViewStyleLoginAndPasswordInput:
            {
                _textFieldArray = [[NSMutableArray alloc] initWithCapacity:2];
                
                UITextField *loginTextField = [[UITextField alloc] init];
                loginTextField.secureTextEntry = NO;
                loginTextField.backgroundColor = [UIColor clearColor];
                loginTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                loginTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                loginTextField.returnKeyType = UIReturnKeyNext;
                loginTextField.borderStyle = UITextBorderStyleNone;
                loginTextField.font = [loginTextField.font fontWithSize:13.0f];
                loginTextField.placeholder = @"Login";
                [_textFieldArray addObject:loginTextField];
                
                UITextField *passwordTextField = [[UITextField alloc] init];
                passwordTextField.secureTextEntry = YES;
                passwordTextField.backgroundColor = [UIColor clearColor];
                passwordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                passwordTextField.returnKeyType = UIReturnKeyNext;
                passwordTextField.borderStyle = UITextBorderStyleNone;
                passwordTextField.font = [passwordTextField.font fontWithSize:13.0f];
                passwordTextField.placeholder = @"Password";
                [_textFieldArray addObject:passwordTextField];
            }
                break;
            case UIAlertViewStyleSecureTextInput:
            {
                _textFieldArray = [[NSMutableArray alloc] initWithCapacity:1];
                UITextField *secureTextField = [[UITextField alloc] init];
                secureTextField.secureTextEntry = YES;
                secureTextField.backgroundColor = [UIColor clearColor];
                secureTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                secureTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                secureTextField.returnKeyType = UIReturnKeyNext;
                secureTextField.borderStyle = UITextBorderStyleNone;
                secureTextField.font = [secureTextField.font fontWithSize:13.0f];
                [_textFieldArray addObject:secureTextField];
            }
                break;
            case UIAlertViewStylePlainTextInput:
            {
                _textFieldArray = [[NSMutableArray alloc] initWithCapacity:1];
                UITextField *plainTextField = [[UITextField alloc] init];
                plainTextField.secureTextEntry = NO;
                plainTextField.backgroundColor = [UIColor clearColor];
                plainTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                plainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                plainTextField.returnKeyType = UIReturnKeyNext;
                plainTextField.borderStyle = UITextBorderStyleNone;
                plainTextField.font = [plainTextField.font fontWithSize:13.0f];
                [_textFieldArray addObject:plainTextField];
            }
                break;
            case UIAlertViewStyleDefault:
            default:
            {
                _textFieldArray = nil;
            }
                break;
        }
    }
    
    return _textFieldArray;
}


#pragma mark - Public methods

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    if (title != nil)
    {
        // Lazy instantiation
        if (self.buttonTitleArray == nil)
        {
            self.buttonTitleArray = [[NSMutableArray alloc] init];
        }
        
        [self.buttonTitleArray addObject:title];
        
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
    if (self.alertViewStyle == UIAlertViewStyleDefault)
    {
        return nil;
    }
    
    if (textFieldIndex < 0)
    {
        return nil;
    }
    
    if ((self.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) &&
        (textFieldIndex > 1))
    {
        return nil;
    }
    
    if (((self.alertViewStyle == UIAlertViewStylePlainTextInput) ||
         (self.alertViewStyle == UIAlertViewStyleSecureTextInput)) &&
        (textFieldIndex > 0))
    {
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
//    if (buttonIndex < self.numberOfButtons)
//    {
//        self.clickedButtonIndex = buttonIndex;
//    }
    
    [self dismiss];
}


#pragma mark - RTAlertViewRecursiveButtonContainerViewDelegate methods

- (void)rtAlertViewRecursiveButtonContainerView:(RTAlertViewRecursiveButtonContainerView *)rtAlertViewRecursiveButtonContainerView
                             tappedButtonNumber:(NSInteger)buttonNumber
{
    NSLog(@"Button %d tapped", buttonNumber);
}


#pragma mark - Private methods

- (void)setupAlertView
{
	UIToolbar *toolbar = [[UIToolbar alloc] init];
	[self.gaussianBlurContainerView addSubview:toolbar];
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = NSDictionaryOfVariableBindings(toolbar);
    [self.gaussianBlurContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|"
                                                                                           options:0
                                                                                           metrics:0
                                                                                             views:views]];
    [self.gaussianBlurContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolbar]|"
                                                                                           options:0
                                                                                           metrics:0
                                                                                             views:views]];

    [self setupButtons];

	[self.alertContainerView.layer setMasksToBounds:YES];
	[self.alertContainerView.layer setCornerRadius:kRtAlertViewCornerRadius];
}


- (void)setupButtons
{
    RTAlertViewRecursiveButtonContainerView *recursiveButtonContainerView = [[RTAlertViewRecursiveButtonContainerView alloc] init];
    recursiveButtonContainerView.delegate = self;
    recursiveButtonContainerView.button2Enabled = YES;
//    recursiveButtonContainerView.button2Enabled = NO;
    [self.buttonContainerView addSubview:recursiveButtonContainerView];
    NSLog(@"recursiveButtonContainerView frame=%@", NSStringFromCGRect(recursiveButtonContainerView.frame));

    NSDictionary *views = NSDictionaryOfVariableBindings(recursiveButtonContainerView);

    [self.buttonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[recursiveButtonContainerView]|"
                                                                                     options:0
                                                                                     metrics:0
                                                                                       views:views]];
    [self.buttonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[recursiveButtonContainerView]|"
                                                                                     options:0
                                                                                     metrics:0
                                                                                       views:views]];
/*
    RTAlertViewRecursiveButtonContainerView *recursiveButtonContainerView2 = [[RTAlertViewRecursiveButtonContainerView alloc] init];
    recursiveButtonContainerView2.delegate = self;
//    recursiveButtonContainerView2.button2Enabled = YES;
    [recursiveButtonContainerView addRecursiveButtonContainerView:recursiveButtonContainerView2];
*/
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
	
	[self.window makeKeyAndVisible];
}


- (void)showAlertView
{
    [CATransaction begin]; {
		CATransform3D transformFrom = CATransform3DMakeScale(1.26, 1.26, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(1.0, 1.0, 1.0);
		
		RTSpringAnimation *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		self.alertContainerView.layer.transform = transformTo;
		
		// Zoom in the modal
		[self.alertContainerView.layer addAnimation:modalTransformAnimation
                                             forKey:@"transform"];
		
		RTSpringAnimation *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
		opacityAnimation.fromValue = @0.0f;
		opacityAnimation.toValue = @1.0f;
		self.blackTransparentContainerView.layer.opacity = 1.0f;
		self.gaussianBlurContainerView.layer.opacity = 1.0f;
		self.view.layer.opacity = 1.0f;
		self.contentView.layer.opacity = 1.0f;
		
		// Fade in
		[self.blackTransparentContainerView.layer addAnimation:opacityAnimation
                                              forKey:@"opacity"];

		// Fade in the modal
		// Would love to fade in all these things at once, but UIToolbar doesn't like it
		[self.gaussianBlurContainerView.layer addAnimation:opacityAnimation
                                                    forKey:@"opacity"];
//		[self.view.layer addAnimation:opacityAnimation
//                                              forKey:@"opacity"];
		[self.contentView.layer addAnimation:opacityAnimation
                                      forKey:@"opacity"];
	} [CATransaction commit];
}


- (void)dismiss
{
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
		
		RTSpringAnimation *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		modalTransformAnimation.delegate = self;
		self.alertContainerView.layer.transform = transformTo;
		
		// Zoom out the modal
		[self.alertContainerView.layer addAnimation:modalTransformAnimation
                                             forKey:@"transform"];
		
		RTSpringAnimation *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
		opacityAnimation.fromValue = @1.0f;
		opacityAnimation.toValue = @0.0f;
		self.blackTransparentContainerView.layer.opacity = 0.0;
		self.gaussianBlurContainerView.layer.opacity = 0.0;
		self.view.layer.opacity = 0.0;
		self.contentView.layer.opacity = 0.0;
		
		// Fade out the gray background
		[self.blackTransparentContainerView.layer addAnimation:opacityAnimation
                                                    forKey:@"opacity"];

		// Fade out the modal
		// Would love to fade out all these things at once, but UIToolbar doesn't like it
		[self.gaussianBlurContainerView.layer addAnimation:opacityAnimation
                                                    forKey:@"opacity"];
/*
		[self.view.layer addAnimation:opacityAnimation
                               forKey:@"opacity"];
*/
		[self.contentView.layer addAnimation:opacityAnimation
                                      forKey:@"opacity"];
	} [CATransaction commit];
}


- (id)springAnimationForKeyPath:(NSString *)keyPath
{
	RTSpringAnimation *animation = [[RTSpringAnimation alloc] init];

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
	// Temporary bugfix
//	[self removeFromSuperview];
    
//    self.visible = NO;
    
	// Release window from memory
	self.window.hidden = YES;
	self.window = nil;

    // Release RTAlertView, important or retain cycle or not broken
    self.alertView = nil;
}


@end
