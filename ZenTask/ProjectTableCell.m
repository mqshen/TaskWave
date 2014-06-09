//
//  ProjectTableCell.m
//  ZenTask
//
//  Created by GoldRatio on 5/26/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "ProjectTableCell.h"

@implementation ProjectTableCell

@synthesize nameLabel;
@synthesize descriptionLabel;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(21, 21, 32, 32)];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"project" ofType:@"png"];
        self.imageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        [self.contentView addSubview:self.imageView];
        
        CGRect labelFrame = CGRectMake(70, 17, 200, 25);
        self.nameLabel = [[UILabel alloc] initWithFrame:labelFrame];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        
        //self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //self.nameLabel.contentMode = UIViewContentModeRedraw;
        
        CGRect descriptLabelFrame = CGRectMake(70, 34, 200, 25);
        self.descriptionLabel = [[UILabel alloc] initWithFrame:descriptLabelFrame];
        self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:7];
        self.descriptionLabel.textColor =  UIColorFromRGB(0x696969);
        
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
