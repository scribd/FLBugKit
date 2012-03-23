//
//  FLDetailViewController.h
//  FLBugKitDemo
//
//  Created by Evan Long on 3/23/12.
//  Copyright (c) 2012 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLBugKit.h"

@interface FLDetailViewController : UIViewController <UISplitViewControllerDelegate, FLAdditionalViewControllerBugMetadataProtocol>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
