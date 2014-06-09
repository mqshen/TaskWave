//
//  TodoCell.m
//  ZenTask
//
//  Created by GoldRatio on 5/27/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TodoCell.h"

@implementation TodoCell

@synthesize todoView;
@synthesize checkBox;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.checkBox = [[Checkbox alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
        self.checkBox.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.checkBox.backgroundColor = [UIColor whiteColor];
        self.checkBox.tintColor = ACTIVE_BACKGROUND_COLOR;
        [self.contentView addSubview:self.checkBox];
        [self.checkBox addTarget:self action:@selector(checkBoxTapped:forEvent:) forControlEvents:UIControlEventValueChanged];
        
        self.todoView = [[TodoView alloc] initWithFrame:CGRectMake(40, 0, 280, 45)];
        self.todoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.todoView.contentMode = UIViewContentModeRedraw;
        self.todoView.tintColor = TEXT_COLOR;
        
        [self.contentView addSubview:self.todoView];
        
    }
    return self;
}

- (void) checkBoxTapped:(id)sender forEvent:(UIEvent*)event
{
    [self.delegate checkBoxTapped:self forEvent: event];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
