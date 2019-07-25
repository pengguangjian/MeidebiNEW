//
//  RemarkComposeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/2/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RemarkComposeViewController.h"
#import <YYKit/YYKit.h>
#import "RemarkStatusLayout.h"
#import "RemarkStatusComposeTextParser.h"
#import "RemarkEmoticonInputView.h"
#import "RemarkPictureSelectToolView.h"
#import "MDB_UserDefault.h"
#import <FCUUID/FCUUID.h>

#import "RemarkAtUserView.h"

#define kToolbarHeight (35 + 46)

@interface RemarkComposeViewController ()
<
YYTextKeyboardObserver,
YYTextViewDelegate,
RemarkStatusComposeEmoticonViewDelegate,
RemarkPictureSelectToolViewDelegate,
UIGestureRecognizerDelegate,
RemarkAtUserViewDelegate
>
@property (nonatomic, strong) UIView *viewback;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) TextLinePositionModifier *modifier;
@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIView *toolbarBackground;
@property (nonatomic, strong) UIButton *toolbarPictureButton;
@property (nonatomic, strong) UIButton *toolbarEmoticonButton;
@property (nonatomic, strong) UIButton *toolbarAtButton;
@property (nonatomic, strong) RemarkPictureSelectToolView *pictureHandleToolView;
@property (nonatomic, strong) RemarkHomeDatacontroller *dataController;
@property (nonatomic, strong) NSArray *selectPics;
///@好友需要
@property (nonatomic, assign) BOOL isStartAT;
@property (nonatomic, strong) NSString *strAtNow;
@property (nonatomic, strong) NSMutableArray *arrAtPush;
@property (nonatomic, strong) RemarkAtUserView *atUserView;

@property (nonatomic, assign) NSInteger istartLocation;

///@用户加载数据
@property (nonatomic, strong) NSMutableArray *arratvalue;
@property (nonatomic, assign) BOOL isatreading;
@property (nonatomic, strong) NSString *strlastat;
@end

@implementation RemarkComposeViewController
- (instancetype)init {
    self = [super init];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    return self;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    _selectPics = [NSArray array];
    _arrAtPush = [NSMutableArray new];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_textView becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    
    if (kSystemVersion>=7) {
        _viewback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH)];
    }else{
        _viewback = [[UIView alloc] initWithFrame:CGRectMake(0, kTopHeight, kMainScreenW, kMainScreenH-kTopHeight)];
    }
    [self.view addSubview:_viewback];
    
    [self setNavigation];
    [self _initTextView];
    [self _initToolbar];
    _atUserView = [[RemarkAtUserView alloc] initWithFrame:CGRectMake(0, 0, 120*kScale, 0)];
    [_atUserView setDelegate:self];
    [_viewback addSubview:_atUserView];
    
}

-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];
    btnright.frame = CGRectMake(0,0,50,25);
    btnright.backgroundColor = [UIColor colorWithHexString:@"#FD7B0D"];
    [btnright setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [btnright setTitle:@"发送" forState:UIControlStateNormal];
    [btnright.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [btnright.layer setCornerRadius:3.f];
    [btnright addTarget:self action:@selector(confirmSubmit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

- (void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmSubmit:(id)sender{
    [_textView resignFirstResponder];
    if ((!_textView.text||[_textView.text isEqualToString:@""]) && _selectPics.count <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入内容"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
        [alertView show];
        return;
    }
//    if (_textView.text.length < 5) {
//        [MDB_UserDefault showNotifyHUDwithtext:@"评论内容不足5个字！" inView:_textView];
//        return;
//    }
    NSString *strfriendid = @"";
    NSString *strtext = _textView.text;
    for(NSDictionary *dic in _arrAtPush)
    {
        NSString *strtemp = [NSString stringWithFormat:@"@%@ ",[dic objectForKey:@"name"]];
        if ([strtext rangeOfString:strtemp].location == NSNotFound) {
            
            NSLog(@"meiyou");
            
        } else {
            
            if(strfriendid.length == 0)
            {
                strfriendid = [strfriendid stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
            }
            else
            {
                strfriendid = [strfriendid stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"id"]]];
            }
            
        }
        
//        if ([strtext containsString:strtemp]) {
//
//            if(strfriendid.length == 0)
//            {
//                strfriendid = [strfriendid stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
//            }
//            else
//            {
//                strfriendid = [strfriendid stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"id"]]];
//            }
//
//        }
    }
    
    NSDictionary *dics =@{
                          @"userid":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                          @"type":[NSString stringWithFormat:@"%@",@(_type)],
                          @"fromid":[NSString nullToString:_linkid],
                          @"pics":_selectPics,
                          @"content":_textView.text,
                          @"uniquetoken":[FCUUID uuidForDevice],
                          @"friend_id":strfriendid
                          };
    if (_confirmRemark) {
        _confirmRemark(dics);
    }
    [self doClickLeftAction:nil];
}


- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
//    if (kSystemVersion < 7) _textView.top = -kTopHeight;
    _textView.top=0;
    _textView.size = CGSizeMake(_viewback.width, _viewback.height-kToolbarHeight);
    _textView.textContainerInset = UIEdgeInsetsMake(12, 16, 12, 16);
    _textView.contentInset = UIEdgeInsetsMake(kTopHeight, 0, kToolbarHeight, 0);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.extraAccessoryViewHeight = kToolbarHeight;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsUndoAndRedo = NO;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.textParser = [RemarkStatusComposeTextParser new];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    
    _modifier = [TextLinePositionModifier new];
    _modifier.font = [UIFont fontWithName:@"Heiti SC" size:17];
    _modifier.paddingTop = 12;
    _modifier.paddingBottom = 12;
    _modifier.lineHeightMultiple = 1.5;
    _textView.linePositionModifier = _modifier;

    NSString *placeholderPlainText =  @"我来说两句......";
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = UIColorHex(b4b4b4);
        atr.font = [UIFont systemFontOfSize:17];
        _textView.placeholderAttributedText = atr;
    }
    
    [_viewback addSubview:_textView];
    
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_textView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
}

- (void)_initToolbar {
    if (_toolbar) return;
    _toolbar = [UIView new];
    _toolbar.backgroundColor = [UIColor whiteColor];
    _toolbar.size = CGSizeMake(_viewback.width, kToolbarHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _toolbarBackground = [UIView new];
    _toolbarBackground.backgroundColor = UIColorHex(F9F9F9);
    _toolbarBackground.size = CGSizeMake(_toolbar.width, 46);
    _toolbarBackground.bottom = _toolbar.height;
    _toolbarBackground.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [_toolbar addSubview:_toolbarBackground];
    
    _toolbarBackground.height = 300; // extend
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorHex(BFBFBF);
    line.width = _toolbarBackground.width;
    line.height = CGFloatFromPixel(1);
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_toolbarBackground addSubview:line];
    
    
    _toolbarPictureButton = [self _toolbarButtonWithImage:@"compose_toolbar_picture"
                                                highlight:@"compose_toolbar_picture_highlighted"];
    _toolbarEmoticonButton = [self _toolbarButtonWithImage:@"compose_emoticonbutton_background"
                                                 highlight:@"compose_emoticonbutton_background_highlighted"];
    
    
    _toolbarAtButton = [self _toolbarButtonWithImage:@"pinglunAt"
                                                 highlight:@"pinglunAt"];
    
    CGFloat one = _toolbar.width / 5;
    _toolbarPictureButton.centerX = one * 0.5;
    _toolbarEmoticonButton.centerX = one * 1.3;
    _toolbarAtButton.centerX = one * 2.1;
    _toolbar.bottom = self.view.height;
    [_viewback addSubview:_toolbar];
}

- (void)_initPictureSelectToolView{
    if(_pictureHandleToolView) {
        [_pictureHandleToolView showPicturePickerView];
        return;
    };
    _pictureHandleToolView = [[RemarkPictureSelectToolView alloc] initWithFrame:CGRectMake(0, [_modifier heightForLineCount:_textView.textLayout.rowCount]+20, _textView.width, CGRectGetWidth(self.view.frame)*0.34)];
    [_textView addSubview:_pictureHandleToolView];
    _pictureHandleToolView.backgroundColor = [UIColor whiteColor];
    _pictureHandleToolView.delegate = self;
    [_pictureHandleToolView showPicturePickerView];
    
}

- (UIButton *)_toolbarButtonWithImage:(NSString *)imageName highlight:(NSString *)highlightImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.size = CGSizeMake(46, 46);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    button.centerY = 46 / 2;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarBackground addSubview:button];
    return button;
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
    }else if (button == _toolbarPictureButton){
        [self _initPictureSelectToolView];
    }
    else  if (button == _toolbarAtButton)
    {///@
        
        [_textView setText:[_textView.text stringByAppendingString:@"@"]];
        NSInteger iten = _textView.text.length;
        [_textView setSelectedRange:NSMakeRange(iten, 1)];
        ///开始@了
        _isStartAT = YES;
        _strAtNow = @"";
        _istartLocation = _textView.text.length;
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    if (_textView.inputView) {
        _textView.inputView = nil;
        [_textView reloadInputViews];
        [_textView becomeFirstResponder];
        [_toolbarEmoticonButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 判断已@的好友中有没得这个数据
-(void)atDataManager:(NSDictionary *)dic
{
    BOOL isyou = NO;
    for(NSDictionary *dictemp in _arrAtPush)
    {
        if([[dictemp objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]])
        {
            isyou = YES;
            break;
        }
    }
    if(isyou == NO)
    {
        [_arrAtPush addObject:dic];
    }
    _isStartAT = NO;
}

#pragma mark - RemarkAtUserViewDelegate
-(void)selectItemValue:(NSDictionary *)dic
{
    
    
    [self atDataManager:dic];
    
    NSString *strtemp = [dic objectForKey:@"name"];
    [_textView setText:[_textView.text substringToIndex:_istartLocation]];
    _isStartAT = NO;
    [_textView setText:[_textView.text stringByAppendingString:strtemp]];
    [_textView setText:[_textView.text stringByAppendingString:@" "]];
    
    NSInteger iten = _textView.text.length;
    [_textView resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_textView setSelectedRange:NSMakeRange(iten, 1)];
        [_textView becomeFirstResponder];
    });
    
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark @protocol YYTextViewDelegate

- (void)textViewDidChange:(YYTextView *)textView {
    
    if(_textView.text.length>_istartLocation)
    {
        _strAtNow = [_textView.text substringFromIndex:_istartLocation];
    }
    else
    {
        _strAtNow = @"";
    }
    
    if (!_pictureHandleToolView.isHidden) {
        _pictureHandleToolView.frame = CGRectMake(0, [_modifier heightForLineCount:_textView.textLayout.rowCount]+20, _textView.width, CGRectGetWidth(self.view.frame)*0.34);
    }
    if(_strAtNow.length>25)
    {
        _isStartAT = NO;
    }
    if(_isStartAT == YES&&_strAtNow.length>0)
    {///去获取数据
        if(_dataController == nil)
        {
             _dataController = [[RemarkHomeDatacontroller alloc] init];
        }
        if(_arratvalue==nil)
        {
            _arratvalue = [NSMutableArray new];
        }
        [_arratvalue insertObject:_strAtNow atIndex:0];
        if(_isatreading)return;
        _isatreading = YES;
        if(_arratvalue.count>0)
        {
            [self atjiazaiData:_arratvalue.firstObject];
        }
    }
    else
    {
       [_atUserView AtUserValueLoad:[NSMutableArray new]];
    }
    
    @try
    {
        NSString *strtemp = textView.text;
        if([[strtemp substringWithRange:NSMakeRange(strtemp.length-1, 1)] isEqualToString:@"@"])
        {
            _isStartAT = YES;
            _strAtNow = @"";
            [_atUserView AtUserValueLoad:[NSMutableArray new]];
            _istartLocation = textView.text.length;
        }
    }
    @catch (NSException *exc)
    {
        
    }
    @finally{
        
    }
    
    
}

-(void)atjiazaiData:(NSString *)strvalue
{
    _strlastat = strvalue;
    [_dataController requestAtData:strvalue callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            
            CGPoint cursorPosition = [_textView caretRectForPosition:_textView.selectedTextRange.start].origin;
            
            [_atUserView setTop:cursorPosition.y+15+self.navigationController.navigationBar.bottom];
            
            
            float ftemp = cursorPosition.x;
            //                NSLog(@"+++++%lf+++%lf",ftemp,cursorPosition.x);
            [_atUserView setLeft:ftemp];
            if(_atUserView.right>BOUNDS_WIDTH-10)
            {
                [_atUserView setRight:BOUNDS_WIDTH-10];
            }
            if(_dataController.resultAtDict.count == 1)
            {
                [_atUserView AtUserValueLoad:(NSMutableArray *)_dataController.resultAtDict];
            }
            else if (_dataController.resultAtDict.count>1)
            {
                [_atUserView AtUserValueLoad:(NSMutableArray *)_dataController.resultAtDict];
            }
            else
            {
                [_atUserView AtUserValueLoad:[NSMutableArray new]];
            }
            if(_atUserView.top>self.view.center.y)
            {
                _atUserView.bottom = cursorPosition.y+15+self.navigationController.navigationBar.bottom;
            }
        }
        else
        {
            [_atUserView AtUserValueLoad:[NSMutableArray new]];
        }
        _isatreading = NO;
        if(_arratvalue.count>0)
        {
            if(![strvalue isEqualToString:_arratvalue.firstObject])
            {
                _isatreading = YES;
                [self atjiazaiData:_arratvalue.firstObject];
            }
        }
        
    }];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(_isStartAT == YES)
    {
        if([text isEqualToString:@""])
        {
            
            
            if(_strAtNow.length>=1)
            {
                _strAtNow = [_strAtNow substringToIndex:_strAtNow.length-1];
            }
            
        }
        else
        {
            _strAtNow = [_strAtNow stringByAppendingString:text];
        }
        
        
        @try
        {
            NSString *strtemp = textView.text;
            if([[strtemp substringWithRange:NSMakeRange(strtemp.length-1, 1)] isEqualToString:@"@"] && [text isEqualToString:@""])
            {
                _isStartAT = NO;
                _strAtNow = @"";
                [_atUserView AtUserValueLoad:[NSMutableArray new]];
            }
        }
        @catch (NSException *exc)
        {
            
        }
        @finally{
            
        }
        
    }
    
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [_atUserView AtUserValueLoad:[NSMutableArray new]];
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    if (transition.animationDuration == 0) {
        _toolbar.bottom = CGRectGetMinY(toFrame);
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _toolbar.bottom = CGRectGetMinY(toFrame);
        } completion:NULL];
    }
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

#pragma mark - @protocol RemarkPictureSelectToolView
- (void)pictureSelectBeginSkipToTargetVc:(UIViewController *)targetVc{
    [self presentViewController:targetVc animated:YES completion:nil];
}

- (void)picturePickerDidSelectPhotos:(NSArray *)photos{
    _selectPics = photos;
}

#pragma mark - setters and getters
- (RemarkHomeDatacontroller *)dataController{
    if (!_dataController) {
        _dataController = [[RemarkHomeDatacontroller alloc] init];
    }
    return _dataController;
}


@end
