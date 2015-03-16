//
//  OGMImageViewController.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/16/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import "OGMImageViewController.h"

@interface OGMImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

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
}

- (void) loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    
    self.imageView = [[UIImageView alloc]initWithImage:self.image];
    
    self.imageView.contentMode = UIViewContentModeCenter;
    
    // Centering the image in the popover
    [self.imageView setCenter:CGPointMake(600/2, 600/2)];
    
    scrollView.scrollEnabled = NO;
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    
    [scrollView addSubview:self.imageView];
    
    self.view = scrollView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
