//
//  UIViewController+FLBugKit.h
//  Float
//
//  Created by Evan Long on 2/8/12.
//  Copyright (c) 2012 Scribd, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Utilities that are helpful for interacting with FLBugKit and standard UIViewControllers
 provided by UIKit.
 */
@interface UIViewController (FLBugKit)

/**
 With a controller of controllers it is not always obvious which one the
 user is currently interacting with. `findTopMostViewController` is a
 simple search that looks for the top most view controller if the root
 is a `UINavigationController` or the active tab in the case of a
 `UISplitViewController`.
 
 @return view controller user is likely interacting with
 */
- (UIViewController *)findTopMostViewController;

@end
