//
//  OGMImageTransformer.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/20/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import "OGMImageTransformer.h"

@implementation OGMImageTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

- (id) transformedValue:(id)value
{
    if (!value){
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]){
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
