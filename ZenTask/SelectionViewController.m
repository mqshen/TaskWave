//
//  SelectionViewController.m
//  ZenTask
//
//  Created by GoldRatio on 5/30/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "SelectionViewController.h"

@interface SelectionViewController ()

@property (nonatomic, strong) UIButton *cancelButtom;
@property (nonatomic, strong) UIButton *confirmButtom;

@end

@implementation SelectionViewController

@synthesize delegate;
@synthesize rootViewController;
@synthesize backgroundView;
@synthesize selectedData = _selectedData;
@synthesize dataPicketContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 320, 230);
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titleView.backgroundColor = UIColorFromRGB(0xff0000);
    
    self.cancelButtom = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [self.cancelButtom setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButtom addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.cancelButtom];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 30)];
    titleLabel.text = @"时间";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    
    self.confirmButtom = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 60, 30)];
    [self.confirmButtom setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButtom addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.confirmButtom];
    
    // Do any additional setup after loading the view.
    dataPicketContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 320, 200)];
    dataPicketContainer.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:titleView];
    [self.view addSubview:dataPicketContainer];
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


- (void) close
{
    CGFloat damping = 1.0f;
    CGFloat duration = 0.3f;
    if(!self.disableBouncingWhenShowing) {
        damping = 0.6f;
        duration = 1.0f;
    }
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:damping
          initialSpringVelocity:1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.backgroundView.alpha = 0;
                         CGRect viewFrame = self.view.frame;
                         viewFrame.origin.y += self.view.frame.size.height;
                         self.view.frame = viewFrame;
                     }
                     completion:^(BOOL finished) {
                         [self.backgroundView removeFromSuperview];
                         [self.view removeFromSuperview];
                     }
     ];
}

- (void) show
{
    self.backgroundView.alpha = 0;
    [rootViewController.view addSubview:self.backgroundView];
    backgroundView.frame = rootViewController.view.frame;
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = rootViewController.view.frame.size.height;
    self.view.frame = frame;
    
    [rootViewController.view addSubview:self.view];
    
    
    CGFloat damping = 1.0f;
    CGFloat duration = 0.3f;
    if(!self.disableBouncingWhenShowing) {
        damping = 0.6f;
        duration = 1.0f;
    }
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:damping
          initialSpringVelocity:1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.backgroundView.alpha = 1;
                         CGRect viewFrame = self.view.frame;
                         viewFrame.origin.y -= self.view.frame.size.height;
                         self.view.frame = viewFrame;
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}


- (void) confirm:(id) sender
{
    [delegate setData:_selectedData];
    [self close];
}

- (void) cancel:(id) sender
{
}


@end
