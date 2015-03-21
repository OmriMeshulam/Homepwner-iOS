//
//  OGMItem.h
//  Homepwner
//
//  Created by Omri Meshulam on 3/20/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>


@interface OGMItem : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic) int valueInDollars;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSString * itemKey;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
