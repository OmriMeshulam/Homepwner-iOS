//
//  OGMItem.h
//  RandomItems
//
//  Created by Omri Meshulam on 2/16/15.
//  Copyright (c) 2015 OmriMeshulam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGMItem : NSObject

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

+(instancetype)randomItem;

// Designated initializer (constructor) for OGMItem
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString*)name;

-(void)changeDate:(NSDate *)dateCreated;


@end
