//
//  MessageCell.m
//  ZenTask
//
//  Created by GoldRatio on 5/28/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

@synthesize nameLabel;
@synthesize descriptionLabel;
@synthesize imageView;
@synthesize userNameView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.imageView.layer setCornerRadius:20];
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
        
        self.userNameView = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 40, 20)];
        self.userNameView.textAlignment = NSTextAlignmentCenter;
        self.userNameView.font = SMALL_TEXT_FONT;
        [self.contentView addSubview:self.userNameView];
        
        CGRect labelFrame = CGRectMake(70, 10, 240, 20);
        self.nameLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [self.nameLabel setNumberOfLines:0];
        self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.nameLabel.font = H1_FONT;
        
        //self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //self.nameLabel.contentMode = UIViewContentModeRedraw;
        
        CGRect descriptLabelFrame = CGRectMake(70, 30, 240, 25);
        self.descriptionLabel = [[UILabel alloc] initWithFrame:descriptLabelFrame];
        self.descriptionLabel.font = H2_FONT;
        self.descriptionLabel.textColor = UNACTIVE_COLOR;
        
        //self.descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //self.descriptionLabel.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:self.descriptionLabel];
        
        [self.contentView addSubview:self.nameLabel];
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
@end
