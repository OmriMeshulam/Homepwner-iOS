//
//  OGMItem.m
//  RandomItems
//
//  Created by Omri Meshulam on 2/16/15.
//  Copyright (c) 2015 OmriMeshulam. All rights reserved.
//

#import "OGMItem.h"

@implementation OGMItem

+ (instancetype)randomItem
{
    // Creating a mutable array of three adjectives
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    
    // Creating a mutable array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    // Getting the index of a random adjective/noun from the lists
    // Note: the % operator, called the modulo operator, gives
    // you the remainder. So adjectiveIndex is a random number.
    // from 0 to 2 inclusive.
    
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    // Note that NSInteger is not an object, but a type definition for "long"
    
    /*
     NSString *randomName = [NSString stringWithFormat:@"%@ %@",
     [randomAdjectiveList objectAtIndex:adjectiveIndex],
     [randomNounList objectAtIndex:nounIndex]];
     */
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            randomAdjectiveList[adjectiveIndex],
                            randomNounList[nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];
    OGMItem *newItem = [[self alloc] initWithItemName:randomName
                                      valueInDollars:randomValue
                                        serialNumber:randomSerialNumber];
    
    return newItem;
}

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber
{
    //calling the superclass's designated initializer
    self = [super init];
    
    // Checking if the superclass's designated initializer succeeded
    if(self){
        // give the instance variable initial values
        _itemName = name;
        _valueInDollars = value;
        _serialNumber = sNumber;
        // Setting the dateCreated to the current date and time
        _dateCreated = [[NSDate alloc] init];
        
        // Creating an NSUUID object - and get its string representation
        NSUUID *uuid = [[NSUUID alloc]init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    
    // Returning the address of the newly initialized object
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

// Overriding parent class NSObject init initializer
-(instancetype)init
{
    return [self initWithItemName:@"Item"];
}


-(NSString *) description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
     self.itemName,
     self.serialNumber,
     self.valueInDollars,
     self.dateCreated];
    
    return descriptionString;
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

@end
