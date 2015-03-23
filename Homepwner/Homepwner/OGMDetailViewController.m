//
//  OGMDetailViewController.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/6/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

#import "OGMDetailViewController.h"
#import "OGMItem.h"
#import "OGMImageStore.h"
#import "OGMItemStore.h"
#import "OGMAssetTypeController.h"

@interface OGMDetailViewController ()
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong)UIPopoverController *imagePickerPopover;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation OGMDetailViewController

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self){
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if(isNew){
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                     target:self
                                                                                     action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                       target:self
                                                                                       action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        // Make sure this is NOT in the if (isNew){} block of code
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(updateFonts)
                              name:UIContentSizeCategoryDidChangeNotification
                            object:nil];
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc]initWithImage:nil];
    
    // The contentMode of the image view in the XIB was Aspect fit:
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // Do not produce a translated contraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    // The image view was a subview of the view
    [self.view addSubview:iv];
    
    // The image view was pointed to by the imageView property
    self.imageView = iv;
    
    // Set the vertical priorities to be less than those of the other views
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolbar" : self.toolbar};
    
    // imageView is 0 pts from superview at left and right edges
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:nameMap];
    // imageView is 8 pts from dateLabel at its top edge
    // ... and 8 pts from toolbar at its bottom edge
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:nameMap];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication]statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    OGMItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    // NSDateFormatter turns date into a simple date string
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateStyle = NSDateIntervalFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *imageKey = self.item.itemKey;
    
    // Getting the image for its image key from the image store
    UIImage *imageToDisplay = [[OGMImageStore sharedStore] imageForKey:imageKey];
    
    // Using that image to put on the screen in the imageView
    self.imageView.image = imageToDisplay;
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel){
        typeLabel = NSLocalizedString(@"None", @" Type label none");
    }
    
    self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type %@", @"Asset type button"), typeLabel];
    
    [self updateFonts];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // Saving changes to item information
    OGMItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

- (void)setItem:(OGMItem *)item
{
    _item = item;
    self.navigationItem.title = item.itemName;
}

- (IBAction)takePicture:(id)sender {
    
    if([self.imagePickerPopover isPopoverVisible]){
        // If the popover is already up, get rid of it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device has a camera, take a picture, otherwise
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    // Place imagePicker on the screen
    // Check for iPad device before instantiating the popover controller
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        // Create new popover controller that will display the imagePicker
        self.imagePickerPopover = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate = self;
        
        // Display the popover controller;
        // Sender is the camera bar button item
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
    }else{
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from the info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];
    
    // Storing the image in the OGMImageStore for this key
    [[OGMImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    // Take the image picker off the screen
    // You must call this dismiss method
    
    // Do I have a popover?
    if(self.imagePickerPopover){
        // Dismiss it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    }else{
        // Dismiss the modal image picker
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    // Is it an iPad? No preparation necessary
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // Is it in landscape mode?
    if(UIInterfaceOrientationIsLandscape(orientation)){
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    }else{
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the OGMItem from the store
    [[OGMItemStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void) updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
}
- (IBAction)showAssetTypePicker:(id)sender
{
    [self.view endEditing:YES];
    
    OGMAssetTypeController *avc = [[OGMAssetTypeController alloc]init];
    avc.item = self.item;
    
    [self.navigationController pushViewController:avc
                                         animated:YES];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    BOOL isNew = NO;
    if ([identifierComponents count] == 3){
        isNew = YES;
    }
    return [[self alloc]initForNewItem:isNew];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    
    for (OGMItem *item in [[OGMItemStore sharedStore]allItems]){
        if ([itemKey isEqualToString:item.itemKey]){
            self.item = item;
            break;
        }
    }
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey
                 forKey:@"item.itemKey"];
    
    // Save changes into item (text fields)
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    
    // Have store save changes to the disk
    [[OGMItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

@end
