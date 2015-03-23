//
//  OGMDetailViewController.h
//  Homepwner
//
//  Created by Omri Meshulam on 3/6/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OGMItem;

@interface OGMDetailViewController : UIViewController <UIViewControllerRestoration>

- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) OGMItem *item;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
