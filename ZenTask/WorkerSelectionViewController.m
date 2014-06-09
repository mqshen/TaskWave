//
//  WorkerSelectionViewController.m
//  ZenTask
//
//  Created by GoldRatio on 5/30/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "WorkerSelectionViewController.h"
#import "HttpConnection.h"
#import "Session.h"

@interface WorkerSelectionViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *dataPicker;
@property (nonatomic, strong) NSArray *workers;

@end

@implementation WorkerSelectionViewController

@synthesize projectId = _projectId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataPicker.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setProjectId:(long) value
{
    if (_projectId != value) {
        _projectId = value;
        Session *session = [Session getInstance];
        NSInteger currentTeamId = session.teamId;
        NSString *url = [NSString stringWithFormat:@"%ld/project/%ld/member", (long)currentTeamId, self.projectId];
        [HttpConnection initWithRequestURL:url
                                httpMethod:@"get"
                               requestDate:nil
                             successAction:^(id workers) {
                                 self.workers = workers;
                                 self.dataPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
                                 self.dataPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
                                 self.dataPicker.dataSource = self;
                                 self.dataPicker.delegate = self;
                                 [self.dataPicketContainer addSubview:self.dataPicker];
                                 self.selectedData = [self.workers objectAtIndex:0];
                             }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.workers count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 320.0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
    
    myView.textAlignment = NSTextAlignmentCenter;
    
    myView.text = [[self.workers objectAtIndex:row] objectForKey:@"name"];
    
    return myView;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedData = [self.workers objectAtIndex:row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
