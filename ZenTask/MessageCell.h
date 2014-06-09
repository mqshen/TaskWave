//
//  MessageCell.h
//  ZenTask
//
//  Created by GoldRatio on 5/28/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *userNameView;

@end
