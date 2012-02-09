//
//  FLBugKit.m
//  Float
//
//  Created by Evan Long on 2/4/12.
//  Copyright (c) 2012 Scribd, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FLBugKit.h"

@interface FLBugKit () {
	NSMutableDictionary *_windowToGesture;
}

- (void)_handleBugGesture:(UIGestureRecognizer *)gesture;
- (void)_showMailControllerForWindow:(UIWindow *)window gesture:(UIGestureRecognizer *)gesture;
- (NSData *)_captureScreenShotForView:(UIView *)view;

@property (nonatomic, readonly) id <FLStandardApplicationBugMetadataProtocol> standardBugDataSource;

@end

@implementation FLBugKit

#pragma mark - NSObject

- (void)dealloc {
	[_windowToGesture release];
	[super dealloc];
}

- (id)init {
	if ((self = [super init])) {
		_windowToGesture = [[NSMutableDictionary alloc] init];
	}
	return self;
}

#pragma mark - FLBugKit

+ (FLBugKit *)sharedInstance {
	static dispatch_once_t onceToken;
	static FLBugKit *_sharedInstance;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[FLBugKit alloc] init];
	});

	return _sharedInstance;
}

- (id <FLStandardApplicationBugMetadataProtocol>)standardBugDataSource {
	id appDelegate = [UIApplication sharedApplication].delegate;
	if ([appDelegate conformsToProtocol:@protocol(FLStandardApplicationBugMetadataProtocol)]) {
		return appDelegate;
	}
	
	return nil;
}

- (void)startMonitoringWindow:(UIWindow *)window {
	if ([_windowToGesture objectForKey:window] == nil) {
		UIGestureRecognizer *gesture = [self.standardBugDataSource bugGestureRecognizer];
		[gesture addTarget:self action:@selector(_handleBugGesture:)];
		[window addGestureRecognizer:gesture];
		[_windowToGesture setObject:gesture forKey:[NSValue valueWithNonretainedObject:window]];
	}
}

- (void)stopMonitoringWindow:(UIWindow *)window {
	NSValue *windowValue = [NSValue valueWithNonretainedObject:window];
	[window removeGestureRecognizer:[_windowToGesture objectForKey:windowValue]];
	[_windowToGesture removeObjectForKey:windowValue];
}

- (void)presentBugMailerForKeyWindow {
	[self _showMailControllerForWindow:[UIApplication sharedApplication].keyWindow gesture:nil];
}

#pragma mark - Private

- (void)_handleBugGesture:(UIGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateEnded) {
		UIWindow *window = (UIWindow *)gesture.view;
		if ([window isKindOfClass:[UIWindow class]] == NO) {
			return;
		}
		
		[self _showMailControllerForWindow:window gesture:gesture];
	}
}

- (void)_showMailControllerForWindow:(UIWindow *)window gesture:(UIGestureRecognizer *)gesture {
	if([MFMailComposeViewController canSendMail]) {
		UIViewController *activeViewController = [self.standardBugDataSource activeViewControllerFromRootViewController:window.rootViewController gesture:gesture];
		if ([activeViewController conformsToProtocol:@protocol(FLAdditionalViewControllerBugMetadataProtocol)] == NO) {
			if ([window.rootViewController conformsToProtocol:@protocol(FLAdditionalViewControllerBugMetadataProtocol)]) {
				activeViewController = window.rootViewController;
			}
			else {
				activeViewController = nil;
			}
		}
		
		// Start bug metadata collection
		NSString *userId = [self.standardBugDataSource userId];
		NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
		NSString *versionShortString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
		NSString *bugMetadata = [NSString stringWithFormat:@"userId=%@\nbundle version=%@\nversion short string=%@\n\n%@\n\n", userId, bundleVersion, versionShortString, [self.standardBugDataSource defaultBugMetadata]];
		NSString *emailAddress = nil;
		NSString *emailSubject = nil;
		
		id <FLAdditionalViewControllerBugMetadataProtocol> additionalBugDataSource = (id <FLAdditionalViewControllerBugMetadataProtocol>)activeViewController;
		if ([additionalBugDataSource respondsToSelector:@selector(additionalBugMetadata)]) {
			bugMetadata = [bugMetadata stringByAppendingFormat:@"%@", [additionalBugDataSource additionalBugMetadata]];
		}
		
		if ([additionalBugDataSource respondsToSelector:@selector(specificBugEmailAddress)]) {
			emailAddress = [additionalBugDataSource specificBugEmailAddress];
		}
		else {
			emailAddress = [self.standardBugDataSource defaultBugEmailAddress];
		}
		
		if ([additionalBugDataSource respondsToSelector:@selector(specificBugEmailSubject)]) {
			emailSubject = [additionalBugDataSource specificBugEmailSubject];
		}
		else {
			emailSubject = [self.standardBugDataSource defaultBugEmailSubject];
		}
		
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		mailViewController.mailComposeDelegate = self;
		[mailViewController setToRecipients:[NSArray arrayWithObject:emailAddress]];
		[mailViewController setSubject:emailSubject];
		[mailViewController setMessageBody:@"Please include any addition feedback for the developers to address your issue." isHTML:NO];
		[mailViewController addAttachmentData:[bugMetadata dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain;charset=utf-8" fileName:@"bugdata.txt"];
		[mailViewController addAttachmentData:[self _captureScreenShotForView:window] mimeType:@"image/png" fileName:@"screenshot.png"];
		[window.rootViewController presentModalViewController:mailViewController animated:YES];
		[mailViewController release];
	}
	else {
		[[[[UIAlertView alloc] initWithTitle:@"Error" 
									 message:@"Please setup an email account on your device before trying to file a bug report." 
									delegate:nil
						   cancelButtonTitle:nil 
						   otherButtonTitles:@"Ok", nil] autorelease] show];
	}
}

- (NSData *)_captureScreenShotForView:(UIView *)view {
	UIGraphicsBeginImageContext(view.bounds.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	NSData *pngData = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
	UIGraphicsEndImageContext();
	return pngData;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller.view.window.rootViewController dismissModalViewControllerAnimated:YES];
}

@end

/*
 TODO: 
 2. email code (make sure email access exists). 
    (better to provide source files alone with instructions to
     include mail framework or provide a xcodeproj/framework that
     includes that depedency.
 3. Provide optional category to search through `UINavigationController`, 
 `UISplitViewController`, `UITabbarController` for the active view controller
 4. Add arbitrary NSData from the various protocols
*/
