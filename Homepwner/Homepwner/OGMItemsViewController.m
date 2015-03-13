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
#import "OGMDetailViewController.h"

@interface OGMItemsViewController ()

@end

@implementation OGMItemsViewController

- (instancetype)init
{
    // Call to superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if(self){
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        // Creating a new bar button item that will send
        // addNewItem: to OGMItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        // Setting this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (IBAction)addNewItem:(id)sender
{
    // Creating a new OGMItem and adding it to the store
    OGMItem *newItem = [[OGMItemStore sharedStore] createItem];
    
    OGMDetailViewController *detailViewController = [[OGMDetailViewController alloc]initForNewItem:YES];
    detailViewController.item = newItem;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:detailViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

// For deleting a row
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSArray *items = [[OGMItemStore sharedStore] allItems];
        OGMItem *item = items[indexPath.row];
        [[OGMItemStore sharedStore] removeItem:item];
        
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    }
}

// For moving a row
- (void) tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
        toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[OGMItemStore sharedStore] moveItemAtIdex:sourceIndexPath.row
                                       toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OGMDetailViewController *detailviewController = [[OGMDetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[OGMItemStore sharedStore] allItems];
    OGMItem *selectedItem = items[indexPath.row];
    
    // Giving detail view controller a pointer to the item object in row
    detailviewController.item = selectedItem;
    
    // Push it onto the top of the navigation controllers stack
    [self.navigationController pushViewController:detailviewController animated:YES];
}

@end
