//
//  KeyBoardTopBar.h
//  ZenTask
//
//  Created by GoldRatio on 5/29/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyBoardTopBar : NSObject {
    UIToolbar       *view;                       //工具条
    NSArray         *textFields;                 //输入框数组
    BOOL            allowShowPreAndNext;         //是否显示上一项、下一项
    UIBarButtonItem *prevButtonItem;             //上一项按钮
    UIBarButtonItem *nextButtonItem;             //下一项按钮
    UIBarButtonItem *hiddenButtonItem;           //隐藏按钮
    UIBarButtonItem *spaceButtonItem;            //空白按钮
    id currentTextField;           //当前输入框
}
@property(nonatomic,retain) UIToolbar *view;

-(id)init;
-(void)setAllowShowPreAndNext:(BOOL)isShow;
-(void)setTextFieldsArray:(NSArray *)array;
-(void)showPrevious;
-(void)showNext;
-(void)showBar:(id)textField;
-(void)hiddenKeyBoard;

@end
