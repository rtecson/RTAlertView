RTAlertView
===========

*UIAlertView replacement for iOS 7 and iOS 6*

- [Highlights](#Highlights)
- [Description](#Description)
- [Installation & Use](#Installation)
- [Usage](#Usage)
- [Credits](#Credits)
- [License](#License)


<a name="Highlights"></a>Highlights
-----------

- Customizable alert view that looks identical to the iOS 7 system alert view
- Supports both iOS 6 and iOS 7
- Same API as UIAlertView
- Translucent gaussian blur background in iOS 7 (translucent white background in iOS 6)
- Dismiss alert view when app goes to background (configurable)
- Dims tintColor of other visible controls when alert view is displayed
- Parallax effect similar to UIAlertView


<a name="Description"></a>Description
-----------

RTAlertView is a customizable alert view that looks identical to the iOS 7 system alert view. It implements the same interface as UIAlertView, but it also allows you to customize the fonts and colours used in the alert view.

![RTAlertView](https://github.com/rtecson/RTAlertView/raw/master/Screenshots/00-One-Button.png)

The alert uses auto layout to position itself in the center of the screen, and will automatically adjust its position when the device orientation changes, or when the keyboard is displayed.

The following properties, in addition to those defined for UIAlertView, are defined in RTAlertView:

    @property (strong, nonatomic) UIColor *titleColor;
    @property (strong, nonatomic) UIFont *titleFont;
    @property (strong, nonatomic) UIColor *messageColor;
    @property (strong, nonatomic) UIFont *messageFont;
    @property (strong, nonatomic) UIColor *cancelButtonColor;
    @property (strong, nonatomic) UIFont *cancelButtonFont;
    @property (strong, nonatomic) UIColor *otherButtonColor;
    @property (strong, nonatomic) UIFont *otherButtonFont;
    @property (strong, nonatomic) UIFont *textFieldPlaceholderFont;

If no values are specified for these properties, the default colours and fonts used will be the same as the ones in UIAlertView.

The highlight colour of a button is automatically derived from the button's colour.

![RTAlertView one button highlighted](https://github.com/rtecson/RTAlertView/raw/master/Screenshots/01-One-Button-Highlighted.png)

Similarly to UIAlertView, if two buttons are defined, they are laid out side by side.

![RTAlertView two buttons](https://github.com/rtecson/RTAlertView/raw/master/Screenshots/02-Two-Buttons.png)

If three or more buttons are defined, they are laid out vertically.

![RTAlertView four buttons](https://github.com/rtecson/RTAlertView/raw/master/Screenshots/03-Four-Buttons.png)

Similarly to UIAlertView, if `alertViewStyle` were set to either `UIAlertViewStyleSecureTextInput` or `UIAlertViewStylePlainTextInput`, a single text field will be displayed.

![RTAlertView single text field](https://github.com/rtecson/RTAlertView/raw/master/Screenshots/04-One-Text-Field.png)

If `alertViewStyle` were set to `UIAlertViewStyleLoginAndPasswordInput`, two text fields will be displayed.

![RTAlertView double text fields](https://github.com/rtecson/RTAlertView/raw/master/Screenshots/05-Two-Text-Fields.png)

By default, RTAlertView will automatically dismiss itself when the app goes to the background. This is as per Apple's recommendation so that the user will not be presented with an alert message that may be out of context when the app is resumed. You may override this behaviour by setting the property `dismissesWhenAppGoesToBackground` to `NO` (default value is `YES`).

RTAlertView dims the tintColor of the all the visible controls in your app (at least those that support it), similar to the iOS 7 UIAlertView. RTAlertView also implements the parallax effect present in the iOS 7 UIAlertView.


<a name="Installation"></a>Installation & Use
------------------

For use in your app, install with Cocoapods

1.  Create or edit your `Podfile` and add the following line `pod 'RTAlertView', '0.0.4'`
2.  Perform a `pod install`
3.  Add the line `#import <RTAlertView.h>` to your class
4.  Remember to open the `<App>.xcworkspace` file (not `<App>.xcodeproj`) in Xcode from here onwards

To run the test application

1.  Clone the git repository, `git clone https://github.com/rtecson/RTAlertView.git`
2.  `cd RTAlertView`
3.  Run pod install, `pod install` (if cocoapods is not installed, see http://http://beta.cocoapods.org)
4.  Run Xcode 5 (or higher) and open `RTAlertView.xcworkspace`


<a name="Usage"></a>Usage
-------

```objective-c
    // Alloc and init RTAlertView, button titles may also be set here
    RTAlertView *customAlertView = [[RTAlertView alloc] initWithTitle:@"Test"
                                                              message:@"Message here"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];

    // Conforms to the RTAlertViewDelegate protocol
    customAlertView.delegate = self;

    // Default is UIAlertViewStyleDefault
    customAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    // Add other buttons
    for (int i=0; i<kNumberOfOtherButtons; i++)
    {
        [customAlertView addButtonWithTitle:[NSString stringWithFormat:@"Button %d", i]];
    }
    
    // Add cancel button
    customAlertView.cancelButtonIndex = [customAlertView addButtonWithTitle:@"Done"];

    // Set button colours
    customAlertView.otherButtonColor = kCustomColor;
    customAlertView.cancelButtonColor = kCustomColor;

    // Display alert view
    [customAlertView show];
```


<a name="Credits"></a>Credits
-------

- Thanks to Lee McDermott, author of LMAlertView (https://github.com/lmcd/LMAlertView). The code for making the alert view look as closely as possible to the iOS 7 system alert view is heavily borrowed from LMAlertView.
- Thanks to Robert Böhnke, author of RBBAnimation (https://github.com/robb/RBBAnimation). The spring animation effect is performed using RBBAnimation.
- Thanks to Jeremy Wiebe (https://github.com/jeremywiebe) for the design pattern of adding UIButtons recursively within an auto layout enabled container.


<a name="License"></a>License
-------

RTAlertView is written by Roland Tecson. It is licensed under the MIT License.

If you use RTAlertView in one of your apps, please send me a quick note. I'd love to hear about it.
