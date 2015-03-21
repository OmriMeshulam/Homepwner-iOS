//
//  OGMAssetTypeController.h
//  Homepwner
//
//  Created by Omri Meshulam on 3/20/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class OGMItem;

@interface OGMAssetTypeController : UITableViewController

@property (nonatomic, copy) void (^dismissBlock)(void);

@property (nonatomic, strong) OGMItem *item;

@end
