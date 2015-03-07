//
//  OGMDetailViewController.h
//  Homepwner
//
//  Created by Omri Meshulam on 3/6/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OGMItem;
@class OGMDateChangeViewController;

@interface OGMDetailViewController : UIViewController

@property (nonatomic, strong) OGMItem *item;
@property (nonatomic, strong) OGMDateChangeViewController *changeDateVC;

@end
