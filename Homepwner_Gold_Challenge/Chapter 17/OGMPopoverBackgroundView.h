//
//  OGMPopoverBackgroundView.h
//  Homepwner
//
//  Created by Omri Meshulam on 3/13/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OGMPopoverBackgroundView : UIPopoverBackgroundView

@property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection;
@property (nonatomic, readwrite) CGFloat arrowOffset;

@end