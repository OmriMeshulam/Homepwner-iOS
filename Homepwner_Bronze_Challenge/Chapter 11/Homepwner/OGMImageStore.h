//
//  OGMImageStore.h
//  Homepwner
//
//  Created by Omri Meshulam on 3/7/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OGMImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;


@end
