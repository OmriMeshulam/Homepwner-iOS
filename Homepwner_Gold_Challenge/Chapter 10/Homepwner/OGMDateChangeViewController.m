//
//  OGMDateChangeViewController.m
//  Homepwner
//
//  Created by Omri Meshulam on 3/7/15.
//  Copyright (c) 2015 Omri Meshulam. All rights reserved.
//

// View controller date picker programatically created and added to the view

#import "OGMDateChangeViewController.h"
#import "OGMItem.h"
#import "OGMDetailViewController.h"

@interface OGMDateChangeViewController ()

@end

@implementation OGMDateChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        // custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Allocating and intializing date picker and setting frame
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, 200, 100)];
    
    // sets the date picker's mode
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    // Sets the date pickers date to the date of the item on the previous view
    _datePicker.date = self.item.dateCreated;

    // Configures action for date picker
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Adding date picker to the view
    [self.view addSubview:_datePicker];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.datePicker endEditing:YES];
    
    OGMItem *item = self.item;
    [item changeDate: self.datePicker.date];
    
    NSLog(@"View popped off stack.");
    
}

- (IBAction)dateChanged:(id)sender
{
    NSLog(@"Date Selected");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
