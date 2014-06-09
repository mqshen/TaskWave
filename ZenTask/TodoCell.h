//
//  TodoCell.h
//  ZenTask
//
//  Created by GoldRatio on 5/27/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoView.h"
#import "Checkbox.h"

@interface TodoCell : UITableViewCell<CheckBoxTappedProtocol>

@property (strong) TodoView *todoView;
@property (nonatomic, strong) Checkbox *checkBox;
@property (weak) id<CheckBoxTappedProtocol> delegate;

@end
