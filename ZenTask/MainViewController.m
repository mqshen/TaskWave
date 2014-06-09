//
//  MainViewController.m
//  ZenTask
//
//  Created by GoldRatio on 5/26/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "MainViewController.h"
#import "ProjectViewController.h"
#import "ProjectTableCell.h"
#import "Session.h"

@interface MainViewController ()

@property (nonatomic, strong) NSMutableArray *projects;

@end

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"项目";
    Session *session = [Session getInstance];
    self.projects = [[NSMutableArray alloc] initWithArray:session.projects];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.projects count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"projectCell";
    ProjectTableCell *cell = (ProjectTableCell *)[self.tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil) {
        cell = [[ProjectTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCustomCellID];
    }
    
    NSDictionary *item = self.projects[indexPath.row];
    
    cell.nameLabel.text = item[@"name"];
    cell.descriptionLabel.text = item[@"description"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Find the cell being touched and update its checked/unchecked image.
    ProjectViewController *projectViewController = [[ProjectViewController alloc] init];
    projectViewController.projectId = [[self.projects[indexPath.row] objectForKey:@"id"] intValue];
    [self.navigationController pushViewController:projectViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
