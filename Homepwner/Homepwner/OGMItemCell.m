//
//  OGMItemCell.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/15/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import "OGMItemCell.h"

@interface OGMItemCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@end

@implementation OGMItemCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)showImage:(id)sender
{
    if(self.actionBlock){
        self.actionBlock();
    }
}

- (void)updateInterfaceForDynamicTypeSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    
    static NSDictionary *imageSizeDictionary;
    
    if(!imageSizeDictionary){
        imageSizeDictionary = @{ UIContentSizeCategoryExtraSmall : @40,
                             UIContentSizeCategorySmall : @40,
                             UIContentSizeCategoryMedium : @40,
                             UIContentSizeCategoryLarge : @40,
                             UIContentSizeCategoryExtraLarge : @45,
                             UIContentSizeCategoryExtraExtraLarge : @55,
                             UIContentSizeCategoryExtraExtraExtraLarge : @65 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
}

// Called on an object after it has been unarchived from a NIB file.
- (void)awakeFromNib
{
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateInterfaceForDynamicTypeSize)
               name:UIContentSizeCategoryDidChangeNotification
             object:nil];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.thumbnailView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.thumbnailView
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:0];
    [self.thumbnailView addConstraint:constraint];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

@end
