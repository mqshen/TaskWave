//
//  TodoAddViewController.m
//  ZenTask
//
//  Created by GoldRatio on 6/3/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "MessageAddViewController.h"
#import "Session.h"
#import "HttpConnection.h"
#import "ProjectViewController.h"
#import "UIPlaceHolderTextView.h"
#import "KeyBoardTopBar.h"

@interface MessageAddViewController() <UITextFieldDelegate, UITextViewDelegate>

@property(nonatomic, strong) UITextField *nameInputView;
@property(nonatomic, strong) UIPlaceHolderTextView *descriptionInputView;
@property KeyBoardTopBar *keyboardbar;

@end

@implementation MessageAddViewController

@synthesize projectId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.keyboardbar = [[KeyBoardTopBar alloc] init];
        [self.keyboardbar  setAllowShowPreAndNext:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    CGRect frame = CGRectMake(0, 80, 320, 45);
    
    CGRect inputFrame = CGRectMake(10, 0, 300, 45);
    
    UIView *itemView = [[UIView alloc] initWithFrame:frame];
    itemView.backgroundColor = [UIColor whiteColor];
    
    
    self.nameInputView = [[UITextField alloc] initWithFrame:inputFrame];
    self.nameInputView.placeholder = @"主题";
    self.nameInputView.tintColor = [UIColor blackColor];
    [itemView addSubview:self.nameInputView];
    self.nameInputView.delegate = self;
    
    [self.view addSubview:itemView];
    
    frame.origin.y += 60;
    frame.size.height = 80;
    itemView = [[UIView alloc] initWithFrame:frame];
    itemView.backgroundColor = [UIColor whiteColor];
    
    inputFrame.size.height = 80;
    self.descriptionInputView = [[UIPlaceHolderTextView alloc] initWithFrame:inputFrame];
    [self.descriptionInputView setTintColor:[UIColor blackColor]];
    self.descriptionInputView.delegate = self;
    self.descriptionInputView.placeholder = @"说点什么";
    [itemView addSubview:self.descriptionInputView];
    self.descriptionInputView.delegate = self;
    
    [self.view addSubview:itemView];
    
    frame.origin.y += 100;
    frame.size.height = 45;
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:frame];
    
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    //[confirmButton setTitleColor:UIColorFromRGB(0X88D86C) forState:UIControlStateNormal];
    //[confirmButton.layer setMasksToBounds:YES];
    //[confirmButton.layer setBorderColor:UIColorFromRGB(0X88D86C).CGColor];
    confirmButton.backgroundColor = BUTTON_COLOR;
    
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
    long currentTeamId = session.teamId;
    
    NSString *url = [NSString stringWithFormat:@"%ld/project/%d/message", currentTeamId, self.projectId];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys: self.nameInputView.text, @"subject",
                                 self.descriptionInputView.text, @"content",
                                 nil];
    
    [HttpConnection initWithRequestURL:url
                            httpMethod:@"post"
                           requestDate:requestData
                         successAction:^(id todolist) {
                             NSArray *viewControllers = [self.navigationController viewControllers];
                             ProjectViewController *projectViewController = [viewControllers objectAtIndex:[viewControllers count] -   2];
                             [projectViewController addObject:todolist withType:MESSAGE];
                             [self.navigationController popViewControllerAnimated:YES];
                         }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.keyboardbar showBar:textView];
    textView.inputAccessoryView = self.keyboardbar.view;
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
