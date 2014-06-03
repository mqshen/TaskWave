//
//  TodoAddViewController.m
//  ZenTask
//
//  Created by GoldRatio on 6/3/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TodolistAddViewController.h"
#import "Session.h"
#import "HttpConnection.h"
#import "ProjectViewController.h"

@interface TodolistAddViewController () <UITextFieldDelegate>

@property(nonatomic, strong) UITextField *nameInputView;
@property(nonatomic, strong) UITextField *descriptionInputView;

@end

@implementation TodolistAddViewController

@synthesize projectId;

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    CGRect frame = CGRectMake(0, 80, 320, 45);
    
    CGRect labelFrame = CGRectMake(0, 0, 80, 45);
    
    CGRect inputFrame = CGRectMake(85, 0, 220, 45);
    
    UIView *itemView = [[UIView alloc] initWithFrame:frame];
    itemView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *labelView = [[UILabel alloc] initWithFrame:labelFrame];
    labelView.text = @"名称";
    labelView.textAlignment = NSTextAlignmentRight;
    //[labelView setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    [itemView addSubview:labelView];
    
    self.nameInputView = [[UITextField alloc] initWithFrame:inputFrame];
    self.nameInputView.tintColor = [UIColor blackColor];
    [itemView addSubview:self.nameInputView];
    self.nameInputView.delegate = self;
    
    [self.view addSubview:itemView];
    
    frame.origin.y += 60;
    itemView = [[UIView alloc] initWithFrame:frame];
    itemView.backgroundColor = [UIColor whiteColor];
    
    labelView = [[UILabel alloc] initWithFrame:labelFrame];
    labelView.text = @"描述";
    labelView.textAlignment = NSTextAlignmentRight;
    //[labelView setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    [itemView addSubview:labelView];
    
    self.descriptionInputView = [[UITextField alloc] initWithFrame:inputFrame];
    self.descriptionInputView.tintColor = [UIColor blackColor];
    [itemView addSubview:self.descriptionInputView];
    self.descriptionInputView.delegate = self;
    
    [self.view addSubview:itemView];
    
    
    
    frame.origin.y += 80;
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:frame];
    
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    //[confirmButton setTitleColor:UIColorFromRGB(0X88D86C) forState:UIControlStateNormal];
    //[confirmButton.layer setMasksToBounds:YES];
    //[confirmButton.layer setBorderColor:UIColorFromRGB(0X88D86C).CGColor];
    confirmButton.backgroundColor = UIColorFromRGB(0xff0000);
    
    [confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) confirm
{
    Session *session = [Session getInstance];
    NSInteger currentTeamId = session.teamId;
    
    NSString *url = [NSString stringWithFormat:@"%d/project/%d/todolist", currentTeamId, self.projectId];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys: self.nameInputView.text, @"name",
                                 self.descriptionInputView.text, @"description",
                                 nil];
    
    [HttpConnection initWithRequestURL:url
                            httpMethod:@"post"
                           requestDate:requestData
                         successAction:^(id todolist) {
                             NSArray *viewControllers = [self.navigationController viewControllers];
                             ProjectViewController *projectViewController = [viewControllers objectAtIndex:[viewControllers count] -   2];
                             [projectViewController addObject:todolist withType:TODO_LIST];
                             [self.navigationController popViewControllerAnimated:YES];
                         }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
