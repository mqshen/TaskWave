//
//  TodoViewController.m
//  ZenTask
//
//  Created by GoldRatio on 5/29/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TodoViewController.h"
#import "UIPlaceHolderTextView.h"
#import "KeyBoardTopBar.h"
#import "DateSelectionViewController.h"
#import "WorkerSelectionViewController.h"
#import "Session.h"
#import "HttpConnection.h"
#import "ProjectViewController.h"


@interface TodoViewController () <UITextViewDelegate, DataSelectionViewControllerDelegate>

@property (strong) UIPlaceHolderTextView *descriptionText;
@property NSMutableArray *editFieldArray;     //存放视图中可编辑的控件
@property KeyBoardTopBar *keyboardbar;
@property UIViewController *dataSelectionViewController;
@property (assign) NSInteger currentSelection;
@property (strong) NSString *description;
@property (assign) NSInteger workerId;
@property (strong) NSDate *deadline;

@end

@implementation TodoViewController

@synthesize projectId;
@synthesize todolistId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.keyboardbar = [[KeyBoardTopBar alloc] init];
        [self.keyboardbar  setAllowShowPreAndNext:YES];
        [self.keyboardbar setTextFieldsArray:self.editFieldArray];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWasShown:)
//                                                     name:UIKeyboardWillShowNotification
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWasHidden:)
//                                                     name:UIKeyboardDidHideNotification
//                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"添加"
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:self
//                                                                  action:@selector(doAdd)];
//    //[self.view addSubview:menuButton];
//    self.navigationItem.rightBarButtonItem = menuButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) doAdd
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 80.f;
    }
    else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        self.descriptionText = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 60)];
        self.descriptionText.backgroundColor = [UIColor clearColor];
        [self.descriptionText setTintColor:[UIColor blackColor]];
        self.descriptionText.font = TEXT_FONT;
        self.descriptionText.placeholder = @"任务描述";
        [view addSubview:self.descriptionText];
        self.descriptionText.delegate = self;
        return view;
    }
    else {
        return nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *kCustomCellID = @"todoCell";
        UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCustomCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:kCustomCellID];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"指定任务负责人";
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"worker" ofType:@"png"];
            cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        }
        else {
            cell.textLabel.text = @"没有截至时间";
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"time" ofType:@"png"];
            cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        }
        return cell;
    }
    else {
        static NSString *kCustomCellID = @"addbutton";
        UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCustomCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:kCustomCellID];
        }
        
        cell.textLabel.text = @"添加";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
        
    }
    
    // Configure the cell...
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.keyboardbar showBar:textView];
    textView.inputAccessoryView = self.keyboardbar.view;
    return YES;
}

- (void)keyboardWasHidden:(UITextView *)textView {
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//| ----------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Find the cell being touched and update its checked/unchecked image.
    if (indexPath.section == 1) {
        NSString *description = self.descriptionText.text;
        NSString *deadline = nil;
        if (self.deadline ) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:COMMIT_DATE_FOMAT];
            deadline = [dateFormatter stringFromDate:self.deadline];
        }
        
        
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:description, @"description",
                                     [NSNumber numberWithInteger:self.todolistId], @"todolistId",
                                     [NSNumber numberWithInteger:self.workerId ], @"workerId",
                                     deadline, @"deadline",
                                     nil];
        Session *session = [Session getInstance];
        NSInteger currentTeamId = session.teamId;
        NSString *url = [NSString stringWithFormat:@"%ld/project/%ld/todo", (long)currentTeamId, (long)self.projectId];
        [HttpConnection initWithRequestURL:url
                                httpMethod:@"post"
                               requestDate:requestData
                             successAction:^(id todo) {
                                 NSArray *viewControllers = [self.navigationController viewControllers];
                                 ProjectViewController *projectViewController = [viewControllers objectAtIndex:[viewControllers count] -   2];
                                 [projectViewController addObject:todo withType:TODO];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }];

        
    }
    else {
        if (indexPath.row == 0) {
            WorkerSelectionViewController *workerSelectionViewController =[[WorkerSelectionViewController alloc] init];
            workerSelectionViewController.delegate = self;
            workerSelectionViewController.rootViewController = self;
            workerSelectionViewController.projectId = self.projectId;
            self.dataSelectionViewController = workerSelectionViewController;
            [workerSelectionViewController show];
        }
        else if(indexPath.row == 1) {
            DateSelectionViewController *dateSelectionViewController =[[DateSelectionViewController alloc] init];
            dateSelectionViewController.delegate = self;
            dateSelectionViewController.rootViewController = self;
            self.dataSelectionViewController = dateSelectionViewController;
            [dateSelectionViewController show];
        }
    }
    self.currentSelection = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) setData:(id) index
{
    if(self.currentSelection == 0) {
        self.workerId = [[index objectForKey:@"id"] integerValue];
        NSIndexPath *current = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:current];
        cell.textLabel.text = [index objectForKey:@"name"];
    }
    else if(self.currentSelection == 1) {
        self.deadline = index;
        NSIndexPath *current = [NSIndexPath indexPathForRow:1 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:current];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:ASSIGN_DATE_FOMAT];
        
        cell.textLabel.text = [dateFormatter stringFromDate:self.deadline];
        
    }
}


@end
