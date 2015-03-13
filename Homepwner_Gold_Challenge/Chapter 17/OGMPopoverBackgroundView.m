//
//  OGMPopoverBackgroundView.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/13/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//
#import "OGMPopoverBackgroundView.h"

@implementation OGMPopoverBackgroundView

@synthesize arrowDirection  = _arrowDirection;
@synthesize arrowOffset     = _arrowOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.arrowDirection = UIPopoverArrowDirectionUp;
        self.arrowOffset = 7.0;
    }
    return self;
}

+ (CGFloat)arrowBase
{
    return 20.0;
}

+ (CGFloat)arrowHeight
{
    return 50.0;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(3.0,3.0,3.0,3.0);
}

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}

@end