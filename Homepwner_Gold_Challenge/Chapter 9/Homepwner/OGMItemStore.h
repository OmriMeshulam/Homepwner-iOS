//
//  OGMItemStore.h
//  Homepwner
//
//  Created by Omri Meshulam on 3/3/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

// This class is a singleton, only one instance (static like)

#import <Foundation/Foundation.h>

@class OGMItem;

@interface OGMItemStore : NSObject

@property (nonatomic, readonly)NSArray *allItems;

// Notice that this is a class method  and prefixed with a + instead of a -
+ (instancetype)sharedStore; // declares being a singleton

- (OGMItem *)createItem;

- (void)removeItem:(OGMItem *)item;

- (void)moveItemAtIdex:(NSUInteger)fromIndex
               toIndex:(NSUInteger)toIndex;

@end
