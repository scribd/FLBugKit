//
//  FLAppDelegate.h
//  FLBugKitDemo
//
//  Created by Evan Long on 3/23/12.
//  Copyright (c) 2012 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FLBugKit.h"
#import "UIViewController+FLBugKit.h"
#import "UISplitViewController+FLBugKit.h"

@interface FLAppDelegate : UIResponder <UIApplicationDelegate, FLStandardApplicationBugMetadataProtocol>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@end
