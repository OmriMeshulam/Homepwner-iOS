//
//  OGMImageStore.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/7/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import "OGMImageStore.h"

@interface OGMImageStore ()

@property(nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation OGMImageStore

// Making it a singleton
+ (instancetype)sharedStore
{
    static OGMImageStore *sharedStore = nil;
    
    if(!sharedStore){
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

// Noone should call init
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"reason:@"User +[OGMImageStore sharedStore]" userInfo:nil];
    
    return nil;
}

// Secret designated initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if(self){
        _dictionary = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key
{
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if(!key){
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

@end

