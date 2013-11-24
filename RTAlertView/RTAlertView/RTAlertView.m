//
//  RTAlertView.m
//  Woodshed
//
//  Created by Roland Tecson on 11/22/2013.
//  Copyright (c) 2013 MoozX Internet Ventures. All rights reserved.
//


#import "RTAlertView.h"


static CGFloat kRtAlertViewSideMargin = 15.0f;
static CGFloat kRtAlertViewTopAndBottomMargin = 19.0f;
static CGFloat kRtAlertViewWidth = 270.0f;
static CGFloat kRtAlertViewButtonHeight = 44.0f;

#define kRtAlertViewTitleColor [UIColor blackColor]
#define kRtAlertViewTitleFont  [UIFont boldSystemFontOfSize:17.0f]
#define kRtAlertViewMessageColor [UIColor blackColor]
#define kRtAlertViewMessageFont  [UIFont systemFontOfSize:14.0f]
#define kRtAlertViewCancelButtonColor [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kRtAlertViewCancelButtonFont  [UIFont boldSystemFontOfSize:17.0f]
#define kRtAlertViewOtherButtonColor [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kRtAlertViewOtherButtonFont  [UIFont systemFontOfSize:17.0f]

static CGFloat kRtAlertViewCornerRadius = 7.0f;

#define kRtAlertViewDividerLineColor      [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5f]
#define kRtAlertViewDefaultiOS7BlueColor  [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
#define kRtAlertViewButtonBackgroundColor [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:0.6]
#define kRtAlertViewBackgroundViewColor   [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4]


#define kSpringAnimationClassName CASpringAnimation

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


@interface RTAlertView ()

@property (nonatomic, readwrite, getter=isVisible) BOOL visible;
@property (nonatomic, readwrite) NSInteger numberOfButtons;
@property (nonatomic, readwrite) NSInteger firstOtherButtonIndex;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *fullScreenContainerView;
@property (strong, nonatomic) UIView *backgroundTransparentView;
@property (strong, nonatomic) UIView *alertContainerView;
@property (strong, nonatomic) UIView *guassianBlurView;
@property (strong, nonatomic) UIView *alertBackgroundView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIView *dividerLineView;

@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) NSString *cancelButtonTitle;

@property (strong, nonatomic) NSMutableArray *buttonTitleArray;

@end


@implementation RTAlertView


- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super init];
    if (self != nil)
    {
        self.titleColor = kRtAlertViewTitleColor;
        self.titleFont = kRtAlertViewTitleFont;
        self.messageColor = kRtAlertViewMessageColor;
        self.messageFont = kRtAlertViewMessageFont;
        self.cancelButtonColor = kRtAlertViewCancelButtonColor;
        self.cancelButtonFont = kRtAlertViewCancelButtonFont;
        self.otherButtonColor = kRtAlertViewOtherButtonColor;
        self.otherButtonFont = kRtAlertViewOtherButtonFont;

        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.visible = NO;
        self.numberOfButtons = 0;
        self.cancelButtonIndex = -1;
        self.firstOtherButtonIndex = -1;
        
        // Create cancel button if specified
        if (cancelButtonTitle != nil)
        {
            self.cancelButtonTitle = cancelButtonTitle;
            self.cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle];
            self.numberOfButtons++;
        }

        // Variable number of otherButtonTitles
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
        {
            [self addButtonWithTitle:arg];
            self.numberOfButtons++;
        }
        va_end(args);
    }

    return self;
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


- (NSInteger)firstOtherButtonIndex
{
    if ((self.cancelButtonIndex == 0) &&
        (self.numberOfButtons > 1))
    {
        // Cancel button is first button, two more more buttons
        return 1;
    }
    else if ((self.cancelButtonIndex == -1) &&
             (self.numberOfButtons > 0))
    {
        // No cancel button, one or more buttons
        return 0;
    }
    else if (self.cancelButtonIndex > 0)
    {
        // Cancel button is not first button
        return 0;
    }
    else
    {
        return -1;
    }
}


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
        
        return self.numberOfButtons++;
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
    return nil;
}


- (void)show
{
    [self setupPositions];
	[self setupWindow];

    [CATransaction begin]; {
		CATransform3D transformFrom = CATransform3DMakeScale(1.26, 1.26, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(1.0, 1.0, 1.0);
		
		kSpringAnimationClassName *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		self.alertContainerView.layer.transform = transformTo;
		
		// Zoom in the modal
		[self.alertContainerView.layer addAnimation:modalTransformAnimation
                                             forKey:@"transform"];
		
		kSpringAnimationClassName *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
		opacityAnimation.fromValue = @0.0f;
		opacityAnimation.toValue = @1.0f;
		self.alertBackgroundView.layer.opacity = 1.0f;
		self.guassianBlurView.layer.opacity = 1.0f;
		self.alertBackgroundView.layer.opacity = 1.0f;
		self.contentView.layer.opacity = 1.0f;
		
		// Fade in the gray background
		[self.alertBackgroundView.layer addAnimation:opacityAnimation
                                              forKey:@"opacity"];
        
		// Fade in the modal
		// Would love to fade in all these things at once, but UIToolbar doesn't like it
		[self.guassianBlurView.layer addAnimation:opacityAnimation
                                           forKey:@"opacity"];
		[self.alertBackgroundView.layer addAnimation:opacityAnimation
                                              forKey:@"opacity"];
		[self.contentView.layer addAnimation:opacityAnimation
                                      forKey:@"opacity"];
	} [CATransaction commit];

    self.visible = YES;
}


- (void)setupPositions
{
    CGFloat labelWidth = kRtAlertViewWidth - (kRtAlertViewSideMargin * 2.0f);
    
    CGFloat yOffset = kRtAlertViewTopAndBottomMargin;
    
    if (self.title != nil)
    {
//        NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
        
        NSDictionary *attributes = @{
//                                     NSParagraphStyleAttributeName:paragrahStyle,
                                     NSForegroundColorAttributeName:self.titleColor,
                                     NSFontAttributeName:self.titleFont
                                     };
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.title
                                                                         attributes:attributes];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGSize sizeThatFits = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
        self.titleLabel.frame = CGRectMake(kRtAlertViewSideMargin,
                                           yOffset,
                                           labelWidth,
                                           sizeThatFits.height);
        
        yOffset += self.titleLabel.frame.size.height;
    }
    
    // 4 px gap between title and message, even if a title doesn't exist
    yOffset += 4.0f;
    
    if (self.message != nil)
    {
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.numberOfLines = 0;
        
//        NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
        
        NSDictionary *attributes = @{
//                                     NSParagraphStyleAttributeName:paragrahStyle,
                                     NSForegroundColorAttributeName:self.messageColor,
                                     NSFontAttributeName:self.messageFont
                                     };
        
        self.messageLabel.attributedText = [[NSAttributedString alloc] initWithString:self.message
                                                                           attributes:attributes];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        
        CGSize sizeThatFits = [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
        self.messageLabel.frame = CGRectMake(kRtAlertViewSideMargin,
                                             yOffset,
                                             labelWidth,
                                             sizeThatFits.height);
        
        yOffset += self.messageLabel.frame.size.height;
    }
    
    yOffset += kRtAlertViewTopAndBottomMargin;
    
    if (self.cancelButtonTitle != nil)
    {
        self.dividerLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                        yOffset - 1.0f,
                                                                        kRtAlertViewWidth,
                                                                        1.0f)];
        self.dividerLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        // We put our 0.5px high view in to a container that's 1px high
        // This is because autoresizing was rounding up to 1 and messing things up
        // autolayout might fix this
        UIView *dividerLineViewInner = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                0.5f,
                                                                                kRtAlertViewWidth,
                                                                                0.5f)];
        dividerLineViewInner.backgroundColor = kRtAlertViewDividerLineColor;
        dividerLineViewInner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self.dividerLineView addSubview:dividerLineViewInner];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setTitle:self.cancelButtonTitle
                           forState:UIControlStateNormal];
        self.cancelButton.titleEdgeInsets = UIEdgeInsetsMake(1.0f,
                                                             0.0f,
                                                             0.0f,
                                                             0.0f);
        [self.cancelButton setTitleColor:self.cancelButtonColor
                                forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[self imageFromColor:kRtAlertViewButtonBackgroundColor]
                                     forState:UIControlStateHighlighted];
        self.cancelButton.titleLabel.font = self.cancelButtonFont;
        [self.cancelButton addTarget:self
                              action:@selector(buttonTapped:)
                    forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton.frame = CGRectMake(0.0f,
                                             yOffset,
                                             kRtAlertViewWidth,
                                             kRtAlertViewButtonHeight);
        self.cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        yOffset += kRtAlertViewButtonHeight;
    }
    
    CGFloat alertHeight = yOffset;
    [self setupWithSize:CGSizeMake(kRtAlertViewWidth,
                                   alertHeight)];
    
    // Add everything to the content view
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.dividerLineView];
    [self.contentView addSubview:self.cancelButton];
}


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


- (void)setupWithSize:(CGSize)size
{
	// Main container that fits the whole screen
	self.fullScreenContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                            0.0f,
                                                                            [[UIScreen mainScreen] bounds].size.width,
                                                                            [[UIScreen mainScreen] bounds].size.height)];
	self.fullScreenContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.fullScreenContainerView.backgroundColor = [UIColor clearColor];
	
	self.backgroundTransparentView = [[UIView alloc] initWithFrame:self.fullScreenContainerView.frame];
	self.backgroundTransparentView.backgroundColor = kRtAlertViewBackgroundViewColor;
	self.backgroundTransparentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.fullScreenContainerView addSubview:self.backgroundTransparentView];
    
	CGRect maskRect = CGRectMake(0.0f,
                                 0.0f,
                                 size.width,
                                 size.height);
	
	CGPoint origin = CGPointMake([self.backgroundTransparentView bounds].size.width/2.0 - maskRect.size.width/2.0,
                                 [self.backgroundTransparentView bounds].size.height/2.0 - maskRect.size.height/2.0);
	self.alertContainerView = [[UIView alloc] initWithFrame:CGRectMake(origin.x,
                                                                       origin.y,
                                                                       maskRect.size.width,
                                                                       maskRect.size.height)];
	self.alertContainerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
	[self.alertContainerView.layer setMasksToBounds:YES];
    self.alertContainerView.backgroundColor = [UIColor clearColor];
	[self.alertContainerView.layer setCornerRadius:kRtAlertViewCornerRadius];
    
	self.guassianBlurView = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                        0.0f,
                                                                        self.alertContainerView.frame.size.width,
                                                                        self.alertContainerView.frame.size.height)];
	self.guassianBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self.alertContainerView addSubview:self.guassianBlurView];
	
	self.alertBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                        0.0f,
                                                                        self.alertContainerView.frame.size.width,
                                                                        self.alertContainerView.frame.size.height)];
	self.alertBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radial.png"]];
	imageView.frame = self.guassianBlurView.frame;
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.alertBackgroundView addSubview:imageView];
    self.alertBackgroundView.alpha = 0.2f;
    
    [self.alertContainerView addSubview:self.alertBackgroundView];
    
	self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                0.0f,
                                                                self.alertContainerView.frame.size.width,
                                                                self.alertContainerView.frame.size.height)];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentView.backgroundColor = [UIColor clearColor];
	[self.alertContainerView addSubview:self.contentView];
	
	[self.alertContainerView addSubview:self];
	
	[self.fullScreenContainerView addSubview:self.alertContainerView];
}


- (void)setupWindow
{
	id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
	
	self.window = [[UIWindow alloc] initWithFrame:[appDelegate window].frame];
	
	UIViewController *viewController = [[UIViewController alloc] init];
	viewController.view = self.fullScreenContainerView;
	
	self.window.rootViewController = viewController;
	// Without this, the alert background will appear black on rotation
	self.window.backgroundColor = [UIColor clearColor];
	self.window.windowLevel = UIWindowLevelAlert;
	self.window.hidden = NO;
	
	[self.window makeKeyAndVisible];
}


- (id)springAnimationForKeyPath:(NSString *)keyPath
{
	kSpringAnimationClassName *animation = [[kSpringAnimationClassName alloc] init];
	
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


- (void)buttonTapped:(id)sender
{
    NSLog(@"Button tapped");
    [self dismiss];
}


- (void)dismiss
{
	[CATransaction begin]; {
		CATransform3D transformFrom = CATransform3DMakeScale(1.0, 1.0, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(0.840, 0.840, 1.0);
		
		kSpringAnimationClassName *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		modalTransformAnimation.delegate = self;
		self.alertContainerView.layer.transform = transformTo;
		
		// Zoom out the modal
		[self.alertContainerView.layer addAnimation:modalTransformAnimation forKey:@"transform"];
		
		kSpringAnimationClassName *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
		opacityAnimation.fromValue = @1.0f;
		opacityAnimation.toValue = @0.0f;
		self.backgroundTransparentView.layer.opacity = 0.0;
		self.guassianBlurView.layer.opacity = 0.0;
		self.fullScreenContainerView.layer.opacity = 0.0;
		self.contentView.layer.opacity = 0.0;
		
		// Fade out the gray background
		[self.backgroundTransparentView.layer addAnimation:opacityAnimation forKey:@"opacity"];
		
		// Fade out the modal
		// Would love to fade out all these things at once, but UIToolbar doesn't like it
		[self.guassianBlurView.layer addAnimation:opacityAnimation forKey:@"opacity"];
		[self.fullScreenContainerView.layer addAnimation:opacityAnimation forKey:@"opacity"];
		[self.contentView.layer addAnimation:opacityAnimation forKey:@"opacity"];
	} [CATransaction commit];
}


- (void)animationDidStop:(CAAnimation *)theAnimation
                finished:(BOOL)flag
{
	// Temporary bugfix
	[self removeFromSuperview];

    self.visible = NO;

	// Release window from memory
	self.window.hidden = YES;
	self.window = nil;
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex
                             animated:(BOOL)animated
{
    
}


#pragma mark - UIAppearance setters

- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor != titleColor)
    {
        _titleColor = titleColor;
    }
    
    return;
}


- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont != titleFont)
    {
        _titleFont = titleFont;
    }

    return;
}


- (void)setMessageColor:(UIColor *)messageColor
{
    if (_messageColor != messageColor)
    {
        _messageColor = messageColor;
    }
    
    return;
}


- (void)setMessageFont:(UIFont *)messageFont
{
    if (_messageFont != messageFont)
    {
        _messageFont = messageFont;
    }
    
    return;
}


- (void)setCancelButtonColor:(UIColor *)cancelButtonColor
{
    if (_cancelButtonColor != cancelButtonColor)
    {
        _cancelButtonColor = cancelButtonColor;
    }
    
    return;
}


- (void)setCancelButtonFont:(UIFont *)cancelButtonFont
{
    if (_cancelButtonFont != cancelButtonFont)
    {
        _cancelButtonFont = cancelButtonFont;
    }
    
    return;
}


- (void)setOtherButtonColor:(UIColor *)otherButtonColor
{
    if (_otherButtonColor != otherButtonColor)
    {
        _otherButtonColor = otherButtonColor;
    }
    
    return;
}


- (void)setOtherButtonFont:(UIFont *)otherButtonFont
{
    if (_otherButtonFont != otherButtonFont)
    {
        _otherButtonFont = otherButtonFont;
    }
    
    return;
}


@end
