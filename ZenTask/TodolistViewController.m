//
//  TodolistViewController.m
//  ZenTask
//
//  Created by GoldRatio on 5/27/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TodolistViewController.h"
#import "HttpConnection.h"
#import "Session.h"
#import "TodolistView.h"
#import "TodoCell.h"
#import "OperationProtocol.h"
#import "TodoViewController.h"
#import "TodoDetailViewController.h"

@interface TodolistViewController () <CheckBoxTappedProtocol, OperationProtocol>

@property(strong) NSMutableArray *todolists;
@property(strong) UITableView *tableView;

@end

@implementation TodolistViewController

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
        NSString *url = [NSString stringWithFormat:@"%ld/project/%ld/todolist", (long)currentTeamId, self.projectId];
        [HttpConnection initWithRequestURL:url
                                httpMethod:@"get"
                               requestDate:nil
                             successAction:^(id todolists) {
                                 self.todolists = todolists;
                                 self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
                                 self.tableView.delegate = self;
                                 self.tableView.dataSource = self;
                                 [self.view addSubview:self.tableView];
                             }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.todolists objectAtIndex:section ] objectForKey:@"name" ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.todolists count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.todolists objectAtIndex:section ] objectForKey:@"todos" ] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TodolistView *label =[[TodolistView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    label.tintColor = TITLE_COLOR;
    label.name = [[self.todolists objectAtIndex:section ] objectForKey:@"name" ];
    label.description = [[self.todolists objectAtIndex:section ] objectForKey:@"description" ];
    label.todolistId = [[[self.todolists objectAtIndex:section ] objectForKey:@"id" ] integerValue];
    label.delegate = self;
    
    UIButton *addButtom= [[UIButton alloc] initWithFrame:CGRectMake(270, 15, 40, 15)];
    addButtom.titleLabel.font = TODO_BUTTON_FONT;
    [addButtom setTitle:@"添加" forState:UIControlStateNormal];
    [addButtom setTitleColor:EDITOR_BUTTON_COLOR forState:UIControlStateNormal];
    [addButtom addTarget:label action:@selector(doAdd:) forControlEvents:UIControlEventTouchUpInside];
    [label addSubview:addButtom];
    return label;
}

- (void) doAdd:(NSInteger) todolistId
{
    TodoViewController *todoViewController = [[TodoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    todoViewController.projectId = self.projectId;
    todoViewController.todolistId = todolistId;
    [rootViewController.navigationController pushViewController:todoViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"todoCell";
    TodoCell *cell = (TodoCell *)[self.tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil) {
        cell = [[TodoCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:kCustomCellID];
        cell.delegate = self;
    }
    
    NSDictionary *item = [[[self.todolists objectAtIndex:indexPath.section ] objectForKey:@"todos" ] objectAtIndex:indexPath.row];
    
    cell.todoView.name = [item objectForKey:@"description"];
    cell.todoView.worker = [item objectForKey:@"worker"];
    BOOL done = [[item objectForKey:@"done"] boolValue];
    cell.checkBox.checked = done;
    NSString *deadline = [item objectForKey:@"deadline"];
    if ([deadline length] > 0) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *myDate = [df dateFromString:deadline];
        cell.todoView.deadline = myDate;
    }
    
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

- (void)updateAccessibilityForCell:(TodoCell*)cell
{
    // The cell's accessibilityValue is the Checkbox's accessibilityValue.
    cell.accessibilityValue = cell.checkBox.accessibilityValue;
}

- (void) checkBoxTapped:(id)sender forEvent:(UIEvent*)event
{
    TodoCell *cell = sender;
    BOOL checked = cell.checkBox.checked;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Session *session = [Session getInstance];
    NSInteger currentTeamId = session.teamId;
    NSDictionary *item = [[[self.todolists objectAtIndex:indexPath.section ] objectForKey:@"todos" ] objectAtIndex:indexPath.row];
    NSInteger todoId = [[item objectForKey:@"id"] integerValue];
    
    NSString *url = [NSString stringWithFormat:@"%ld/project/%ld/todo/%ld/toggle", (long)currentTeamId, self.projectId, (long)todoId];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithBool:checked], @"flag", nil];
    
    [HttpConnection initWithRequestURL:url
                            httpMethod:@"get"
                           requestDate:requestData
                         successAction:^(id todolists) {
                         }];
}

-(void) addObject:(NSDictionary *) todo withType:(ObjectType)type
{
    switch (type) {
        case TODO:
            for (NSDictionary *todolist in self.todolists) {
                NSInteger todolistId = [[todo objectForKey:@"listId"] integerValue];
                NSInteger currentTodolistId =[[todolist objectForKey:@"id"] integerValue];
                if (todolistId ==  currentTodolistId) {
                    [[todolist objectForKey:@"todos"] addObject:todo];
                    [self.tableView reloadData];
                    return;
                }
            }
            break;
        case TODO_LIST:
            [self.todolists addObject:todo];
            [self.tableView reloadData];
        default:
            break;
    }
    
}

-(void) updateObject:(NSDictionary *) todo withType:(ObjectType)type
{
    NSInteger todolistId = [[todo objectForKey:@"listId"] integerValue];
    NSInteger todoId = [[todo objectForKey:@"id"] integerValue];
    
    for (NSDictionary *todolist in self.todolists) {
        NSInteger currentTodolistId =[[todolist objectForKey:@"id"] integerValue];
        if (todolistId ==  currentTodolistId) {
            NSMutableArray *todos = [todolist objectForKey:@"todos"];
            for (int i = 0 ; i < [todos count]; ++i) {
                NSDictionary *currentTodo = [todos objectAtIndex:i];
                NSInteger currentTodoId =[[currentTodo objectForKey:@"id"] integerValue];
                if(currentTodoId == todoId) {
                    todos[i] = todo;
                    [self.tableView reloadData];
                    return;
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *todo = [[[self.todolists objectAtIndex:indexPath.section] objectForKey:@"todos"] objectAtIndex:indexPath.row];
    TodoDetailViewController *detailViewController = [[TodoDetailViewController alloc] init];
    detailViewController.todo = todo;
    [self.rootViewController.navigationController pushViewController:detailViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
