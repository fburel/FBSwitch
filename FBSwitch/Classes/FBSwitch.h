/*
 Copyright (c) 2010 Florian Burel
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

// The default, recommanded size for a switch. Equals to Apple's UISwitch
#define FBSWITCH_DEFAULT_SIZE               CGSizeMake(51.f, 31.f)

// key for the labelProperty dictionary
extern NSString const* FBSwithOnLabelTextColor;         // UIColor
extern NSString const* FBSwithOnLabelFont;              // UIFont
extern NSString const* FBSwithOnLabelShadowColor;       // UIColor
extern NSString const* FBSwithOnLabelShadowOffset;      // CGSize as NSValue
extern NSString const* FBSwithOffLabelTextColor;         // UIColor
extern NSString const* FBSwithOffLabelFont;              // UIFont
extern NSString const* FBSwithOffLabelShadowColor;       // UIColor
extern NSString const* FBSwithOffLabelShadowOffset;      // CGSize as NSValue (simply use [NSValue valueWithBytes:&shadowOffset objCType:@encode(CGSize)];)
IB_DESIGNABLE
@interface FBSwitch : UIControl <UIAppearanceContainer>

/// By default, if instanciated with [[FBSwitch alloc]init] the control will have a size of FBSWITCH_DEFAULT_SIZE. You can override this behaviour by setting this value. All your FBSwitch instanciated using [[FBSwitch alloc]init] will then have this size.
+ (void) setPreferedSize:(CGSize)size;



@property (strong, nonatomic) UIImage * thumbImage UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) NSUInteger thumbMargin UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIImage * onImage UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIImage * offImage UI_APPEARANCE_SELECTOR;
@property (copy, nonatomic)  NSString * onText UI_APPEARANCE_SELECTOR;
@property (copy, nonatomic)  NSString * offText UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSDictionary * labelProperties UI_APPEARANCE_SELECTOR;

/// The state of the switch. When set, does not trigger the UIControlEventValueChanged.
@property(readwrite,assign,getter=isOn) IBInspectable BOOL on;

#pragma mark - Helper method for easily creating default thumb and on/off image before the design stage

/// Create a basic UISwitch like shape that can be used for on or off image. Background will be set to the receive color
+(UIImage*)createBackgroundImageWithColor:(UIColor*)color;

/// Create a basic UISwitch like thumb that can be used as thumbImage. Thumb background color will be set to the receive color
+ (UIImage *)createThumbImageWithColor:(UIColor *)color;

    
@end

// If you are using XLForm, define the USES_XLFORM smbol in your project settings, this will unlock this usefull trick.
// To add this symbol, go to your project build setting, look for the setting named GCC_PREPROCESSOR_DEFINITIONS and add your symbol definition USES_XLFORM=1 for both debug and relese builds (http://stackoverflow.com/questions/367368/how-to-define-a-preprocessor-symbol-in-xcode)
#if USES_XLFORM

@interface FBSwitch (XLForms)

/// If you are using XLForms in your project, calling this method will replace all your XLFormRowDescriptorTypeBooleanSwitch by a look alike cell that uses FBSwitch instead of Apple UISwitch. You won't have to change anything anywhere in your forms view controller. Cheers!
+ (void) registerXLFormCell;

@end

#endif

