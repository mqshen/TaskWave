//
//  MessageViewController.m
//  ZenTask
//
//  Created by GoldRatio on 5/28/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "MessageViewController.h"
#import "HttpConnection.h"
#import "Session.h"
#import "MessageCell.h"
#import "MessageDetailViewController.h"

@interface MessageViewController ()


@property(strong) NSMutableArray *messages;
@property(strong) UITableView *tableView;

@end

@implementation MessageViewController

@synthesize projectId = _projectId;
@synthesize rootViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setProjectId:(long) value
{
    if (value != _projectId) {
        _projectId = value;
        Session *session = [Session getInstance];
        NSInteger currentTeamId = session.teamId;
        NSString *url = [NSString stringWithFormat:@"%ld/project/%ld/topic", (long)currentTeamId, self.projectId];
        [HttpConnection initWithRequestURL:url
                                httpMethod:@"get"
                               requestDate:nil
                             successAction:^(id messages) {
                                 self.messages = messages;
                                 self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
                                 self.tableView.delegate = self;
                                 self.tableView.dataSource = self;
                                 [self.view addSubview:self.tableView];
                             }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"todoCell";
    MessageCell *cell = (MessageCell *)[self.tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:kCustomCellID];
    }
    
    NSDictionary *item = [self.messages objectAtIndex:indexPath.row];
    cell.nameLabel.text = [item objectForKey:@"subject"];
    cell.descriptionLabel.text = [item objectForKey:@"summary"];
    cell.userNameView.text = [[item objectForKey:@"creator"] objectForKey:@"name"];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"png"];
    cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    return cell;
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


-(void) addObject:(NSDictionary *) message withType:(ObjectType)type
{
    [self.messages insertObject:message atIndex:0];
    [self.tableView reloadData];
}

-(void) updateObject:(NSDictionary *) todo withType:(ObjectType)type
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    MessageDetailViewController *detailViewController = [[MessageDetailViewController alloc] init];
    detailViewController.message = message;
    [self.rootViewController.navigationController pushViewController:detailViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
