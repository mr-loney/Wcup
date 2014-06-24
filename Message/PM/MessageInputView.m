//
//  MessageInputView.m
//  PM
//
//  Created by 张浩 on 14-6-13.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "MessageInputView.h"
#import "NSString+MessageView.h"

@interface MessageInputView ()<UITextViewDelegate>

@property (nonatomic, weak, readwrite) MessageView *inputTextView;
@property (nonatomic, weak, readwrite) UIButton *voiceChangeButton;
@property (nonatomic, weak, readwrite) UIButton *multiMediaSendButton;
@property (nonatomic, weak, readwrite) UIButton *faceSendButton;
@property (nonatomic, weak, readwrite) UIButton *voiceButton;

/**
 *  在切换语音和文本消息的时候，需要保存原本已经输入的文本，这样达到一个好的UE
 */
@property (nonatomic, copy) NSString *inputedText;

/**
 *  输入框内的所有按钮，点击事件所触发的方法
 *
 *  @param sender 被点击的按钮对象
 */
- (void)messageButtonClick:(UIButton *)sender;

/**
 *  当录音按钮被按下所触发的事件，这时候是开始录音
 */
- (void)voiceButtonTouchDown;

/**
 *  当手指在录音按钮范围之外离开屏幕所触发的事件，这时候是取消录音
 */
- (void)voiceButtonTouchUpOutside;

/**
 *  当手指在录音按钮范围之内离开屏幕所触发的事件，这时候是完成录音
 */
- (void)voiceButtonTouchUpInside;

/**
 *  当手指滑动到录音按钮的范围之外所触发的事件
 */
- (void)voiceButtonDragOutsize;

/**
 *  当手指滑动到录音按钮的范围之内所触发的时间
 */
- (void)voiceButtonDragInside;

#pragma mark -- layout subViews UI
/**
 *  根据正常显示和高亮状态创建一个按钮对象
 *
 *  @param image   正常显示图
 *  @param hlImage 高亮显示图
 *
 *  @return 返回按钮对象
 */
- (UIButton *)createButtonWithNormalImage:(UIImage *)image highLightedImage:(UIImage *)hImage;

/**
 *  根据输入框的样式类型配置输入框的样式和UI布局
 *
 *  @param style 输入框样式类型
 */
- (void)setupMessageInputViewBarWithStyle:(MessageInputViewStyle)messageInputViewStyle;




@end

@implementation MessageInputView

#pragma mark -- Life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
  //配置自适应
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    //由于继承UIImageView，所以要打开用户响应
    self.userInteractionEnabled = YES;
    
    //默认设置
    _allowsSendFace = YES;
    _allowsSendVoice = YES;
    _allowsSendMultiMedia = YES;
    
    //默认是扁平化
    _messageInputViewStyle = MessageInputViewStyleFlat;
}


- (void)dealloc
{
    self.inputedText = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
    
    _voiceChangeButton = nil;
    _multiMediaSendButton = nil;
    _faceSendButton = nil;
    _voiceButton = nil;
}

//========================layoutsubviewsUI==========
#pragma mark -- layoutsubviewsUI
- (UIButton *)createButtonWithNormalImage:(UIImage *)image highLightedImage:(UIImage *)hImage
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [MessageInputView textViewLineHeight], [MessageInputView textViewLineHeight])];
    if (image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (hImage) {
        [button setBackgroundImage:hImage forState:UIControlStateHighlighted];
    }
    
    return button;
}

- (void)setupMessageInputViewBarWithStyle:(MessageInputViewStyle)messageInputViewStyle
{
    //配置输入工具条的样式和布局
    
    //需要显示的按钮的总宽度，（间隔）
    CGFloat allButtonWidth = 0.0;
    
    //水平间隔
    CGFloat horizontalPadding = 8.0;
    
    //垂直间隔
    CGFloat verticalPadding = 5;
    
    //输入框
    CGFloat textViewLeftMargin = (messageInputViewStyle == MessageInputViewStyleFlat) ? 6.0 : 4.0;
    
    //每个按钮统一使用frame
    CGRect buttonFrame;
    
    //按钮对象消息
    UIButton *button;
    
    //允许发送语音
    if (self.allowsSendVoice) {
        button = [self createButtonWithNormalImage:[UIImage imageNamed:@"voice"] highLightedImage:[UIImage imageNamed:@"voice_HL"]];
        [button addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000;
        [button setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateSelected];
        buttonFrame = button.frame;
        buttonFrame.origin = CGPointMake(horizontalPadding, verticalPadding);
        button.frame = buttonFrame;
        [self addSubview:button];
        allButtonWidth += CGRectGetMaxX(buttonFrame);
        textViewLeftMargin += CGRectGetMaxX(buttonFrame);
        self.voiceChangeButton = button;
    }
    
    // 允许发送多媒体消息，为什么不是先放表情按钮呢？因为布局的需要！
    if (self.allowsSendMultiMedia) {
        button = [self createButtonWithNormalImage:[UIImage imageNamed:@"multiMedia"]  highLightedImage:[UIImage imageNamed:@"multiMedia_HL"]];
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2;
        buttonFrame = button.frame;
        buttonFrame.origin = CGPointMake(CGRectGetWidth(self.bounds) - horizontalPadding - CGRectGetWidth(buttonFrame), verticalPadding);
        button.frame = buttonFrame;
        [self addSubview:button];
        allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 2.5;
        
        self.multiMediaSendButton = button;
    }
    
    // 允许发送表情
    if (self.allowsSendFace) {
        button = [self createButtonWithNormalImage:[UIImage imageNamed:@"face"] highLightedImage:[UIImage imageNamed:@"face_HL"]];
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1;
        buttonFrame = button.frame;
        if (self.allowsSendMultiMedia) {
            buttonFrame.origin = CGPointMake(CGRectGetMinX(self.multiMediaSendButton.frame) - CGRectGetWidth(buttonFrame) - horizontalPadding, verticalPadding);
            allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 1.5;
        } else {
            buttonFrame.origin = CGPointMake(CGRectGetWidth(self.bounds) - horizontalPadding - CGRectGetWidth(buttonFrame), verticalPadding);
            allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 2.5;
        }
        button.frame = buttonFrame;
        [self addSubview:button];
        
        self.faceSendButton = button;
    }

    //输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth?allButtonWidth:(textViewLeftMargin*2));
    CGFloat height = [MessageInputView textViewLineHeight];
    
    // 初始化输入框
    MessageView *textView = [[MessageView alloc] initWithFrame:CGRectZero];
    
    //把returnkey换成send
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    textView.placeHolder = @"发送新消息";
    textView.delegate = self;
    
    [self addSubview:textView];
    _inputTextView = textView;
    
    //配置不同的iOS SDK版本的样式
    switch (messageInputViewStyle) {
        case MessageInputViewStyleQuasiphysical:
        {
            _inputTextView.frame = CGRectMake(textViewLeftMargin, 3.0f, width, height);
            _inputTextView.backgroundColor = [UIColor whiteColor];
            self.image = [[UIImage imageNamed:@"input-bar-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0, 3.0, 19.0, 3.0) resizingMode:UIImageResizingModeStretch];
            UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(_inputTextView.frame.origin.x-1.0, 0.0, _inputTextView.frame.size.width+2.0, self.frame.size.height)];
            inputFieldBack.image = [[UIImage imageNamed:@"input-field-cover"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 12.0f, 18.0f, 18.0f)];
            inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
            inputFieldBack.backgroundColor = [UIColor clearColor];
            [self addSubview:inputFieldBack];
            break;
            
        }
        case MessageInputViewStyleFlat:
        {
            _inputTextView.frame = CGRectMake(textViewLeftMargin, 4.5f, width, height);
            _inputTextView.backgroundColor = [UIColor clearColor];
            _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
            _inputTextView.layer.borderWidth = 0.65f;
            _inputTextView.layer.cornerRadius = 6.0f;
            self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeStretch];
            break;

        }
            
        default:
            break;
    }
    
    //如果可以发送语音，那就需要一个录音的按钮，事件可以在外部添加
    if (self.allowsSendVoice) {
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(9, 9, 9, 9);
        button = [self createButtonWithNormalImage:STRETCH_IMAGE([UIImage imageNamed:@"VoiceBtn_Black"], edgeInsets) highLightedImage:STRETCH_IMAGE([UIImage imageNamed:@"VoiceBtn_BlackHL"], edgeInsets)];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitle:@"按住说话" forState:UIControlStateNormal];
        [button setTitle:@"松开停止" forState:UIControlStateHighlighted];
        buttonFrame = _inputTextView.frame;
        button.frame = buttonFrame;
        button.alpha = self.voiceChangeButton.selected;
        [button addTarget:self action:@selector(voiceButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(voiceButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(voiceButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(voiceButtonDragOutsize) forControlEvents:UIControlEventTouchDragExit];
        [button addTarget:self action:@selector(voiceButtonDragInside) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:button];
        self.voiceButton = button;
    }
}

#pragma mark -- Message input view
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    //动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.inputTextView.frame;
    
    NSUInteger numLines = MAX([self.inputTextView numberOfLinesOfText], [self.inputTextView.text numberOfLines]);
    
    self.inputTextView.frame = CGRectMake(prevFrame.origin.x, prevFrame.origin.y, prevFrame.size.width, prevFrame.size.height+changeInHeight);
    self.inputTextView.contentInset = UIEdgeInsetsMake((numLines>=6?4.0f:0.0f), 0.0f, (numLines>=6?4.0f:0.0f), 0.0f);
    
    //from iOS7,the content size will be accurate only if the scrolling is enabled
    self.inputTextView.scrollEnabled = YES;
    if (numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.inputTextView.contentSize.height-self.inputTextView.bounds.size.height);
        [self.inputTextView setContentOffset:bottomOffset animated:YES];
        [self.inputTextView scrollRangeToVisible:NSMakeRange(self.inputTextView.text.length-2, 1)];
    }
}

+ (CGFloat)textViewLineHeight
{
    return 36.0f;
}

+ (CGFloat)maxLines
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}

+ (CGFloat)maxHeight
{
    return ([MessageInputView maxLines]+1.0f) * [MessageInputView textViewLineHeight];
}

#pragma mark -- TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.inputDelegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.inputDelegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    self.faceSendButton.selected = NO;
    self.voiceChangeButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    if ([self.inputDelegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.inputDelegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.inputDelegate respondsToSelector:@selector(didSendTextAction:)]) {
            [self.inputDelegate didSendTextAction:textView.text];
        }
        return NO;
    }
    return YES;
}

@end
