//
//  FLBugKit.h
//  Float
//
//  Created by Evan Long on 2/4/12.
//  Copyright (c) 2012 Scribd, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

/**
 Protocol must be implemented by the `UIApplicationDelegate`
 */
@protocol FLStandardApplicationBugMetadataProtocol <NSObject>

/**
 Returns a string that can be used to identify a user for the
 application.
 
 @return string that identifies the user
 */
- (NSString *)userId;

/**
 This string of application bug metadata in addition to a screenshot,
 version number and build number. 
 
 @return string of metadata about the application
 */
- (NSString *)defaultBugMetadata;

/**
 Providing a custom email can be useful in directing bugs to the
 right person or team.
 
 @return default email address that the bug will be sent to
 */
- (NSString *)defaultBugEmailAddress;

/**
 Providing a subject can be useful in categorizing bugs within your
 bug tracking system.
 
 @return default subject of the bug email
 */
- (NSString *)defaultBugEmailSubject;

/**
 Provides the `UIGestureRecognizer` that when triggered will cause
 the collection of data and prompt the user to email this data to
 the developers. `FLBugKit` instance will add itself as a target to
 handle the gesture event.
 
 @return `UIGestureRecognizer` registered with `UIWindow` instances
 */
- (UIGestureRecognizer *)bugGestureRecognizer;

/**
 Finds the active view controller given a window's root view controller. The
 result will be asked for additional metadata for the bug if it is available.
 
 @param rootViewController The rootViewController from the `UIWindow` that 
 handled the gesture.
 
 @param gesture The gesture that triggered the bug metadata to be collected
 
 @return The view controller that may have additional bug metadata
 
 @discussion It can be useful for the case where the root view controller for
 a window is a controller of other controllers such as a `UINavigationController`.
 */
- (UIViewController *)activeViewControllerFromRootViewController:(UIViewController *)rootViewController gesture:(UIGestureRecognizer *)gesture;

@end

/**
 Protocol that is implemented by a `UIViewController` when additional
 metadata is required reguarding the view the user is interacting with.
 */
@protocol FLAdditionalViewControllerBugMetadataProtocol <NSObject>

@optional
/**
 Provides string of metadata about the active view controller. The information
 returned is appended in addition to the `defaultBugMetadata` provided by the
 `FLStandardApplicationBugMetadataProtocol`.
 
 @return string of metadata about the active view controller
 */
- (NSString *)additionalBugMetadata;

/**
 Overrides the email address provided by the `FLStandardApplicationBugMetadataProtocol`
 
 @return email address the bug will be sent to
 */
- (NSString *)specificBugEmailAddress;

/**
 Overrides the email subject provided by the `FLStandardApplicationBugMetadataProtocol`
 
 @return subject of the bug email
 */
- (NSString *)specificBugEmailSubject;

@end

/**
 `FLBugKit` is a utility for filing bugs via email from within an
 application.

 It is required that the `UIApplicationDelegate` implement the
 `FLStandardApplicationBugMetadataProtocol`.

 When an email for a bug is created a screenshot of the window will be
 taken, the `FLStandardApplicationBugMetadataProtocol` methods will be called to
 gather the bug's metadata, and if the active view controller implements
 the `FLAdditionalViewControllerBugMetadataProtocol` its data will be included as well.

 `FLBugKit` will always include a screenshot, version number (CFBundleShortVersionString),
 and build number (CFBundleVersion) in addition to the data returned by
 `FLStandardApplicationBugMetadataProtocol` and `FLAdditionalViewControllerBugMetadataProtocol`.
 */
@interface FLBugKit : NSObject <MFMailComposeViewControllerDelegate>

/**
 Creates and returns the `sharedInstance` of `FLBugKit`. If it already
 exists it simply returns it.

 @return the application's shared instance of `FLBugKit`
 */
+ (FLBugKit *)sharedInstance;

/**
 Starts monitoring a window for a bug gesture event using the
 `UIGestureRecognizer` instance provided by the implementation of
 the `FLStandardApplicationBugMetadataProtocol` by the `sharedApplication`
 delegate.
 
 @param window The window instance that will be monitored 
 */
- (void)startMonitoringWindow:(UIWindow *)window;

/**
 Removes the `UIGestureRecognizer` from the `UIWindow` that was attached 
 with `startMonitoringWindow:`. 
 
 @param window The window that will stopped being monitored
 */
- (void)stopMonitoringWindow:(UIWindow *)window;

/**
 Programatically present the bug mailer without waiting for a `UIWindow`
 gesture recognizer to be raised. The `keyWindow` for the `sharedApplication`
 will be used to retrieve 
 */
- (void)presentBugMailerForKeyWindow;

@end
