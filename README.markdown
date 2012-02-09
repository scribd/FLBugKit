## FLBugKit

FLBugKit is a simple way for users or testers to file bugs from witin an iOS application.
The library will collect various metadata about the application such as version and 
a screenshot. The developer also has the ability to specify additional information that
should be collected. All of this data is then attached to an email and addressed 
to your bug tracking system's inbox.

## Getting Started

To get started add all the files under `src/` to your project. 

On your `UIApplicationDelegate` implement `FLStandardApplicationBugMetadataProtocol` and
import `FLBugKit.h` and `UIViewController+FLBugKit.h`.

    - (NSString *)userId {
        return @"sample user id";
    }

    - (NSString *)defaultBugMetadata {
        return @"Information besides screenshot and version information";
    }

    - (NSString *)defaultBugEmailAddress {
        return @"mybugemail@myproject.fogbugz.com;
    }

    - (NSString *)defaultBugEmailSubject {
        return @"Subject of the bug email";
    }

    - (UIGestureRecognizer *)bugGestureRecognizer {
        UILongPressGestureRecognizer *bugGesture = [[[UILongPressGestureRecognizer alloc] init] autorelease];
        bugGesture.minimumPressDuration = 0.7;
        bugGesture.numberOfTouchesRequired = 3;
        return bugGesture;
    }

    /*findTopMostViewController is part of the FLBugKit category on UIViewController*/
    - (UIViewController *)activeViewControllerFromRootViewController:(UIViewController *)rootViewController gesture:(UIGestureRecognizer *)gesture {
        return [rootViewController findTopMostViewController];
    }

There are two ways the bug email can be created. Either programatically:

    [[FLBugKit sharedInstance] presentBugMailerForKeyWindow];

or by having `FLBugKit` monitor the gesture provided by `bugGestureRecognizer`:

    [[FLBugKit sharedInstance] startMonitoringWindow:applicationWindow];

A good place for `startMonitoringWindow` is in the `application:didFinishLaunchingWithOptions:`.

Also it is important to note that `FLStandardApplicationBugMetadataProtocol` must
be implemented by the object `[UIApplication sharedApplication]` delegate. `FLBugKit`
assumes that object that implements the `FLStandardApplicationBugMetadataProtocol`.

## Authors

* [Evan Long](https://github.com/evanlong)
* [Jesse Andersen](https://github.com/gotosleep)

## License

FLBugKit is licensed under the MIT License. See LICENSE.txt.
