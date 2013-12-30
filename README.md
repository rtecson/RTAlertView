RTAlertView
===========

*UIAlertView replacement for iOS 7*

- Description
- Installation & Use
- Credits


Description
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

The highlight colour of a button is automatically derived from button's colour.

![RTAlertView one button highlighted](https://github.com/rtecson/RTAlertView/raw/master/Screenshots/01-One-Button-Highlighted.png)

Similarly to UIAlertView, if two buttons are defined, they are laid out side by side.

![RTAlertView two buttons](https://github.com/rtecson/RTAlertView/raw/master/Screenshots/02-Two-Buttons.png)

If three or more buttons are defined, they are laid out vertically.

![RTAlertView four buttons](https://github.com/rtecson/RTAlertView/raw/master/Screenshots/03-Four-Buttons.png)


Installation & Use
------------------

1.  Drag the folder RTAlertView/RTAlertView to your project.
2.  Add the line `#import "RTAlertView.h"` to your class


Credits
-------
