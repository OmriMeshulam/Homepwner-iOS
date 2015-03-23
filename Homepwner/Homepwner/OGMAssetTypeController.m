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
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"Asset Type", @"OGMAssetTypeController title");
    }
    return self;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[OGMItemStore sharedStore] allAssetTypes]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
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

@end
