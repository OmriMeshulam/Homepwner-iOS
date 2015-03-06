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

@property (nonatomic) NSMutableArray *privateItemsOver50;
@property (nonatomic) NSMutableArray *privateItemsUnder50;

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
        _privateItemsOver50 = [[NSMutableArray alloc] init];
        _privateItemsUnder50 = [[NSMutableArray alloc] init];

    }
    return self;
}

- (NSArray *)allItemsOver50
{
    return self.privateItemsOver50;
}

- (NSArray *)allItemsUnder50
{
    return self.privateItemsUnder50;
}

- (OGMItem *)createItem
{
    OGMItem *item = [OGMItem randomItem];
    
    if(item.valueInDollars >= 50){
        [self.privateItemsOver50 addObject:item];
    }else{
         [self.privateItemsUnder50 addObject:item];
    }

    return item;
}

@end
