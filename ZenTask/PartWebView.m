//
//  PartWebView.m
//  ZenTask
//
//  Created by GoldRatio on 6/2/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "PartWebView.h"

@implementation PartWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 0;
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        self.clipsToBounds = YES;
        self.scalesPageToFit = NO;
        self.backgroundColor = [UIColor clearColor];
        self.scrollView.scrollEnabled = NO;
        self.scrollView.bounces = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) setContnet:(NSString *) content
{
    NSMutableString *html = [NSMutableString stringWithString:@"<html><head><title></title></head><body style=\"background:transparent;\">"];
    
    [html appendString:content];
    [html appendString:@"</body></html>"];
    
    
    [self loadHTMLString:[html description] baseURL:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
