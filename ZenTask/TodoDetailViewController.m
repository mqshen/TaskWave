//
//  TodoDetailViewController.m
//  ZenTask
//
//  Created by GoldRatio on 6/1/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TodoDetailViewController.h"
#import "Checkbox.h"
#import "NSDate+format.h"
#import "Session.h"
#import "HttpConnection.h"
#import "CommentCell.h"
#import "UIPlaceHolderTextView.h"
#import "KeyBoardTopBar.h"
#import "ProjectViewController.h"
#import "PartWebView.h"

@interface TodoDetailViewController () <UITextViewDelegate, UIWebViewDelegate>

@property (strong) NSMutableArray *comments;
@property KeyBoardTopBar *keyboardbar;
@property (strong) UIPlaceHolderTextView *textView;
@property (strong) Checkbox *checkBox;
@property (strong) NSMutableArray *webViewArray;
@property (atomic) int updateNum;

@end

@implementation TodoDetailViewController

@synthesize todo = _todo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.keyboardbar = [[KeyBoardTopBar alloc] init];
        [self.keyboardbar  setAllowShowPreAndNext:YES];
        self.updateNum = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.title = @"任务";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.comments count];
}
- (UIView *)getHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    self.checkBox = [[Checkbox alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [self.checkBox addTarget:self action:@selector(checkBoxTapped:forEvent:) forControlEvents:UIControlEventValueChanged];
    self.checkBox.backgroundColor = [UIColor whiteColor];
    self.checkBox.tintColor = ACTIVE_COLOR;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(50, 10, 250, 40)];
    nameLabel.text = [_todo objectForKey:@"description"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 45, 10, 10)];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"worker" ofType:@"png"];
    imageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    UILabel *workerLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 40, 230, 20)];
    workerLabel.font = SMALL_TEXT_FONT;
    workerLabel.text = [_todo objectForKey:@"worker"];
    
    UIImageView *deadLabelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 65, 10, 10)];
    NSString *deadlineImagePath = [[NSBundle mainBundle] pathForResource:@"time" ofType:@"png"];
    deadLabelImageView.image = [[UIImage alloc] initWithContentsOfFile:deadlineImagePath];
    
    UILabel *deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 60, 230, 20)];
    deadlineLabel.font = SMALL_TEXT_FONT;
    NSString *deadline = [_todo objectForKey:@"deadline"];
    if ([deadline length] > 0) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *myDate = [df dateFromString:deadline];
        deadlineLabel.text = [myDate format];
    }
    else {
        deadlineLabel.text = @"没有截至日期";
    }
    [view addSubview:self.checkBox];
    [view addSubview:nameLabel];
    [view addSubview:imageView];
    [view addSubview:workerLabel];
    [view addSubview:deadLabelImageView];
    [view addSubview:deadlineLabel];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, view.frame.size.height, view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [view.layer addSublayer:bottomBorder];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (UIView *)getFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 80)];
    [self.textView setTintColor:[UIColor blackColor]];
    self.textView.delegate = self;
    self.textView.placeholder = @"发表评论";
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.textView.layer setCornerRadius:3];
    self.textView.layer.masksToBounds = YES;
    
    UIView *attachView = [[UIView alloc] initWithFrame:CGRectMake(10, 95, 300, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 10, 10)];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"attachment" ofType:@"png"];
    imageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [attachView.layer setCornerRadius:3];
    attachView.layer.masksToBounds = YES;
    
    
    attachView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 20)];
    label.font = SMALL_TEXT_FONT;
    label.text = @"添加附件";
    [attachView addSubview:imageView];
    [attachView addSubview:label];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 145, 300, 40)];
    [sendButton setTitle:@"发表评论" forState:UIControlStateNormal];
    [sendButton addTarget:self
                   action:@selector(addComment:)
         forControlEvents:UIControlEventTouchDown];
    sendButton.titleLabel.font = TEXT_FONT;
    sendButton.titleLabel.textColor = [UIColor whiteColor];
    sendButton.backgroundColor = BUTTON_COLOR;
    [sendButton.layer setCornerRadius:3];
    sendButton.layer.masksToBounds = YES;
    
    
    [view addSubview:self.textView];
    [view addSubview:attachView];
    [view addSubview:sendButton];
    
    
    
    return view;
}

- (void)addComment:(id) sender
{
    NSString *content = self.textView.text;
    NSNumber *todoId = [_todo objectForKey:@"id"];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys: content, @"content",
                                 @"todo", @"commentableType",
                                 todoId, @"commentableId",
                                 nil];
    Session *session = [Session getInstance];
    NSInteger currentTeamId = session.teamId;
    NSInteger projectId = [[_todo objectForKey:@"projectId"] integerValue];
    NSString *url = [NSString stringWithFormat:@"%ld/project/%ld/comment", (long)currentTeamId, (long)projectId];
    [HttpConnection initWithRequestURL:url
                            httpMethod:@"post"
                           requestDate:requestData
                         successAction:^(id comment) {
                             [self.comments addObject:comment];
                             
                             NSString *content = [comment objectForKey:@"content"];
                             PartWebView *webView = [[PartWebView alloc] initWithFrame:CGRectMake(30, 15, 280, 20)];
                             [webView setContnet:content];
                             [self.webViewArray addObject:webView];
                             
                             [self.tableView reloadData];
                             self.textView.text = @"";
                         }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
//    NSDictionary *comment = [self.comments objectAtIndex:indexPath.row];
//    NSString *content = [comment objectForKey:@"content"];
//    
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:TEXT_FONT, NSFontAttributeName, nil];
//    
//    CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
//    
//    CGRect newFrame = [content boundingRectWithSize:maximumLabelSize
//                                            options:NSStringDrawingUsesLineFragmentOrigin
//                                         attributes:attributes
//                                            context:nil];
//    
//    return newFrame.size.height + 30;
    PartWebView *webView = [self.webViewArray objectAtIndex:indexPath.row];
    return webView.frame.size.height + 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"todoCell";
    CommentCell *cell = (CommentCell *)[self.tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:kCustomCellID];
    }
    
    NSDictionary *comment = [self.comments objectAtIndex:indexPath.row];
    
    PartWebView *webView = [self.webViewArray objectAtIndex:indexPath.row];
    webView.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:webView];
    [cell setComment:comment];
    
    return cell;
}

- (void) setTodo:(NSDictionary *)todo
{
    _todo = todo;
    self.tableView.tableHeaderView = [self getHeadView];
    self.tableView.tableFooterView = [self getFooterView];
    Session *session = [Session getInstance];
    NSInteger currentTeamId = session.teamId;
    NSInteger projectId = [[todo objectForKey:@"projectId"] integerValue];
    NSString *url = [NSString stringWithFormat:@"%ld/project/%ld/comment", (long)currentTeamId, (long)projectId];
    NSNumber *todoId = [todo objectForKey:@"id"];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:@"todo", @"commentableType",
                                 todoId, @"commentableId", nil];
    [HttpConnection initWithRequestURL:url
                            httpMethod:@"get"
                           requestDate:requestData
                         successAction:^(id comments) {
                             self.updateNum = 0;
                             self.comments = comments;
                             self.webViewArray = [[NSMutableArray alloc] initWithCapacity:[comments count]];
                             for (NSDictionary *comment in comments){
                                 NSString *content = [comment objectForKey:@"content"];
                                 PartWebView *webView = [[PartWebView alloc] initWithFrame:CGRectMake(30, 15, 280, 20)];
                                 [webView setContnet:content];
                                 [self.webViewArray addObject:webView];
                             }
                             
                             [self.tableView reloadData];
                         }];
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    [self.keyboardbar showBar:textView];
//}
//
//- (void)keyboardWasHidden:(UITextView *)textView {
//    [self.keyboardbar setShown:false]; //KeyBoardTopBar的实例对象调用显示键盘方法
//}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGPoint point = [self.tableView convertPoint:textView.frame.origin toView:nil];
    CGFloat offsetY = 200 - point.y - 450 + self.tableView.contentSize.height;
    if (offsetY > 0) {
        CGPoint offset = CGPointMake(0, offsetY);
        [self.tableView setContentOffset:offset animated:YES];
    }
    [self.keyboardbar showBar:textView];
    textView.inputAccessoryView = self.keyboardbar.view;
    return YES;
}

- (void) checkBoxTapped:(id)sender forEvent:(UIEvent*)event
{
    Session *session = [Session getInstance];
    NSInteger currentTeamId = session.teamId;
    NSInteger todoId = [[_todo objectForKey:@"id"] integerValue];
    
    NSInteger projectId = [[_todo objectForKey:@"projectId"] integerValue];
    NSString *url = [NSString stringWithFormat:@"%ld/project/%ld/todo/%ld/toggle", (long)currentTeamId, (long)projectId, (long)todoId];
    BOOL checked = self.checkBox.checked;
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithBool:checked], @"flag", nil];
    
    [HttpConnection initWithRequestURL:url
                            httpMethod:@"get"
                           requestDate:requestData
                         successAction:^(id todo) {
                             NSArray *viewControllers = [self.navigationController viewControllers];
                             ProjectViewController *projectViewController = [viewControllers objectAtIndex:[viewControllers count] -   2];
                             [projectViewController updateObject:todo withType:TODO];
                         }];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    self.updateNum ++;
	CGRect frame = aWebView.frame;
	frame.size.height = 1;
	aWebView.frame = frame;
    // Asks the view to calculate and return the size that best fits its subviews.
	CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
	frame.size = fittingSize;
	aWebView.frame = frame;
    if (self.updateNum == [self.comments count]) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}
@end
