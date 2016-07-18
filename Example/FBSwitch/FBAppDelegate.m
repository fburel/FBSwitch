//
//  FBAppDelegate.m
//  FBSwitch
//
//  Created by florian Burel on 07/18/2016.
//  Copyright (c) 2016 florian Burel. All rights reserved.
//

#import "FBAppDelegate.h"
#import "FBSwitch.h"

@implementation FBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (void) applyTheme
{
    
//    UIColor * onColor = [UIColor redColor];
//    UIColor * offColor = [UIColor blackColor];
//    UIColor * thumbColor = [UIColor whiteColor];
//    
//    [[FBSwitch appearance] setOnImage:[FBSwitch createBackgroundImageWithColor:onColor]];
//    [[FBSwitch appearance] setOffImage:[FBSwitch createBackgroundImageWithColor:offColor]];
//    [[FBSwitch appearance] setThumbImage:[FBSwitch createThumbImageWithColor:thumbColor]];
    
    // Based on : https://www.raywenderlich.com/23424/photoshop-for-developers-creating-a-custom-uiswitch
    
    [FBSwitch setPreferedSize:[UIImage imageNamed:@"switchBackground"].size];
    [[FBSwitch appearance] setOnImage:[UIImage imageNamed:@"switchBackground"]];
    [[FBSwitch appearance] setOffImage:[UIImage imageNamed:@"switchBackground"]];
    [[FBSwitch appearance] setThumbImage:[UIImage imageNamed:@"switchHandle"]];
    [[FBSwitch appearance] setThumbMargin:0];
    
    [[FBSwitch appearance] setOnText:NSLocalizedString(@"YES", @"Switch on text")];
    [[FBSwitch appearance] setOffText:NSLocalizedString(@"NO", @"Switch off text")];
    
    CGSize shadowOffset = CGSizeMake(0, 1);
    [[FBSwitch appearance] setLabelProperties:@
     {
         FBSwithOnLabelTextColor : [UIColor whiteColor],
         FBSwithOnLabelFont : [UIFont boldSystemFontOfSize:14],
         FBSwithOnLabelShadowColor :[UIColor colorWithRed:104.0/255 green:73.0/255 blue:54.0/255 alpha:1.0],
         FBSwithOnLabelShadowOffset : [NSValue valueWithBytes:&shadowOffset objCType:@encode(CGSize)],
         FBSwithOffLabelTextColor : [UIColor colorWithRed:104.0/255 green:73.0/255 blue:54.0/255 alpha:1.0],
         FBSwithOffLabelFont : [UIFont boldSystemFontOfSize:14],
         FBSwithOffLabelShadowColor : [UIColor whiteColor],
         FBSwithOffLabelShadowOffset :[NSValue valueWithBytes:&shadowOffset objCType:@encode(CGSize)]
     }];
}


@end
