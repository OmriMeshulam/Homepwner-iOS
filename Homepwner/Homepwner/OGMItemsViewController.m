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
#import "OGMItemCell.h"
#import "OGMImageStore.h"
#import "OGMImageViewController.h"


@interface OGMItemsViewController () <UIPopoverControllerDelegate, UIDataSourceModelAssociation>

@property (nonatomic, strong) UIPopoverController *imagePopover;

@end

@implementation OGMItemsViewController

- (instancetype)init
{
    // Call to superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if(self){
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = NSLocalizedString(@"Homepwner", @"Name of application");
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        // Creating a new bar button item that will send
        // addNewItem: to OGMItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        // Setting this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(updateTableViewsForDynamicTypeSize)
                   name:UIContentSizeCategoryDidChangeNotification
                 object:nil];
        
        // Register for locale change notifications
        [nc addObserver:self
               selector:@selector(localeChanged:)
                   name:NSCurrentLocaleDidChangeNotification
                 object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *nc =  [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
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
    OGMItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OGMItemCell" forIndexPath:indexPath];
    
    // Setting the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableView
    NSArray *items = [[OGMItemStore sharedStore] allItems];
    OGMItem *item = items[indexPath.row];

    // Configure the cell with the OGMItem
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    static NSNumberFormatter *currencyFormatter = nil;
    if (currencyFormatter == nil){
        currencyFormatter = [[NSNumberFormatter alloc]init];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    cell.valueLabel.text = [currencyFormatter stringFromNumber:@(item.valueInDollars)];
    cell.thumbnailView.image = item.thumbnail;
    
    __weak OGMItemCell *weakCell = cell;
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        
        OGMItemCell *strongCell = weakCell;
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            NSString *itemKey = item.itemKey;
            
            // If there is no image, we don't need to display anything
            UIImage *img = [[OGMImageStore sharedStore] imageForKey:itemKey];
            if(!img){
                return;
            }
            
            // Make a rectangle for the frame of the thumbnail relative to our table view
            CGRect rect =  [self.view convertRect:strongCell.thumbnailView.bounds
                                         fromView:strongCell.thumbnailView];
            
            // Create a new OGMImageViewController and set its image
            OGMImageViewController *ivc = [[OGMImageViewController alloc]init];
            ivc.image = img;
            
            // Present a 600x600 popover from the rect
            self.imagePopover = [[UIPopoverController alloc]initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
        }
    };
    
    return cell;
}

// Getting rid of the popover if the user taps anywhere outside of it
- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the NIB File
    UINib *nib = [UINib nibWithNibName:@"OGMItemCell" bundle:nil];
    
    // Registering this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"OGMItemCell"];
    
    self.tableView.restorationIdentifier = @"OGMItemsViewControllerTableView";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTableViewsForDynamicTypeSize];
}

- (IBAction)addNewItem:(id)sender
{
    // Creating a new OGMItem and adding it to the store
    OGMItem *newItem = [[OGMItemStore sharedStore] createItem];
    
    OGMDetailViewController *detailViewController = [[OGMDetailViewController alloc]initForNewItem:YES];
    detailViewController.item = newItem;
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:detailViewController];
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
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

- (void)updateTableViewsForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if(!cellHeightDictionary){
        cellHeightDictionary = @{ UIContentSizeCategoryExtraSmall : @44,
                                  UIContentSizeCategorySmall : @44,
                                  UIContentSizeCategoryMedium : @44,
                                  UIContentSizeCategoryLarge : @44,
                                  UIContentSizeCategoryExtraLarge : @55,
                                  UIContentSizeCategoryExtraExtraLarge : @65,
                                  UIContentSizeCategoryExtraExtraExtraLarge : @75 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

//  Required method for UIViewControllerRestoration protocol
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
    
    [super decodeRestorableStateWithCoder:coder];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    NSString *identifier = nil;
    
    if (idx && view){
        // Return an identifier of the given NSIndexPath
        // in case next time the data source changes
        OGMItem *item = [[OGMItemStore sharedStore]allItems][idx.row];
        identifier = item.itemKey;
    }
    
    return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSIndexPath *indexPath = nil;
    
    if(identifier && view){
        NSArray *items = [[OGMItemStore sharedStore]allItems];
        for (OGMItem *item in items){
            if ([identifier isEqualToString:item.itemKey]){
                int row = [items indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    
    return indexPath;
}

- (void)localeChanged:(NSNotification *)note
{
    [self.tableView reloadData];
}

@end
