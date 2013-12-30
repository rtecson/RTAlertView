RTAlertView
===========

*UIAlertView replacement for iOS 7*

- [Description](#Description)
- [Installation & Use](#Installation)
- [Usage](#Usage)
- [Credits](#Credits)


<a name="Description"></a>Description
-----------

RTAlertView is a customizable alert view that looks identical to the iOS 7 system alert view. It implements the same interface as UIAlertView, but it also allows you to customize the fonts and colours used in the alert view.

![RTAlertView](https://github.com/rtecson/RTAlertView/raw/master/Screenshots/00-One-Button.png)

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


<a name="Installation"></a>Installation & Use
------------------

1.  Drag the folder RTAlertView/RTAlertView to your project in Xcode.
2.  Add the line `#import "RTAlertView.h"` to your class


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

- Thanks to Lee McDermott, author of LMAlertView (https://github.com/lmcd/LMAlertView). The code for making the alert view look as closely as possible to the iOS 7 system alert view, as well as the code for the spring animation when the alert view appears, is heavily borrowed from LMAlertView.
- Thanks to Jeremy Wiebe for the design pattern of adding UIButtons recursively within an auto layout enabled container.
