//
//  CommentCell.m
//  ZenTask
//
//  Created by GoldRatio on 6/1/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "CommentCell.h"
#import "NSDate+format.h"

@implementation CommentCell

@synthesize avatorView;
@synthesize nameLabel;
@synthesize contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        avatorView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
        nameLabel = [[TwoLabel alloc] initWithFrame:CGRectMake(35, 0, 280, 20)];
        nameLabel.tintColor = TEXT_COLOR;
        
        
        [self addSubview:avatorView];
        [self addSubview:nameLabel];
    }
    return self;
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


-(void) setComment:(NSDictionary *) comment
{
    nameLabel.name = [[comment objectForKey:@"creator"] objectForKey:@"name"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    long createTime = [[comment objectForKey:@"createTime"] longValue];
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:createTime];
    nameLabel.description = [myDate format];
//    NSString *content = [comment objectForKey:@"content"];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:TEXT_FONT, NSFontAttributeName,
//                                ACTIVE_COLOR, NSForegroundColorAttributeName, nil];
//    CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
//    CGRect newFrame = [content boundingRectWithSize:maximumLabelSize
//                                          options:NSStringDrawingUsesLineFragmentOrigin
//                                       attributes:attributes
//                                         context:nil];
//    
//    NSMutableString *html = [NSMutableString stringWithString:@"<html><head><title></title></head><body style=\"background:transparent;\">"];
//    
//    //continue building the string
//    [html appendString:[comment objectForKey:@"content"]];
//    [html appendString:@"</body></html>"];
//    
//    
//    [contentLabel loadHTMLString:[html description] baseURL:nil];
//    CGRect frame =  contentLabel.frame;
//    frame.size.height = newFrame.size.height;
//    contentLabel.frame = frame;
}



@end
