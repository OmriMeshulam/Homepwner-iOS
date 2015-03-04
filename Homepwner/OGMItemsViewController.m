//
//  OGMItemsViewController.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/2/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import "OGMItemsViewController.h"
#import "OGMItemStore.h"
#import "OGMItem.h"

@implementation OGMItemsViewController

- (instancetype)init
{
    // Call to superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if(self){
        for(int i = 0; i < 5; i++){
            [[OGMItemStore sharedStore] createItem];
        }
    }
    
    return self;
}

// Designated initializer
// Overriding it to call our inits
- (instancetype) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

// Required method, number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[OGMItemStore sharedStore] allItems] count];
}

// Required method, row data
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    // implicility creating tableViewCell by Apple to get the benefits of the reuse identifier
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Setting the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableView
    NSArray *items = [[OGMItemStore sharedStore] allItems];
    OGMItem *item = items[indexPath.row];

    cell.textLabel.text = [item description];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Telling the table view which kind of cell it should instantiate if there are no cells in the reuse pool
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

@end
