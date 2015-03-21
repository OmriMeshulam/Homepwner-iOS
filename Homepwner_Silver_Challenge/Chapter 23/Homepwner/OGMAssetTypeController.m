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

@interface OGMAssetTypeController () <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic) UIAlertView *addAssetAlert;

@end

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
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(addNewAsset)];
    self.navigationItem.rightBarButtonItem = addButton;
    
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

- (void)addNewAsset {
    NSLog(@"Adding New Asset!");
    
    if (!_addAssetAlert) {
        _addAssetAlert = [[UIAlertView alloc] initWithTitle:@"New Asset"
                                                    message:@"Enter New Asset Name"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok!", nil];
        
        self.addAssetAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    
    [self.addAssetAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"Index %i %@", buttonIndex, [self.addAssetAlert buttonTitleAtIndex:buttonIndex]);
            [self.addAssetAlert resignFirstResponder];
            break;
        case 1:
            NSLog(@"Index %i %@", buttonIndex, [self.addAssetAlert buttonTitleAtIndex:buttonIndex]);
            
            UITextField *textField = [self.addAssetAlert textFieldAtIndex:0];
            if ( textField.text.length > 0 )
                [[OGMItemStore sharedStore] createAssetWithName:textField.text];
            [self.tableView reloadData];
            break;
    }
}

@end
