//
//  OGMDateChangeViewController.h
//  Homepwner
//
//  Created by Omri Meshulam on 3/7/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OGMItem;

@interface OGMDateChangeViewController : UIViewController

@property (nonatomic, strong) OGMItem *item;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end
