//
//  MenuViewController.m
//  doudou
//
//  Created by GoldRatio on 4/24/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "CalendarViewController.h"

@interface MenuViewController ()

@property (nonatomic, assign) int menuIndex;

@end

@implementation MenuViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.menuIndex = 0;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(0, 65, 200, 45);
    
    CGRect imageFrame = CGRectMake(0, 0, 60, 45);
    CGRect labelFrame = CGRectMake(60, 0, 100, 45);
    
    UIView *itemView = [[UIView alloc] initWithFrame:frame];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 45.0f, itemView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [itemView.layer addSublayer:bottomBorder];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image =[[UIImage alloc] initWithContentsOfFile:imagePath];
    [itemView addSubview:imageView];
    
    UILabel *labelView = [[UILabel alloc] initWithFrame:labelFrame];
    labelView.text = @"首页";
    [labelView setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    labelView.textAlignment = UIViewContentModeCenter;
    [itemView addSubview:labelView];
    
    [self.view addSubview:itemView];
    
    
    
    frame.origin.y += 45;
    itemView = [[UIView alloc] initWithFrame:frame];
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 45.0f, itemView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [itemView.layer addSublayer:bottomBorder];
    
    imagePath = [[NSBundle mainBundle] pathForResource:@"record" ofType:@"png"];
    imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image =[[UIImage alloc] initWithContentsOfFile:imagePath];
    [itemView addSubview:imageView];
    
    labelView = [[UILabel alloc] initWithFrame:labelFrame];
    labelView.text = @"日历";
    [labelView setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    labelView.textAlignment = UIViewContentModeCenter;
    [itemView addSubview:labelView];
    
    [self.view addSubview:itemView];
    
    
    frame.origin.y += 45;
    itemView = [[UIView alloc] initWithFrame:frame];
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 45.0f, itemView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [itemView.layer addSublayer:bottomBorder];
    
    imagePath = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"png"];
    imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image =[[UIImage alloc] initWithContentsOfFile:imagePath];
    [itemView addSubview:imageView];
    
    labelView = [[UILabel alloc] initWithFrame:labelFrame];
    labelView.text = @"设置";
    [labelView setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    labelView.textAlignment = UIViewContentModeCenter;
    [itemView addSubview:labelView];
    
    [self.view addSubview:itemView];
    
    
    float height = self.view.frame.size.height;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height - 40, 180, 10)];
    infoLabel.text = @"有任何建议，或使用中遇到问题，请联系";
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [infoLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:8]];
    [self.view addSubview:infoLabel];
    
    
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height - 30, 180, 10)];
    menuLabel.text = @"mqshen@126.com";
    menuLabel.textAlignment = NSTextAlignmentCenter;
    menuLabel.textColor = [UIColor grayColor];
    [menuLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:8]];
    [self.view addSubview:menuLabel];

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.view addGestureRecognizer:tapGesture];

}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint point = [tapRecognizer locationInView:self.view];
    int index = (point.y - 65) / 45;
    if(index == self.menuIndex)
        return;
    self.menuIndex = index;
    UIViewController *viewController = nil;
    switch (index) {
        case 0:
            //[[[Config getInstance] viewController] reloadConfigTime];
            viewController = [[MainViewController alloc] init];//[[Config getInstance] viewController];
            [delegate changeViewController:viewController];
            break;
        case 1:
            viewController = [[CalendarViewController alloc] init];
            [delegate changeViewController:viewController];
            break;
//        case 2:
//            viewController = [[SettingViewController alloc] init];
//            [delegate changeViewController:viewController];
//            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
