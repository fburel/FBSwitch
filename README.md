# FBSwitch

[![CI Status](http://img.shields.io/travis/florian Burel/FBSwitch.svg?style=flat)](https://travis-ci.org/florian Burel/FBSwitch)
[![Version](https://img.shields.io/cocoapods/v/FBSwitch.svg?style=flat)](http://cocoapods.org/pods/FBSwitch)
[![License](https://img.shields.io/cocoapods/l/FBSwitch.svg?style=flat)](http://cocoapods.org/pods/FBSwitch)
[![Platform](https://img.shields.io/cocoapods/p/FBSwitch.svg?style=flat)](http://cocoapods.org/pods/FBSwitch)

Purpose
--------------

I created FBSwitch as a replacement for Apple's UISwitch. The goal was to be able to customize switch using images, and to be able to customize all the switches at once in a single place using the UIAppearance proxy.

What FBSwitch does
----------------

* Act as a fit replacement for UISwitch (state, target-action...)
* Allow the use of image for the thumb, the on and the off tracks.
* Allow size customization (you are not stuck with the 51x31pts anymore)
* Allow to add text in the ON and OFF section
* Allow to customize the text appeareance
* Support the UIAppearance proxy for images, text and label properties.
* Helper method to create 51x31 rounded corner tracks and 28x28 thumb images while waiting for the designer artwork
* Optionnaly, if your project uses XLForm, allow you to replace all your XLFormBooleanSwitch cell using Apple UISwitch by cell using FBSwitch instead without having anything to change anywhere in your forms controller.

## How to create a Switch

As a classic UIView, you can do so either in storyboard or in code. If created in code, you can set the frame in the designated initializer, or simply use 

```objc

FBSwitch * ctrl = [FBSwitch new];

```
This will give you a classic 51x31 gray off / green on switch much similar to Apple's UISwitch.

## Using images

The main purpose of this librairy was to use custom image for the switch, so here's how this works. Off course you can set the images for each switch individually, but since it's most likely that you want to provide a consistent UI, you can use the UIAppearance proxy.
Your designer is off to, well... wherever it is they go, and you don't have image yet? Relax, I added a set off method that will generate tracks and thumb image of the color of your choosing.

```objc

- (void) applyTheme
{

UIColor * onColor = [UIColor redColor];
UIColor * offColor = [UIColor blackColor];
UIColor * thumbColor = [UIColor whiteColor];

[[FBSwitch appearance] setOnImage:[FBSwitch createBackgroundImageWithColor:onColor]];
[[FBSwitch appearance] setOffImage:[FBSwitch createBackgroundImageWithColor:offColor]];
[[FBSwitch appearance] setThumbImage:[FBSwitch createThumbImageWithColor:thumbColor]];

}

```

## Size

Most often that I would like to admit it, I was in between to seats whith my designer on one side and UISwitch on the other. One wanted a larger thinner switch while the other, well, wont let me do so. FBSwitch solve this. Of course you can do use initWithFrame, but that will imply that you would have to change this at multiple places each time your switch design change. Instead I offer you the setPreferredSize: method. No each time you do a [[FBSwitch alloc] init], the created control will have your, well, preferred size.

```objc

- (void) applyTheme
{
// Based on : https://www.raywenderlich.com/23424/photoshop-for-developers-creating-a-custom-uiswitch

[FBSwitch setPreferedSize:[UIImage imageNamed:@"switchBackground"].size];
[[FBSwitch appearance] setOnImage:[UIImage imageNamed:@"switchBackground"]];
[[FBSwitch appearance] setOffImage:[UIImage imageNamed:@"switchBackground"]];
[[FBSwitch appearance] setThumbImage:[UIImage imageNamed:@"switchHandle"]];
[[FBSwitch appearance] setThumbMargin:0];

}

```
## Text

Adding text like "YES" or "NO" to the on and off part is something that can be nice, but difficult to internationalize if the text is embeded in the image. Instead her

```objc

- (void) applyTheme
{
// Based on : https://www.raywenderlich.com/23424/photoshop-for-developers-creating-a-custom-uiswitch

[FBSwitch setPreferedSize:[UIImage imageNamed:@"switchBackground"].size];
[[FBSwitch appearance] setOnImage:[UIImage imageNamed:@"switchBackground"]];
[[FBSwitch appearance] setOffImage:[UIImage imageNamed:@"switchBackground"]];
[[FBSwitch appearance] setThumbImage:[UIImage imageNamed:@"switchHandle"]];
[[FBSwitch appearance] setThumbMargin:0];

[[FBSwitch appearance] setOnText:NSLocalizedString(@"YES", @"Switch on text")];
[[FBSwitch appearance] setOffText:NSLocalizedString(@"NO", @"Switch off text")];

}

```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FBSwitch is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FBSwitch"
```

## Author

florian Burel, fl0@mac.com

## License

FBSwitch is available under the MIT license. See the LICENSE file for more info.
