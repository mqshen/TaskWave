//
//  LoginViewController.m
//  ZenTask
//
//  Created by GoldRatio on 5/25/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpConnection.h"
#import "Session.h"
#import "SlideNavViewController.h"
#import "MainViewController.h"
#import "MenuViewController.h"
#import "CalendarViewController.h"


@interface LoginViewController ()

@property(nonatomic, strong) UITextField *emailView;
@property(nonatomic, strong) UITextField *passwordView;

@end

@implementation LoginViewController

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
    
    self.title = @"登录";
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.frame];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"bg" ofType:@"png"];
    background.image =[[UIImage alloc] initWithContentsOfFile:imagePath];
    [self.view addSubview:background];
    
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 40)];
    logoLabel.font = [UIFont fontWithName:@"Helvetica" size:40];
    logoLabel.textColor = [UIColor whiteColor];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    logoLabel.text = @"ZenTask";
    [self.view addSubview:logoLabel];
    
    CGRect frame = CGRectMake(0, 110, 320, 45);
    
    CGRect labelFrame = CGRectMake(0, 0, 80, 45);
    
    CGRect inputFrame = CGRectMake(85, 0, 220, 45);
    
    UIView *itemView = [[UIView alloc] initWithFrame:frame];
    itemView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *labelView = [[UILabel alloc] initWithFrame:labelFrame];
    labelView.text = @"邮箱:";
    labelView.textAlignment = NSTextAlignmentRight;
    //[labelView setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    [itemView addSubview:labelView];
    
    
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"png"];
    self.emailView = [[UITextField alloc] initWithFrame:inputFrame];
    self.emailView.tintColor = [UIColor blackColor];
    self.emailView.keyboardType = UIKeyboardTypeEmailAddress;
    [itemView addSubview:self.emailView];
    //self.emailView.text = @"goldratio87@gmail.com";
    self.emailView.text = @"mqshen@126.com";
    self.emailView.delegate = self;
    
    [self.view addSubview:itemView];
    
    frame.origin.y += 50;
    itemView = [[UIView alloc] initWithFrame:frame];
    itemView.backgroundColor = [UIColor whiteColor];
    
    UILabel *passwdLabelView = [[UILabel alloc] initWithFrame:labelFrame];
    passwdLabelView.text = @"密码:";
    passwdLabelView.textAlignment = NSTextAlignmentRight;
    //[labelView setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    [itemView addSubview:passwdLabelView];
    
    
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"png"];
    self.passwordView = [[UITextField alloc] initWithFrame:inputFrame];
    self.passwordView.secureTextEntry = YES;
    self.passwordView.tintColor = [UIColor blackColor];
    [itemView addSubview:self.passwordView];
    self.passwordView.text = @"111111";
    self.passwordView.delegate = self;
    
    
    [self.view addSubview:itemView];
    
    frame.origin.y += 80;
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:frame];
    
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    //[confirmButton setTitleColor:UIColorFromRGB(0X88D86C) forState:UIControlStateNormal];
    //[confirmButton.layer setMasksToBounds:YES];
    //[confirmButton.layer setBorderColor:UIColorFromRGB(0X88D86C).CGColor];
    confirmButton.backgroundColor = BUTTON_COLOR;
    
    [confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) confirm
{
    NSString *email = self.emailView.text;
    NSString *password = self.passwordView.text;
    NSDictionary  *loginData = [NSDictionary  dictionaryWithObjectsAndKeys:
                                password,@"password",
                                email,@"email",
                                nil];
    [HttpConnection initWithRequestURL:@"login"
                            httpMethod:@"post"
                           requestDate:loginData
                         successAction:^(NSDictionary* team) {
                             Session *session = [Session getInstance];
                             session.projects = [team objectForKey:@"projects"];
                             session.teamId = [[team objectForKey:@"teamId"] intValue];
                             MainViewController *vc = [[MainViewController alloc] init];
                             //CalendarViewController *vc = [[CalendarViewController alloc] init];
                             MenuViewController *leftMenu = [[MenuViewController alloc] init];
                             //leftMenu.view.backgroundColor = [UIColor blueColor];
                             SlideNavViewController *rootViewController = [[SlideNavViewController alloc] initWithCenterViewController:vc
                                                                                                                    leftViewController:leftMenu];
                             [self presentViewController:rootViewController animated:YES completion:nil];
                         }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
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
