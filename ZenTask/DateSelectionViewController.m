//
//  DateSelectionViewController.m
//  ZenTask
//
//  Created by GoldRatio on 5/30/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "DateSelectionViewController.h"

@interface DateSelectionViewController ()

@end

@implementation DateSelectionViewController

@synthesize datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.datePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.selectedData = [NSDate date];
        
    }
    return self;
}



- (void)oneDatePickerValueChanged:(id) sender {
    NSDate *select = [sender date]; // 获取被选中的时间
    self.selectedData = select;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.dataPicketContainer addSubview:self.datePicker];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setSelectedDate:(NSDate *)selectedDate
{
    self.selectedData = selectedDate;
    [self.datePicker setDate:selectedDate];
}
@end
