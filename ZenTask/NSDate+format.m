//
//  NSDate.m
//  ZenTask
//
//  Created by GoldRatio on 6/1/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "NSDate+format.h"

@implementation NSDate(format)

- (NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:ASSIGN_DATE_FOMAT];
    return [dateFormatter stringFromDate:self];
}

@end
