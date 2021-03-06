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

@import CoreData;

@interface OGMItemStore()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

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
        // Read Homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Where does the SQLite file go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]){
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc]init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (OGMItem *)createItem
{
    double order;
    if ([self.allItems count] == 0){
        order = 1.0;
    }else{
        order = [[self.privateItems lastObject]orderingValue] + 1.0;
    }
    NSLog(@"Adding after &d items, order = %.2f", [self.privateItems count], order);
    
    OGMItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"OGMItem"
                                                  inManagedObjectContext:self.context];
    item.orderingValue = order;
    
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(OGMItem *)item
{
    NSString *key = item.itemKey;
    
    [[OGMImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item];
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
    
    // Computing a new orderValue for the object that was moved
    double lowerBound = 0.0;
    
    // Is there an object before it in the array?
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // Is there an object after it in the array?
    if (toIndex < [self.privateItems count] - 1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    } else {
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful){
        NSLog(@"Error saving : %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems
{
    if (!self.privateItems){
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"OGMItem"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue"
                                                             ascending:YES];
        request.sortDescriptors = @[sd];
        
        // More on predicates in Apple's Predicate Programming Guide
        // NSPredicate *p = [NSPredicate predicateWithFormat:@"valueInDollars > 50"];
        // [request setPredicate:p];
        // NSArray *expensiveStuff = [result filteredArrayUsingPredicate:p]; // filtering already set arrays

        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        if (!result){
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc]initWithArray:result];
    }
}

- (NSArray *)allAssetTypes
{
    if (!_allAssetTypes){
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"OGMAssetType"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        if (!result){
            [NSException raise:@"Fetch failed"
                        format:@"Reason %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    // If this the first time the program is being run?
    if ([_allAssetTypes count] == 0){
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"OGMAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
      
        type = [NSEntityDescription insertNewObjectForEntityForName:@"OGMAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"OGMAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
    }
    
    return _allAssetTypes;
}

- (void)createAssetWithName:(NSString *)assetName {
    NSManagedObject *asset = [NSEntityDescription insertNewObjectForEntityForName:@"OGMAssetType"
                                                           inManagedObjectContext:self.context];
    [asset setValue:assetName forKey:@"label"];
    
    [_allAssetTypes addObject:asset];
}

@end
