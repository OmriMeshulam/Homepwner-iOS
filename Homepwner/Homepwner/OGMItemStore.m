//
//  OGMItemStore.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/3/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import "OGMItemStore.h"
#import "OGMItem.h"
#import "OGMImageStore.h"

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

- (void)removeItem:(OGMItem *)item
{
    NSString *key = item.itemKey;
    
    [[OGMImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];    
}

- (void)moveItemAtIdex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if(fromIndex == toIndex){
        return;
    }
    // Getting pointer to object being moved so you can reinsert it
    OGMItem *item = self.privateItems[fromIndex];
    
    // Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // Insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
}

@end
