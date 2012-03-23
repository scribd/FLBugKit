//
//  UISplitViewController+FLBugKit.m
//  Float
//
//  Created by Evan Long on 3/22/12.
//  Copyright (c) 2012 Scribd, Inc. All rights reserved.
//

#import "UISplitViewController+FLBugKit.h"

@implementation UISplitViewController (FLBugKit)

- (UIViewController *)viewControllerTargetedByGesture:(UIGestureRecognizer *)gesture {
	UIViewController *leftViewController = [self.viewControllers objectAtIndex:0];
	UIViewController *rightViewController = [self.viewControllers objectAtIndex:1];
	CGPoint p = [gesture locationInView:leftViewController.view];
	
	if ([leftViewController.view pointInside:p withEvent:nil]) {
		return leftViewController;
	}
	else {
		return rightViewController;
	}
}

@end
