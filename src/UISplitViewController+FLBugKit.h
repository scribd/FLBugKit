//
//  UISplitViewController+FLBugKit.h
//  Float
//
//  Created by Evan Long on 3/22/12.
//  Copyright (c) 2012 Scribd, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISplitViewController (FLBugKit)

/**
 Helper to determine which child view controller the bug gesture is likely 
 interacting with.
 
 @return view controller gesture is interacting with within a UISplitViewController
 */
- (UIViewController *)viewControllerTargetedByGesture:(UIGestureRecognizer *)gesture;

@end
