//
//  UIViewController+FLBugKit.m
//  Float
//
//  Created by Evan Long on 2/8/12.
//  Copyright (c) 2012 Scribd, Inc. All rights reserved.
//

#import "UIViewController+FLBugKit.h"

@implementation UIViewController (FLBugKit)

- (UIViewController *)findTopMostViewController {
    UIViewController *result = self;
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *parent = (UINavigationController *)self;
        result = [parent.topViewController findTopMostViewController];
    } else if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *parent = (UITabBarController *)self;
        result = [parent.selectedViewController findTopMostViewController];
    }
    return result;
}

@end
