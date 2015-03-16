//
//  OGMImageViewController.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/16/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import "OGMImageViewController.h"

@implementation OGMImageViewController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // We must cast the view to UImageView so the compiler knows it is okay to send it setImage
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image;
}

- (void) loadView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}

@end
