//
//  OGMItemStore.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/3/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import "OGMItemStore.h"
#import "OGMItem.h"

@interface OGMItemStore()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation OGMItemStore

+ (instancetype)sharedStore
{
    static OGMItemStore *sharedStore = nil;
    
    // Do I need to create a shared store (has one been initialized yet?)
    if (!sharedStore){
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

// If a programmer calls [[OGMItemStore alloc] init], let him know the error of his ways, throw exception
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[OGMItemStore sharedStore]" userInfo:nil];
    return nil;
}

// Real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if(self){
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (OGMItem *)createItem
{
    OGMItem *item = [OGMItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

@end
