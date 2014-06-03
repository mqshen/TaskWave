//
//  SlideNavViewController.m
//  doudou
//
//  Created by GoldRatio on 4/24/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "SlideNavViewController.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "ViewControllerChangeDelegate.h"
#import "CRNavigationController.h"
#import "../MenuViewController.h"
#import "MainViewController.h"

#define MENU_DEFAULT_SLIDE_OFFSET 120
#define MENU_SLIDE_ANIMATION_DURATION .3
#define MENU_QUICK_SLIDE_ANIMATION_DURATION .18
#define MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION 800

@interface SlideNavViewController ()<ViewControllerChangeDelegate>

@property (nonatomic, assign) CGFloat landscapeSlideOffset;

@property (nonatomic, strong) UIViewController * centerViewController;

@property (nonatomic, strong) UIViewController * leftViewController;

@property (nonatomic, assign) CGPoint draggingPoint;

@property (nonatomic, assign) BOOL menuOpen;

@end

@implementation SlideNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCenterViewController:(UIViewController *)centerViewController
               leftViewController:(MenuViewController *)leftViewController
{
    NSParameterAssert(centerViewController);
    self = [super init];
    if(self){
        UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerViewController];
        
        self.centerViewController = centerNav;
        
        leftViewController.delegate = self;
        UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:leftViewController];
        self.leftViewController = leftNav;
        self.menuRevealAnimator = [[SlideNavigationContorllerAnimatorSlide alloc] init];
        
        
        
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"png"];
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(openMenu)];
        //[self.view addSubview:menuButton];
        centerViewController.navigationItem.leftBarButtonItem = menuButton;
        
        //[self.centerViewController.navigationItem setLeftBarButtonItem:menuButton animated:YES];
        
        centerNav.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        centerNav.view.layer.shadowRadius = 10;
        centerNav.view.layer.shadowOpacity = 1;
        centerNav.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
        centerNav.view.layer.shouldRasterize = YES;
        centerNav.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.menuOpen = false;
    }
    return self;
}

- (void) openMenu
{
    [self openMenuWithDuration:MENU_SLIDE_ANIMATION_DURATION andCompletion:nil];
}

- (void)moveToLocation:(CGFloat)location
{
	CGRect rect = self.centerViewController.view.frame;
    rect.origin.x =  location;
	self.centerViewController.view.frame = rect;
	[self updateMenuAnimation:self.leftViewController];
}

- (void)updateMenuAnimation:(UIViewController *) viewController
{
	CGFloat progress = self.centerViewController.view.frame.origin.x / (self.view.frame.size.width - MENU_DEFAULT_SLIDE_OFFSET);
//    if (self.menuOpen) {
//        progress = -progress;
//    }
	
	[self.menuRevealAnimator animateMenu:viewController withProgress:progress];
}

- (CGFloat)location
{
	CGRect rect = self.centerViewController.view.frame;
	UIInterfaceOrientation orientation = self.interfaceOrientation;
	
	if (UIInterfaceOrientationIsLandscape(orientation))
	{
		return (orientation == UIInterfaceOrientationLandscapeRight)
        ? rect.origin.y
        : rect.origin.y*-1;
	}
	else
	{
		return (orientation == UIInterfaceOrientationPortrait)
        ? rect.origin.x
        : rect.origin.x*-1;
	}
}

-(void) openMenuWithDuration:(float)duration andCompletion:(void (^)())completion
{
    [UIView animateWithDuration:duration
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 CGRect rect = self.view.frame;
						 CGFloat width = self.view.frame.size.width;
						 rect.origin.x = width - MENU_DEFAULT_SLIDE_OFFSET;
						 [self moveToLocation:rect.origin.x];
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
					 }];
    self.menuOpen = true;
}

-(void) closeMenuWithDuration:(float)duration andCompletion:(void (^)())completion
{
    //NSLog(@"close menu");
    [UIView animateWithDuration:duration
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self moveToLocation:0];
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
					 }];
    self.menuOpen = false;
}

- (void)closeMenuWithCompletion:(void (^)())completion
{
	[self closeMenuWithDuration:MENU_SLIDE_ANIMATION_DURATION andCompletion:completion];
}

- (void)openMenuWithCompletion:(void (^)())completion
{
	[self openMenuWithDuration:MENU_SLIDE_ANIMATION_DURATION andCompletion:completion];
}

-(void)panGestureCallback:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self.view];
    CGPoint velocity = [panGesture velocityInView:self.view];
	NSInteger movement = translation.x - self.draggingPoint.x;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.draggingPoint = translation;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGFloat interval = [self location];
            //NSLog(@"menuOpen:%d, movement:%d, interval:%f", self.menuOpen, movement, interval);
            interval += movement;
            
            
            if(self.menuOpen) {
                if (interval >= 0 && interval <= self.view.frame.size.width - MENU_DEFAULT_SLIDE_OFFSET)
                    [self moveToLocation:interval];
            }
            else {
                if (interval >= 0 && interval <= self.view.frame.size.width - MENU_DEFAULT_SLIDE_OFFSET)
                    [self moveToLocation:interval];
            }
            self.draggingPoint = translation;
            break;
        }
        case UIGestureRecognizerStateEnded:{
            NSInteger currentX = [self location];
            NSInteger positiveVelocity = abs(velocity.x);
            
            if (positiveVelocity >= MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION) {
                if(self.menuOpen) {
                    if (velocity.x < 0 ) {
                        [self closeMenuWithDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
                    }
                }
                else {
                    if (velocity.x > 0 ) {
                        [self openMenuWithDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
                    }
                }
            }
            else {
                if (currentX < (320 - MENU_DEFAULT_SLIDE_OFFSET)/2 )
                    [self closeMenuWithCompletion:nil];
                else
                    [self openMenuWithCompletion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            break;
        }
        default:
            break;
    }
}

-(void)setupGestureRecognizers {
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(panGestureCallback:)];
    //[pan setDelegate:self];
    [self.view addGestureRecognizer:pan];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                           action:@selector(tapGestureCallback:)];
//    //[tap setDelegate:self];
//    [self.view addGestureRecognizer:tap];
}

-(void)tapGestureCallback:(UITapGestureRecognizer *)tapGesture{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"test";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.leftViewController.view];
    [self.view addSubview:self.centerViewController.view];
    [self setupGestureRecognizers];
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


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void) changeViewController:(UIViewController *) viewController
{
    CGRect frame = self.centerViewController.view.frame;
    [self.centerViewController.view removeFromSuperview];
    
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"png"];
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(openMenu)];
        //[self.view addSubview:menuButton];
        viewController.navigationItem.leftBarButtonItem = menuButton;
    
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.centerViewController = centerNav;
    self.centerViewController.view.frame = frame;
    
    centerNav.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    centerNav.view.layer.shadowRadius = 10;
    centerNav.view.layer.shadowOpacity = 1;
    centerNav.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    centerNav.view.layer.shouldRasterize = YES;
    centerNav.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [self.view addSubview:self.centerViewController.view];
    
    [self closeMenuWithCompletion:nil];
}

@end
