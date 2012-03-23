//
//  FLMasterViewController.h
//  FLBugKitDemo
//
//  Created by Evan Long on 3/23/12.
//  Copyright (c) 2012 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLBugKit.h"

@class FLDetailViewController;

@interface FLMasterViewController : UITableViewController <FLAdditionalViewControllerBugMetadataProtocol>

@property (strong, nonatomic) FLDetailViewController *detailViewController;

@end
