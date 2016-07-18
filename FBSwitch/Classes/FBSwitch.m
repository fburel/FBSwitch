/*
 Copyright (c) 2010 Robert Chin
 
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

#import "FBSwitch.h"
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"

// Default value. based on this post : https://www.raywenderlich.com/23424/photoshop-for-developers-creating-a-custom-uiswitch
#define FBSWITCH_DEFAULT_THUMB_SIZE         CGSizeMake(28.f, 28.f)

#define RGBColor(R,G,B)                     [UIColor colorWithRed:(R) / 255.f green:(G) /255.f blue:(B) / 255.f alpha:1.0f]

NSString const* FBSwithOnLabelTextColor = @"FBSwithOnLabelTextColor";
NSString const* FBSwithOnLabelFont = @"FBSwithOnLabelFont";
NSString const* FBSwithOnLabelShadowColor = @"FBSwithOnLabelShadowColor";
NSString const* FBSwithOnLabelShadowOffset = @"FBSwithOnLabelShadowOffset";
NSString const* FBSwithOffLabelTextColor = @"FBSwithOffLabelTextColor";
NSString const* FBSwithOffLabelFont = @"FBSwithOffLabelFont";
NSString const* FBSwithOffLabelShadowColor = @"FBSwithOffLabelShadowColor";
NSString const* FBSwithOffLabelShadowOffset = @"FBSwithOffLabelShadowOffset";

@interface FBSwitch ()
{
    BOOL _isDicreteTouch;
}

@property (assign, nonatomic) CGFloat percent;
@property (strong, nonatomic) UILabel * offLabel;
@property (strong, nonatomic) UILabel * onLabel;


@end

@implementation FBSwitch

static CGSize PreferedSize = {0.f, 0.f};

+ (void) setPreferedSize:(CGSize)size
{
    PreferedSize = size;
}

- (instancetype)init
{
    CGSize size = CGSizeEqualToSize(PreferedSize, CGSizeZero) ? FBSWITCH_DEFAULT_SIZE : PreferedSize;
    return [self initWithFrame:CGRectMake(0, 0, size.width, size.height)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    _isDicreteTouch = YES;
    _percent = 0.f;
    
    // View config
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.opaque = NO;

    // default value
    _thumbImage = [FBSwitch createThumbImageWithColor:[UIColor whiteColor]];
    _thumbMargin = 1;
    _onImage = [FBSwitch createBackgroundImageWithColor:RGBColor(102, 199, 82)];
    _offImage = [FBSwitch createBackgroundImageWithColor:[UIColor lightGrayColor]];
    
    
    // setup the label
    self.onLabel = [UILabel new];
    self.offLabel = [UILabel new];
}

- (void)setLabelProperties:(NSDictionary *)labelProperties
{
    _labelProperties = labelProperties;
    
    CGSize shadowOffset;
    NSValue * offSetAsValue;
    
    self.onLabel.textColor = labelProperties[FBSwithOnLabelTextColor];
    self.onLabel.font = labelProperties[FBSwithOnLabelFont];
    self.onLabel.shadowColor = labelProperties[FBSwithOnLabelShadowColor];
    offSetAsValue = labelProperties[FBSwithOnLabelShadowOffset];
    if(offSetAsValue != nil)
    {
        [offSetAsValue getValue:&shadowOffset];
        self.onLabel.shadowOffset = shadowOffset;

    }
    
    self.offLabel.textColor = labelProperties[FBSwithOffLabelTextColor];
    self.offLabel.font = labelProperties[FBSwithOffLabelFont];
    self.offLabel.shadowColor = labelProperties[FBSwithOffLabelShadowColor];
    offSetAsValue = labelProperties[FBSwithOffLabelShadowOffset];
    if(offSetAsValue != nil)
    {
        [offSetAsValue getValue:&shadowOffset];
        self.offLabel.shadowOffset = shadowOffset;
        
    }

}

- (void)drawRect:(CGRect)rect
{
	CGRect boundsRect = self.bounds;
    
    if(_percent < .5f)
    {
        [self.offImage drawInRect:rect];
    }
    else
    {
        [self.onImage drawInRect:rect];
    }
	
    CGFloat knobOffset = ((boundsRect.size.width - self.thumbImage.size.width) - (2 * _thumbMargin)) * _percent;
    CGPoint knobOrigin = CGPointMake(
                                     _thumbMargin + knobOffset,
                                     (boundsRect.size.height - self.thumbImage.size.height) / 2.f
                                     );
    
    [self drawLabel];

    [self.thumbImage drawInRect:CGRectMake(knobOrigin.x, knobOrigin.y, self.thumbImage.size.width, self.thumbImage.size.height)];
   
}

- (void)drawLabel
{
    if(self.percent > .5f && self.onText != nil)
    {
        // Draw the on label in the middle
        CGRect textRect = [self bounds];
        textRect.size.width = self.bounds.size.width - 8 - _thumbMargin - self.thumbImage.size.width;
        textRect.origin.x = _thumbMargin + 8;
        self.onLabel.text = self.onText;
        CGFloat alpha = 2 * self.percent - 1;
        self.onLabel.textColor = [self.onLabel.textColor colorWithAlphaComponent:alpha] ;
        [self.onLabel drawTextInRect:textRect];
    }
    else if(self.percent < .5f && self.offText != nil)
    {
        CGRect textRect = [self bounds];
        textRect.size.width = self.bounds.size.width - 8 - _thumbMargin - self.thumbImage.size.width;
        textRect.origin.x = _thumbMargin + self.thumbImage.size.width;
        CGFloat alpha = -2.f * self.percent + 1;
        self.offLabel.textColor = [self.offLabel.textColor colorWithAlphaComponent:alpha] ;
        self.offLabel.text = self.offText;
        [self.offLabel drawTextInRect:textRect];
        
    }
}

#pragma mark - user interaction tracking


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _isDicreteTouch = YES;

    self.highlighted = YES;
	[self setNeedsDisplay];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // If we have time to do this, then the gesture is not discrete
    _isDicreteTouch = NO;
    
	CGPoint point = [touch locationInView:self];
	_percent = (point.x - self.thumbImage.size.width / 2.0) / (self.bounds.size.width - self.thumbImage.size.width);
	if(_percent < 0.0)
		_percent = 0.0;
	if(_percent > 1.0)
		_percent = 1.0;
    
	[self setNeedsDisplay];
    
	return YES;
}


- (void)cancelTrackingWithEvent:(UIEvent *)event
{

    if(_percent < .5f)
        _percent = 0.0;
    else
        _percent = 1.0;
    
    [self setNeedsDisplay];
    
	[self finishEvent];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(_isDicreteTouch) // In case of a discete (tap) touch, we switch the state
    {
        _percent = self.isOn ? 0 : 1;
    }
    else // else we just ensure the thumb go all the way
    {
        if(_percent < .5f)
            _percent = 0.0;
        else
            _percent = 1.0;
    }
    
    
    _isDicreteTouch = YES;
    
    [self setNeedsDisplay];
    
	[self finishEvent];
}

- (void)finishEvent
{
    self.highlighted = NO;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - state transition & tracking

- (BOOL)isOn
{
	return _percent > 0.5;
}

- (void)setOn:(BOOL)aBool
{
    _percent = aBool ? 1 : 0;
    [self setNeedsDisplay];
}


#pragma mark - Image helper

+ (UIImage*)createBackgroundImageWithColor:(UIColor*)color
{
    UIImage * solidImage = [self createSolidColorImageWithColor:color
                                                        andSize:FBSWITCH_DEFAULT_SIZE
                                                   cornerRadius:FBSWITCH_DEFAULT_SIZE.height / 2.f];
    return solidImage;
}

+ (UIImage *)createThumbImageWithColor:(UIColor *)color
{
    UIImage * solidImage = [self createSolidColorImageWithColor:color
                                                        andSize:FBSWITCH_DEFAULT_THUMB_SIZE
                                                   cornerRadius:(FBSWITCH_DEFAULT_THUMB_SIZE.height  / 2.f)];
    return solidImage;
}

+(UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size cornerRadius:(CGFloat)radius
{
    CGFloat lineWidth = 1.f; // line of 1px
    
    // Define a rectangle of the given size
    CGRect rect = CGRectInset(CGRectMake(0, 0, size.width, size.height), lineWidth, lineWidth);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // set the background color to clearColor
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // inset the rect because half of the stroke applied to this path will be on the outside
    CGRect insetRect = CGRectInset(rect, lineWidth/2.0f, lineWidth/2.0f);
    
    // get our rounded rect as a path
    CGMutablePathRef path = createRoundedCornerPath(insetRect, radius);
    
    // add the path to the context
    CGContextAddPath(context, path);
    
    // Set the render colors.
    [color setFill];
    
    // draw the path
    CGContextDrawPath(context, kCGPathFill);
    
    // release the path
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //clean up
    UIGraphicsEndImageContext();
    CGPathRelease(path);
    
    return image;
}

// Coutesy of Erik Villegas in stackoverflow http://stackoverflow.com/questions/2835448/how-to-draw-a-rounded-rectangle-in-core-graphics-quartz-2d
static CGMutablePathRef createRoundedCornerPath(CGRect rect, CGFloat cornerRadius)
{
    
    // create a mutable path
    CGMutablePathRef path = CGPathCreateMutable();
    
    // get the 4 corners of the rect
    CGPoint topLeft = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint topRight = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    CGPoint bottomRight = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGPoint bottomLeft = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    
    // move to top left
    CGPathMoveToPoint(path, NULL, topLeft.x + cornerRadius, topLeft.y);
    
    // add top line
    CGPathAddLineToPoint(path, NULL, topRight.x - cornerRadius, topRight.y);
    
    // add top right curve
    CGPathAddQuadCurveToPoint(path, NULL, topRight.x, topRight.y, topRight.x, topRight.y + cornerRadius);
    
    // add right line
    CGPathAddLineToPoint(path, NULL, bottomRight.x, bottomRight.y - cornerRadius);
    
    // add bottom right curve
    CGPathAddQuadCurveToPoint(path, NULL, bottomRight.x, bottomRight.y, bottomRight.x - cornerRadius, bottomRight.y);
    
    // add bottom line
    CGPathAddLineToPoint(path, NULL, bottomLeft.x + cornerRadius, bottomLeft.y);
    
    // add bottom left curve
    CGPathAddQuadCurveToPoint(path, NULL, bottomLeft.x, bottomLeft.y, bottomLeft.x, bottomLeft.y - cornerRadius);
    
    // add left line
    CGPathAddLineToPoint(path, NULL, topLeft.x, topLeft.y + cornerRadius);
    
    // add top left curve
    CGPathAddQuadCurveToPoint(path, NULL, topLeft.x, topLeft.y, topLeft.x + cornerRadius, topLeft.y);
    
    // return the path
    return path;
}

@end



#if USES_XLFORM

/**
 if XLForm is used in the project, the class XLFormCustomSwitchCell will be available and as such
 */

#import "XLForm/XLForm.h"

@interface XLFormCustomSwitchCell : XLFormSwitchCell

+ (void) registerClassForRowDescriptorType;

@end

@implementation XLFormCustomSwitchCell

+ (void) registerClassForRowDescriptorType;
{
    [[XLFormViewController cellClassesForRowDescriptorTypes] setObject:[self class] forKey:XLFormRowDescriptorTypeBooleanSwitch];
}
#pragma mark - XLFormDescriptorCell

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryView = [[FBSwitch alloc] init];
    self.editingAccessoryView = self.accessoryView;
    [self.switchControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.switchControl.on = [self.rowDescriptor.value boolValue];
    self.switchControl.enabled = !self.rowDescriptor.isDisabled;
}

- (FBSwitch *)switchControl
{
    return (FBSwitch *)self.accessoryView;
}

- (void)valueChanged
{
    self.rowDescriptor.value = @(self.switchControl.on);
}

@end

#endif

@implementation FBSwitch (XLForms)

+ (void) registerXLFormCell
{
#if USES_XLFORM
    [XLFormCustomSwitchCell registerClassForRowDescriptorType];
#else
    return;
#endif
}

@end
