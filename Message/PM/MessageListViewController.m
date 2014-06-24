//
//  MessageListViewController.m
//  PM
//
//  Created by 张浩 on 14-6-11.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"
#import "UIView+AnimationForCurve.h"
#import "NSString+MessageView.h"
#import "MessageView.h"


#define INPUT_HEIGHT 44.0f


@interface MessageListViewController ()

@end

@implementation MessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

/*
#pragma mark -- viewLifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scrollToBottomAnimated:NO];

    _originalTableViewContentInset = listView.contentInset;
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [inputToolBarView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的任务";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"]];
    
    _allMessagesFrame = [NSMutableArray array];
    
    
    NSString *previousTime = nil;
    for (NSDictionary *dict in array) {
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        Message *message = [[Message alloc] init];
        message.dataDict = dict;
        
        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        messageFrame.message = message;
        previousTime = message.time;
        [_allMessagesFrame addObject:messageFrame];
    }
}



//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}


- (void)initView
{
    listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-44-64) style:UITableViewStylePlain];
    listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listView.allowsSelection = NO;
    listView.dataSource = self;
    listView.delegate = self;
    listView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    [self.view addSubview:listView];
    

    inputToolBarView = [[InputView alloc] initPutView];
    inputToolBarView.top = listView.bottom;
    inputToolBarView.messageView.dismissPangestureRecognizer = listView.panGestureRecognizer;
    inputToolBarView.messageView.delegate = self;
    inputToolBarView.messageView.keyboardDelegate = self;
    inputToolBarView.messageView.placeHolder = @"说点什么呢？";
//    inputToolBarView.messageView.delegate = self;
    [self.view addSubview:inputToolBarView];
}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 增加数据源
    NSString *content = textField.text;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM-dd";//@"yyyy-MM-dd HH:mm:ss"
    NSDate *date = [NSDate date];
    NSString *time = [fmt stringFromDate:date];
    [self addMessageWithContent:content time:time];
    
    //刷新表格
    [listView reloadData];
    
    // 滚动到当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count-1 inSection:0];
    [listView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //清空文本内容
//    inputToolBarView.messageView.text = nil;
    
    
    
    return YES;
}

- (void)addMessageWithContent:(NSString *)content time:(NSString *)time
{
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    msg.content = content;
    msg.time = time;
    msg.icon = @"icon01.png";
    msg.type = MessageTypeOther;
    mf.message = msg;
    
    [_allMessagesFrame addObject:mf];
    
}





#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // 设置数据
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_allMessagesFrame[indexPath.row] cellHeight];
}

#pragma mark - 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         CGRect inputViewFrame = inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         //for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height-INPUT_HEIGHT;
                         if (inputViewFrameY > messageViewFrameBottom) {
                             inputViewFrameY = messageViewFrameBottom;
                         }
                         inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x, inputViewFrameY, inputViewFrame.size.width, inputViewFrame.size.height);
                         UIEdgeInsets insets = self.originalTableViewContentInset;
                         insets.bottom = self.view.frame.size.height - inputToolBarView.frame.origin.y - inputViewFrame.size.height;
                         listView.contentInset = insets;
                         listView.scrollIndicatorInsets = insets;
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark -- MessageTextViewDelegate
- (void)keyboardDidScrollToPoint:(CGPoint)point
{
    CGRect inputViewFrame = inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = inputToolBarView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    inputToolBarView.frame = inputViewFrame;
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    if (!self.previousTextViewContentHeight) {
        self.previousTextViewContentHeight = textView.contentSize.height;
    }
    NSLog(@"%@", NSStringFromCGSize(textView.contentSize));
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [InputView maxHeight];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    if (!isShrinking && self.previousTextViewContentHeight==maxHeight) {
        changeInHeight = 0;
    } else {
        changeInHeight = MIN(changeInHeight, maxHeight-self.previousTextViewContentHeight);
    
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f animations:^{
            UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, listView.contentInset.bottom+changeInHeight, 0.0f);
            listView.contentInset = insets;
            listView.scrollIndicatorInsets = insets;
            [self scrollToBottomAnimated:NO];
            if (isShrinking) {
                [inputToolBarView adjustTextViewHeightBy:changeInHeight];
            }
            CGRect inputViewFrame = inputToolBarView.frame;
            inputToolBarView.frame = CGRectMake(0.0f, inputViewFrame.origin.y-changeInHeight, inputViewFrame.size.width, inputViewFrame.size.height+changeInHeight);
            if (!isShrinking) {
                [inputToolBarView adjustTextViewHeightBy:changeInHeight];
            }
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [listView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [listView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
