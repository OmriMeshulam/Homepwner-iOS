//
//  OGMAssetTypeController.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/20/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import "OGMAssetTypeController.h"
#import "OGMItemStore.h"
#import "OGMItem.h"

@implementation OGMAssetTypeController

- (instancetype) init
{
    return [super initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.item.assetType) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return [[[OGMItemStore sharedStore] allAssetTypes]count];
    }else{
        NSArray *allItems = [[OGMItemStore sharedStore] allItems];
        NSPredicate *p = [NSPredicate predicateWithFormat:@"AssetType == %@", self.item.assetType];
        NSArray *typeItems = [allItems filteredArrayUsingPredicate:p];
        return [typeItems count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    if (indexPath.section == 0){
        NSArray *allAssets = [[OGMItemStore sharedStore]allAssetTypes];
        NSManagedObject *assetType = allAssets[indexPath.row];
    
        // Use the key-value coding to get the asset type's label
        NSString *assetLabel = [assetType valueForKey:@"label"];
        cell.textLabel.text = assetLabel;
    
        // Checkmark the one that is currently selected
        if (assetType == self.item.assetType){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        NSArray *allItems = [[OGMItemStore sharedStore] allItems];
        NSPredicate *p = [NSPredicate predicateWithFormat:@"AssetType == %@", self.item.assetType];
        NSArray *typeItems = [allItems filteredArrayUsingPredicate:p];
        
        OGMItem *item = typeItems[indexPath.row];
        cell.textLabel.text = item.itemName;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[OGMItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Asset Type";
    } else {
        return @"Assets in the selected type";
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return indexPath;
    } else {
        return nil;
    }
}

@end
