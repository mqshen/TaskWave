//
//  ProjectViewController.m
//  ZenTask
//
//  Created by GoldRatio on 5/26/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectTableCell.h"
#import "Session.h"
#import "HttpConnection.h"
#import "TodolistViewController.h"
#import "MessageViewController.h"
#import "TabView.h"
#import "TodolistAddViewController.h"
#import "MessageAddViewController.h"

@interface ProjectViewController ()

@property (nonatomic, strong) NSDictionary *project;
@property (strong) UIView *contentView;
@property (strong) TabView *tabView;
@property (strong) UIViewController<ObjectAddProtocol> *lastViewController;

@end

@implementation ProjectViewController

@synthesize projectId = _projectId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setProjectId:(int) value
{
    if (_projectId != value) {
        _projectId = value;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"项目";
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(0, 60, 320, 45);
    NSArray *names = [[NSArray alloc] initWithObjects:@"任务", @"讨论", @"文档", @"文件", nil];
    self.tabView = [[TabView alloc] initWithFrame:rect andTabNames:names];
    self.tabView.delegate = self;
    //tabView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tabView];
    // Do any additional setup after loading the view.
    CGFloat height = self.view.frame.size.height - 105;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, 320, height)];
    [self.view addSubview:self.contentView];
    
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"add" ofType:@"png"];
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(startAdd)];
    //[self.view addSubview:menuButton];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    [self.tabView setSelect:0];
    
}

- (void) startAdd
{
    if (self.tabView.selected == 0) {
        TodolistAddViewController *addViewController = [[TodolistAddViewController alloc] init];
        addViewController.projectId = self.projectId;
        [self.navigationController pushViewController:addViewController animated:YES];
    }
    else if (self.tabView.selected == 1) {
        MessageAddViewController *addViewController = [[MessageAddViewController alloc] init];
        addViewController.projectId = self.projectId;
        [self.navigationController pushViewController:addViewController animated:YES];
    }
}


- (void) tabselect:(NSUInteger) index
{
    if (self.lastViewController) {
        [self.lastViewController.view removeFromSuperview];
    }
    if (index == 0 ) {
        TodolistViewController *todolistView = [[TodolistViewController alloc] init];
        todolistView.view.frame = self.contentView.bounds;
        todolistView.projectId = self.projectId;
        self.lastViewController = todolistView;
        [self.contentView addSubview:todolistView.view];
        todolistView.rootViewController = self;
    }
    else if(index == 1) {
        MessageViewController *messageViewController = [[MessageViewController alloc] init];
        messageViewController.view.frame = self.contentView.bounds;
        messageViewController.projectId = self.projectId;
        self.lastViewController = messageViewController;
        [self.contentView addSubview:messageViewController.view];
        messageViewController.rootViewController = self;
    }
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

-(void) addObject:(id) object withType:(ObjectType) type
{
    [self.lastViewController addObject:object withType:type];
}

-(void) updateObject:(id) object withType:(ObjectType) type
{
    [self.lastViewController updateObject:object withType:type];
}

@end
