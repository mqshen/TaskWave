//
//  CalendarViewController.m
//  ZenTask
//
//  Created by GoldRatio on 6/6/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "CalendarViewController.h"
#import "UILoopTableView.h"
#import "CalendarView.h"
#import "Session.h"
#import "HttpConnection.h"

@interface CalendarViewController () <UILoopTableViewDelegate, UILoopTableViewDataSource> {
    
}

@property (strong) NSDate *currentDate;
@property (strong) UILoopTableView *loopview;
@property (strong) NSMutableDictionary *events;
@property (strong) NSMutableDictionary *todos;
@property (strong) NSDateFormatter *dateFormatter;
@property (strong) NSDate *startDate;
@property (strong) NSDate *endDate;

@end

@implementation CalendarViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currentDate = [NSDate date];
        _events = [[NSMutableDictionary alloc] init];
        _todos = [[NSMutableDictionary alloc] init];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSUInteger timeComps = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit);
        NSDateComponents *comps = [gregorian components:timeComps fromDate:_currentDate];
        [comps setDay:1];
        NSDate *startDate = [gregorian dateFromComponents:comps];
        [comps setMonth:([comps month] + 1 )];
        NSDate *endDate = [gregorian dateFromComponents:comps];
        
        [self getEventsWithStartDate:startDate andEndDate:endDate];
        _startDate = startDate;
        _endDate = endDate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"日历";
    // Do any additional setup after loading the view.
}

- (void)getEventsWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    Session *session = [Session getInstance];
    long currentTeamId = session.teamId;
    
    
    NSString *url = [NSString stringWithFormat:@"%ld/event", (long)currentTeamId];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [_dateFormatter stringFromDate:startDate], @"startDate",
                                 [_dateFormatter stringFromDate:endDate], @"endDate",
                                 nil];
    
    [HttpConnection initWithRequestURL:url
                            httpMethod:@"get"
                           requestDate:requestData
                         successAction:^(id events) {
                             for (NSDictionary *todo in [events objectForKey:@"todos"]) {
                                 NSString *key = [todo objectForKey:@"deadline"];
                                 NSMutableArray *todos = [_todos objectForKey:key];
                                 if (!todos) {
                                     todos = [[NSMutableArray alloc] init];
                                     [_todos setObject:todos forKey:key];
                                 }
                                 [todos addObject:todo];
                             }
                             for (NSDictionary *event in [events objectForKey:@"events"]) {
                                 NSString *key = [event objectForKey:@"startDate"];
                                 NSMutableArray *events = [_events objectForKey:key];
                                 if (!events) {
                                     events = [[NSMutableArray alloc] init];
                                     [_events setObject:events forKey:key];
                                 }
                                 [events addObject:event];
                             }
                             if (!_loopview) {
                                 _loopview = [[UILoopTableView alloc] initWithFrame:self.view.frame];
                                 _loopview.delegate = self;
                                 _loopview.dataSource = self;
                                 _loopview.backgroundColor = UIColorFromRGB(0xF1F1F1);
                                 [self.view addSubview:_loopview];
                             }
                         }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UILoopTableView *)tableView heightForRowAtIndex:(NSNumber *)index{
    NSInteger row = [index integerValue];
    NSDate *date = [_currentDate dateByAddingTimeInterval: 60 * 60 * 24 * row];
    NSString *key = [_dateFormatter stringFromDate:date];
    NSInteger todoNum = [[_todos objectForKey:key] count];
    NSInteger eventNum = [[_events objectForKey:key] count];
    CGFloat number = MAX(74.f, 25.f * todoNum + 45.f * eventNum);
    if(fabs(row % 30) ==10) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSUInteger timeComps = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit);
        NSDateComponents *comps = [gregorian components:timeComps fromDate:_currentDate];
        [comps setDay:1];
    
        if (row < 0) {
            [comps setMonth:([comps month] + row / 30 )];
            NSDate *startDate = [gregorian dateFromComponents:comps];
            if ([startDate compare:_startDate] < 0) {
                [self getEventsWithStartDate:startDate andEndDate:_startDate];
                _startDate = startDate;
            }
        }
        else {
            [comps setMonth:([comps month] + row / 30 + 1 )];
            NSDate *endDate = [gregorian dateFromComponents:comps];
            if ([endDate compare:_endDate] > 0) {
                [self getEventsWithStartDate:_endDate andEndDate:endDate];
                _endDate = endDate;
            }
        }
    }
    return number;
}

- (NSInteger) numberOfRowsInTableView:(UILoopTableView *)tableView
{
    // Return the number of rows in the section.
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)indexPath
{
    static NSString *kCustomCellID = @"messageCell";
    CalendarView *cell = (CalendarView *)[self.loopview dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil) {
        cell = [[CalendarView alloc] initWithFrame:CGRectMake(0, 0, 320, 74)];
        cell.tintColor = TEXT_COLOR;
    }
    NSDate *date = [_currentDate dateByAddingTimeInterval: 60 * 60 * 24 * indexPath];
    NSString *key = [_dateFormatter stringFromDate:date];
    NSArray *todos = [_todos objectForKey:key];
    NSArray *events = [_events objectForKey:key];
    
    cell.date = date;
    cell.todos = todos;
    cell.events = events;
    
    return cell;
    // Configure the cell...
}

- (void) tableView:(UILoopTableView *)tableView gestureDidChange:(UIPanGestureRecognizer *)panGesture
{
    [delegate panGestureCallback:panGesture];
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
