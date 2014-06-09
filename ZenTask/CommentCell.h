//
//  CommentCell.h
//  ZenTask
//
//  Created by GoldRatio on 6/1/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoLabel.h"

@interface CommentCell : UITableViewCell

@property (strong) UIImageView *avatorView;
@property (strong) TwoLabel *nameLabel;
@property (strong) UIWebView *contentLabel;

-(void) setComment:(NSDictionary *) comment;

@end
