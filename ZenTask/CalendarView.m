//
//  CalendarView.m
//  ZenTask
//
//  Created by GoldRatio on 6/6/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "CalendarView.h"
#import "Checkbox.h"

#define Calendar_Padding 15

@implementation CalendarView

@synthesize date;
@synthesize todos = _todos;
@synthesize events = _events;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setTodos:(NSArray *)todos
{
    CGRect frame = CGRectMake(90, 5, 225, 20);
    if (todos != _todos) {
        _todos = todos;
        for (NSDictionary *todo in _todos) {
            
            Checkbox *checkbox = [[Checkbox alloc] initWithFrame:CGRectMake(70, frame.origin.y, 20, 20)];
            checkbox.backgroundColor = [UIColor clearColor];
            NSString *color = [[todo objectForKey:@"project"] objectForKey:@"color"];
            if (color) {
                unsigned long red = strtoul([color UTF8String], 0, 16);
                UIColor *checkColor = UIColorFromRGB(red);
                checkbox.tintColor = checkColor;
            }
            [self addSubview:checkbox];
            
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.font = TEXT_FONT;
            label.text = [todo objectForKey:@"description"];
            frame.origin.y += 25.f;
            
            [self addSubview:label];
        }
    }
}

-(void)setEvents:(NSArray *)events
{
    CGRect frame = CGRectMake(75, 5, 225, 20);
    frame.origin.y += 25.f * [_todos count];
    if (events != _events) {
        _events = events;
        for (NSDictionary *event in _events) {
            
            NSString *startTime = [event objectForKey:@"startTime"];
            NSString *startDate = [event objectForKey:@"startDate"];
            NSString *endDate = [event objectForKey:@"endDate"];
            
            NSMutableString *time = [[NSMutableString alloc] init];
            if (startTime && [startTime length] > 0) {
                [time appendString:startTime];
            }
            if ([startDate compare:endDate] != 0) {
                [time appendString:@"至"];
                [time appendString:[endDate substringFromIndex:5]];
            }
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:frame];
            timeLabel.text = time;
            NSString *color = [[event objectForKey:@"target"] objectForKey:@"color"];
            unsigned long red = strtoul([color UTF8String], 0, 16);
            UIColor *timeColor = UIColorFromRGB(red);
            timeLabel.textColor = timeColor;
            timeLabel.font = SMALL_TEXT_FONT;
            [self addSubview:timeLabel];
            if ([time length] > 0) {
                timeLabel.text = time;
            }
            else {
                timeLabel.text = @"全天";
            }
            frame.origin.y += 15;
            
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.font = TEXT_FONT;
            label.text = [event objectForKey:@"name"];
            frame.origin.y += 30.f;
            [self addSubview:label];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = TEXT_COLOR;
    if (self.tintColor) {
        color = self.tintColor;
    }
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:CALENDAR_MONTH_FONT, NSFontAttributeName,
                                CALENDAR_MONTH_COLOR, NSForegroundColorAttributeName, nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM"];
    NSString *month = [dateFormatter stringFromDate:date];
    
    
    [month drawAtPoint:CGPointMake(Calendar_Padding, 10) withAttributes:attributes];
    
    [dateFormatter setDateFormat:@"d"];
    NSString *day = [dateFormatter stringFromDate:date];
    
    NSDictionary *dayAttributes = [NSDictionary dictionaryWithObjectsAndKeys:CALENDAR_DAY_FONT, NSFontAttributeName,
                                TEXT_COLOR, NSForegroundColorAttributeName, nil];
    [day drawAtPoint:CGPointMake(Calendar_Padding, 26) withAttributes:dayAttributes];
    
    
    [dateFormatter setDateFormat:@"EEE"];
    NSString *weekday = [dateFormatter stringFromDate:date];
    
    NSDictionary *weekAttributes = [NSDictionary dictionaryWithObjectsAndKeys:CALENDAR_WEEKDAY_FONT, NSFontAttributeName,
                                   color, NSForegroundColorAttributeName, nil];
    [weekday drawAtPoint:CGPointMake(Calendar_Padding, 50) withAttributes:weekAttributes];
    
    
    
    CGSize size = self.bounds.size;
    
    CGContextSetStrokeColorWithColor(context, [LINE_COLOE CGColor]);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, Calendar_Padding, size.height);
    CGContextAddLineToPoint(context, size.width - Calendar_Padding, size.height);
    
    CGContextStrokePath(context);
    
    CGFloat height = 3.f;
    for (NSInteger i = 1; i < [_todos count]; ++i) {
        CGContextBeginPath(context);
        height += 25.f;
        CGContextMoveToPoint(context, 75, height);
        CGContextAddLineToPoint(context, size.width - Calendar_Padding - 5, height);
        CGContextStrokePath(context);
    }
    
    if ([_todos count] > 0 && [_events count] > 0) {
        CGContextBeginPath(context);
        height += 25.f;
        CGContextMoveToPoint(context, 75, height);
        CGContextAddLineToPoint(context, size.width - Calendar_Padding - 5, height);
        CGContextStrokePath(context);
    }
    
    for (NSInteger i = 1; i < [_events count]; ++i) {
        CGContextBeginPath(context);
        height += 45;
        CGContextMoveToPoint(context, 75, height);
        CGContextAddLineToPoint(context, size.width - Calendar_Padding - 5, height);
        CGContextStrokePath(context);
    }
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 60, 0);
    CGContextAddLineToPoint(context, 60, size.height);
    CGContextSetLineWidth(context, 5.0f);
    CGContextStrokePath(context);
}

@end
