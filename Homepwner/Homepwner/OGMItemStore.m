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
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc]initPrivate];
    });
    
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
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if(!_privateItems){
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (OGMItem *)createItem
{
    OGMItem *item = [[OGMItem alloc]init];
    
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

- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    NSLog(@"%@",path);

    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

@end
