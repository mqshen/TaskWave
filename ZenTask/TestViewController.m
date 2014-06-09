//
//  TestViewController.m
//  ZenTask
//
//  Created by GoldRatio on 6/3/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TestViewController.h"
#import "UILoopTableView.h"

@interface TestViewController () <UILoopTableViewDelegate, UILoopTableViewDataSource> {
    NSMutableArray *objects;
}

@property (strong) UILoopTableView *loopview;


@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        objects = [[NSMutableArray alloc] initWithCapacity:30];
        for (int i = 0; i< 30; ++i) {
            [objects addObject:[NSString stringWithFormat:@"test%d",i]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loopview = [[UILoopTableView alloc] initWithFrame:self.view.frame];
    self.loopview.delegate = self;
    self.loopview.dataSource = self;
    [self.view addSubview:self.loopview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger) numberOfRowsInTableView:(UILoopTableView *)tableView
{
    // Return the number of rows in the section.
    return [objects count];
}

- (UIView *)tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)indexPath
{
    static NSString *kCustomCellID = @"messageCell";
    UILabel *cell = (UILabel *)[self.loopview dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil) {
        cell = [[UILabel alloc] init];
    }
    
    
    cell.text = [NSString stringWithFormat:@"test%d",indexPath];
    
    return cell;
    // Configure the cell...
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < 10; ++i) {
        NSInteger index = [objects count];
        [objects insertObject:[NSString stringWithFormat:@"test%d", index] atIndex:0];
    }
    [tableView reloadData];
}



@end