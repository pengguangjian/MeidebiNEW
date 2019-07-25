//
//  RemarkHomeInputTabBarView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/2/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RemarkHomeInputTabBarView.h"
#import <YYKit/YYKit.h>
#import "RemarkStatusComposeTextParser.h"
#import "RemarkStatusLayout.h"
#import "RemarkEmoticonInputView.h"
static CGFloat const minToolbarHeight = 40;
//static CGFloat const maxToolbarHeight = 80;


@interface RemarkHomeInputTabBarView ()
<
YYTextKeyboardObserver,
YYTextViewDelegate,
RemarkStatusComposeEmoticonViewDelegate
>
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) TextLinePositionModifier *modifier;
@property (nonatomic, strong) UIButton *toolbarEmoticonButton;

@end

@implementation RemarkHomeInputTabBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.size = CGSizeMake(kScreenWidth, minToolbarHeight);
        self.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.offset(1);
    }];
    [lineView setBackgroundColor:RGB(225.0, 225.0, 225.0)];
    [self _initTextView];
}


- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    _textView.left = 50;
    _textView.top = 5;
    _textView.size = CGSizeMake(self.width-60, self.height-10);
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = 4.f;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.textParser = [RemarkStatusComposeTextParser new];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    _textView.returnKeyType = UIReturnKeySend;
    
    TextLinePositionModifier *modifier = [TextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:15];
    modifier.paddingTop = 10;
    modifier.paddingBottom = 10;
    modifier.lineHeightMultiple = 1.5;
    _textView.linePositionModifier = modifier;
    _modifier = modifier;
    
    NSString *placeholderPlainText =  @"我来说两句......";
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = UIColorHex(b4b4b4);
        atr.font = [UIFont systemFontOfSize:15];
        _textView.placeholderAttributedText = atr;
    }

    [self addSubview:_textView];
    
    _toolbarEmoticonButton = [self _toolbarButtonWithImage:@"compose_emoticonbutton_background"
                                                 highlight:@"compose_emoticonbutton_background_highlighted"];

    CGFloat one = self.width / 5;
    _toolbarEmoticonButton.centerX = one * 0.4;
    
    [self addSubview:_toolbarEmoticonButton];

}



- (UIButton *)_toolbarButtonWithImage:(NSString *)imageName highlight:(NSString *)highlightImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.size = CGSizeMake(46, 46);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    button.centerY = minToolbarHeight / 2;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)textViewBecomeFirstResponder{
    [_textView becomeFirstResponder];
}

- (void)textViewDismissFirstResponder{
    [_textView resignFirstResponder];
    _textView.text = @"";
}

- (void)_buttonClicked:(UIButton *)button{
    if (button == _toolbarEmoticonButton) {
        if (_textView.inputView) {
            _textView.inputView = nil;
            [_textView reloadInputViews];
            [_textView becomeFirstResponder];
            
            [_toolbarEmoticonButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        } else {
            RemarkEmoticonInputView *v = [RemarkEmoticonInputView sharedInstance];
            v.delegate = self;
            _textView.inputView = v;
            [_textView reloadInputViews];
            [_textView becomeFirstResponder];
            [_toolbarEmoticonButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark @protocol YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
//    CGFloat height = [_modifier heightForLineCount:_textView.textLayout.rowCount];
//    if (height<minToolbarHeight) return;
//    if (height<maxToolbarHeight) {
//        _textView.height = height-10;
//    }else{
//        height = maxToolbarHeight;
//        _textView.height = maxToolbarHeight-10;
//    }
//    if ([self.delegate respondsToSelector:@selector(updateBarViewHeight:)]) {
//        [self.delegate updateBarViewHeight:height];
//    }
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (!textView.text||[textView.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请输入内容"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
            [alertView show];
            return YES;
        }
        if ([self.delegate respondsToSelector:@selector(textViewShouldReturn:)]) {
            [self.delegate textViewShouldReturn:textView.text];
        }
        return NO;
    }
    return YES;
}


#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [_textView replaceRange:_textView.selectedTextRange withText:text];
    }
}

- (void)emoticonInputDidTapBackspace {
    [_textView deleteBackward];
}

#pragma mark - setters and getters
- (void)setPlaceholderStr:(NSString *)placeholderStr{
    _placeholderStr = placeholderStr;
    NSString *placeholderPlainText = _placeholderStr;
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = UIColorHex(b4b4b4);
        atr.font = [UIFont systemFontOfSize:15];
        _textView.placeholderText = nil;
        _textView.placeholderAttributedText = atr;
    }
}


@end
