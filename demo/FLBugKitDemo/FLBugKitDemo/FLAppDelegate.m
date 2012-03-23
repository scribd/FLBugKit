//
//  FLAppDelegate.m
//  FLBugKitDemo
//
//  Created by Evan Long on 3/23/12.
//  Copyright (c) 2012 Evan. All rights reserved.
//

#import "FLAppDelegate.h"
#import "FLMasterViewController.h"
#import "FLDetailViewController.h"

@implementation FLAppDelegate

#pragma mark - FLBugKit

- (NSString *)userId {
    return @"sample user id";
}

- (NSString *)defaultBugMetadata {
    return @"Information besides screenshot and version information";
}

- (NSString *)defaultBugEmailAddress {
    return @"mybugemail@myproject.fogbugz.com";
}

- (NSString *)defaultBugEmailSubject {
    return @"Subject of the bug email";
}

- (UIGestureRecognizer *)bugGestureRecognizer {
    UILongPressGestureRecognizer *bugGesture = [[[UILongPressGestureRecognizer alloc] init] autorelease];
    bugGesture.minimumPressDuration = 0.7;
    bugGesture.numberOfTouchesRequired = 2;
    return bugGesture;
}

- (UIViewController *)activeViewControllerFromRootViewController:(UIViewController *)rootViewController gesture:(UIGestureRecognizer *)gesture {
	if ([rootViewController isKindOfClass:[UISplitViewController class]]) {
		UISplitViewController *split = (UISplitViewController *)rootViewController;
		rootViewController = [split viewControllerTargetedByGesture:gesture];
	}
    return [rootViewController findTopMostViewController];
}


#pragma mark - Generated Code

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;

- (void)dealloc
{
	[_window release];
	[_navigationController release];
	[_splitViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    FLMasterViewController *masterViewController = [[[FLMasterViewController alloc] initWithNibName:@"FLMasterViewController_iPhone" bundle:nil] autorelease];
	    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
	    self.window.rootViewController = self.navigationController;
	} else {
	    FLMasterViewController *masterViewController = [[[FLMasterViewController alloc] initWithNibName:@"FLMasterViewController_iPad" bundle:nil] autorelease];
	    UINavigationController *masterNavigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
	    
	    FLDetailViewController *detailViewController = [[[FLDetailViewController alloc] initWithNibName:@"FLDetailViewController_iPad" bundle:nil] autorelease];
	    UINavigationController *detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:detailViewController] autorelease];
		
		masterViewController.detailViewController = detailViewController;
		
	    self.splitViewController = [[[UISplitViewController alloc] init] autorelease];
	    self.splitViewController.delegate = detailViewController;
	    self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
	    
	    self.window.rootViewController = self.splitViewController;
	}
	[[FLBugKit sharedInstance] startMonitoringWindow:self.window];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
