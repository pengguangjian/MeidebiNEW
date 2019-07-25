//
//  JoinInActivityView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "JoinInActivityView.h"
#import "JoinInActivityPickPictureView.h"
#import "RemarkPictureSelectToolView.h"
#import "RemarkStatusComposeTextParser.h"
#import "RemarkStatusLayout.h"
#define kToolbarHeight (35 + 46)

@interface JoinInActivityView ()
<
JoinInActivityPickPictureViewDelegate,
UITextViewDelegate,
UIGestureRecognizerDelegate
>
@property (nonatomic ,strong) JoinInActivityPickPictureView *pictureHandleToolView;
//@property (nonatomic, strong) RemarkPictureSelectToolView *pictureHandleToolView;
@property (nonatomic ,strong)  UIButton *addPictureBtn;
@property (nonatomic ,strong) UIImageView *imageV;
@property (nonatomic ,strong) UIButton *deleteBtn;
@property (nonatomic ,strong) YYTextView *textView;
@property (nonatomic ,strong) UILabel *lbtishi;

@end


@implementation JoinInActivityView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubView];
        _selectPics = [NSMutableArray array];
    }
    return self;
    
}


- (void)setSubView{
    UILabel *activityLabel = [[UILabel alloc] init];
    activityLabel.text = @"";
    activityLabel.textColor = [UIColor colorWithHexString:@"#238FE8"];
    activityLabel.font = [UIFont systemFontOfSize:16];
    activityLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:activityLabel];
    [activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset(16);
    }];
    _activityLabel = activityLabel;
    
    [self _initPictureSelectToolView];

    UITextView *textV = [[UITextView alloc] init];
    [textV setTag:110];
    [self addSubview:textV];
    textV.font = [UIFont systemFontOfSize:14];
    textV.textAlignment = NSTextAlignmentLeft;
    [textV setDelegate:self];
    [textV setBackgroundColor:[UIColor clearColor]];
//    textV.placeholderText = @"分享一下你当时的心情吧......（不少于5个字）";
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.top.equalTo(_pictureHandleToolView.mas_bottom).offset(10);
        make.bottom.equalTo(self.mas_bottom);
    }];
    _lbtishi = [[UILabel alloc]initWithFrame:CGRectMake(5, 6, kMainScreenW-46, 40)];
    _lbtishi.font = [UIFont systemFontOfSize:14];
    _lbtishi.textAlignment = NSTextAlignmentLeft;
    [_lbtishi setTextColor:RGBAlpha(0.4, 0.4, 0.4, 0.7)];
    _lbtishi.text = @"分享一下你当时的心情吧......（不少于5个字）";
    [_lbtishi setNumberOfLines:0];
    [_lbtishi sizeToFit];
    [textV addSubview:_lbtishi];
    _textV = textV;
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture:)];
    [tap setDelegate:self];
    [_textV addGestureRecognizer:tap];
}

- (void)respondsToTapGesture:(UIGestureRecognizer *)gesture{
    if (_textV.isFirstResponder) {
        [self endEditing:YES];
    }else{
        [_textV becomeFirstResponder];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(textView.text.length > 0)
    {
        [_lbtishi setHidden:YES];
    }
    else
    {
        [_lbtishi setHidden:NO];
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length > 0)
    {
        [_lbtishi setHidden:YES];
    }
    else
    {
        [_lbtishi setHidden:NO];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > 0)
    {
        [_lbtishi setHidden:YES];
    }
    else
    {
        [_lbtishi setHidden:NO];
    }
}

- (void)_initPictureSelectToolView{
    if(_pictureHandleToolView) {
        [_pictureHandleToolView showPicturePickerView];
        return;
    };
    _pictureHandleToolView = [[JoinInActivityPickPictureView alloc] initWithFrame:CGRectMake(16,40, kMainScreenW-32, kMainScreenW*0.34)];
    [self addSubview:_pictureHandleToolView];
    _pictureHandleToolView.backgroundColor = [UIColor whiteColor];
    _pictureHandleToolView.delegate = self;
    [_pictureHandleToolView showPicturePickerView];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(_textV.isFirstResponder)
    {
        [_textV resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - @protocol RemarkPictureSelectToolView
- (void)pictureSelectBeginSkipToTargetVc:(UIViewController *)targetVc{
    if ([self.delegate respondsToSelector:@selector(picturePickerDidSelectPhotosWithTargeVc:)]) {
        [self.delegate picturePickerDidSelectPhotosWithTargeVc:targetVc];
    }
}

- (void)picturePickerDidSelectPhotos:(NSArray *)photos{
    if ([self.delegate respondsToSelector:@selector(picturePickerDidSelectPhotos:)]) {
        [self.delegate picturePickerDidSelectPhotos:photos];
    }
}


//- (void)addPicture:(UIButton *)sender{
//    if ([self.delegate respondsToSelector:@selector(picturePickerDidSelectPhotos)]) {
//        [self.delegate picturePickerDidSelectPhotos];
//    }
//    
//}
//
//- (void)deletePicture:(UIButton *)sender{
//    [_selectPics removeAllObjects];
//    _imageV.hidden = YES;
//    _addPictureBtn.hidden = NO;
//    
//}
//
//- (void)setSelectPics:(NSMutableArray *)selectPics{
//    _selectPics = selectPics;
//    _imageV.hidden = NO;
//    _imageV.image = _selectPics.firstObject;
//    _addPictureBtn.hidden = YES;
//    _deleteBtn.hidden = NO;
//    
//}



@end
