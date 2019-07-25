//
//  PushSubscibeSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/9/18.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "PushSubscibeSubjectView.h"
#import "PushKeywordSubjectView.h"

#import "NJFlagView.h"

#import "PushSubscibeHotKeysView.h"

@interface NJPushSubscibeScrollView : UIScrollView

@end

@implementation NJPushSubscibeScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    @try
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    @finally
    {
        
    }
}

@end

@interface PushSubscibeSubjectView ()
<
PushKeywordSubjectViewDelegate,
PushSubscibeHotKeysViewDelegate
>
{
    UIButton *addKeyButton;
}
@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) UITextField *keyTextField;
@property (nonatomic, strong) PushKeywordSubjectView *keyWordSubjectView;
@property (nonatomic, strong) SubscibeKeyWordEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *keywords;
@property (nonatomic, strong) NJPushSubscibeScrollView *scrollView;

@property (nonatomic, strong) UIView *yiDingYuView;

//@property (nonatomic, strong) NJFlagView *flagView;

@property (nonatomic, strong) PushSubscibeHotKeysView *flagView;

@end

@implementation PushSubscibeSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{

    _scrollView = [[NJPushSubscibeScrollView alloc] init];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];

    _contairView = [[UIView alloc] init];
    [_scrollView addSubview:_contairView];
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView.mas_width);
    }];
    _contairView.backgroundColor = [UIColor clearColor];
    
    UILabel *promptLabel = [UILabel new];
    [_contairView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contairView.mas_top).offset(30);
        make.left.equalTo(_contairView.mas_left).offset(5);
        make.right.equalTo(_contairView.mas_right).offset(-5);
    }];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont boldSystemFontOfSize:17.f];
    promptLabel.textColor = RGB(30, 30, 30);
//    promptLabel.text = @"设置关键词，我们将第一时间把优惠带给你";
    promptLabel.text = @"我们会根据你的兴趣来推荐优惠";
    
    
    UILabel *promptLabel1 = [UILabel new];
    [_contairView addSubview:promptLabel1];
    [promptLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel.mas_bottom).offset(10);
        make.left.equalTo(_contairView.mas_left).offset(5);
        make.right.equalTo(_contairView.mas_right).offset(-5);
    }];
    promptLabel1.textAlignment = NSTextAlignmentCenter;
    promptLabel1.font = [UIFont systemFontOfSize:12.f];
    promptLabel1.textColor = RGB(153, 153, 153);
    //    promptLabel.text = @"设置关键词，我们将第一时间把优惠带给你";
    promptLabel1.text = @"我们会根据你的兴趣来推荐优惠";
    
    
//    UIView *searchKeyContairView = [UIView new];
//    [_contairView addSubview:searchKeyContairView];
//    [searchKeyContairView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(promptLabel.mas_bottom).offset(30);
//        make.left.equalTo(_contairView.mas_left).offset(16);
//        make.right.equalTo(_contairView.mas_right).offset(-16);
//        make.height.offset(50);
//    }];
//    searchKeyContairView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    searchKeyContairView.layer.masksToBounds = YES;
//    searchKeyContairView.layer.borderWidth = 1.f;
//    searchKeyContairView.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
//
//    _keyTextField = [UITextField new];
//    [searchKeyContairView addSubview:_keyTextField];
//    [_keyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(searchKeyContairView).insets(UIEdgeInsetsMake(10, 15, 10, 15));
//    }];
//    _keyTextField.placeholder = @"请输入订阅关键词";
//    _keyTextField.font = [UIFont systemFontOfSize:14.f];
//
//    addKeyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_contairView addSubview:addKeyButton];
//    [addKeyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(searchKeyContairView.mas_bottom).offset(30);
//        make.left.equalTo(_contairView.mas_left).offset(71);
//        make.right.equalTo(_contairView.mas_right).offset(-71);
//        make.height.offset(50);
//    }];
//    [addKeyButton setTitle:@"添加" forState:UIControlStateNormal];
//    addKeyButton.backgroundColor = [UIColor colorWithHexString:@"#FD7A0E"];
//    addKeyButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
//    addKeyButton.layer.masksToBounds = YES;
//    addKeyButton.layer.cornerRadius = 3.f;
//    [addKeyButton addTarget:self action:@selector(respondsBtnToEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
//    UIView *viewline1 = [[UIView alloc] init];
//    [_contairView addSubview:viewline1];
//    [viewline1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_yiDingYuView.mas_bottom);
//        make.left.right.equalTo(_contairView);
//        make.height.offset(1);
//    }];
//    [viewline1 setBackgroundColor:RGB(227, 227, 227)];
    
//    _flagView = [NJFlagView new];
//    [_contairView addSubview:_flagView];
//    [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(viewline1.mas_bottom).offset(15);
//        make.left.right.equalTo(_contairView);
//    }];
//    _flagView.delegate = self;
//    _flagView.flagTitleName = @"热门推荐";
//    _flagView.flagTitleColor = RGB(120, 120, 120);
//    _flagView.flagTitleFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
//    __weak typeof (self) weakSelf = self;
//    _flagView.callback = ^(CGFloat height) {
//        [weakSelf.flagView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(height);
//        }];
//    };
    
    _flagView = [PushSubscibeHotKeysView new];
    [_contairView addSubview:_flagView];
    [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel1.mas_bottom);
        make.left.right.equalTo(_contairView);
    }];
    [_flagView setDelegate:self];
    
    
    [self drawyidingyue];
    
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_yiDingYuView.mas_bottom).offset(10);
    }];
}

///已订阅关键词
-(void)drawyidingyue
{
    _yiDingYuView = [[UIView alloc] init];
//    [_yiDingYuView setClipsToBounds:YES];
    [_contairView addSubview:_yiDingYuView];
    [_yiDingYuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_flagView.mas_bottom).offset(25);
        make.left.right.equalTo(_contairView);
        
    }];
    [_yiDingYuView setHidden:YES];
    
    
    UIView *viewline = [[UIView alloc] init];
    [_yiDingYuView addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.equalTo(_yiDingYuView);
        make.height.offset(1);
    }];
//    [viewline setBackgroundColor:RGB(227, 227, 227)];
    
    
    
    UILabel *subscibeTitleLabel = [UILabel new];
    [_yiDingYuView addSubview:subscibeTitleLabel];
    [subscibeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_yiDingYuView.mas_left).offset(15);
        make.top.offset(15);
    }];
    subscibeTitleLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    subscibeTitleLabel.text = @"已订阅";
    
    UILabel *subscibeSubTitleLabel = [UILabel new];
    [_yiDingYuView addSubview:subscibeSubTitleLabel];
    [subscibeSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(subscibeTitleLabel.mas_right);
        make.bottom.equalTo(subscibeTitleLabel.mas_bottom).offset(-2);
    }];
    subscibeSubTitleLabel.textColor = RGB(153, 153, 153);
    subscibeSubTitleLabel.text = @"（最多设置15个）";
    subscibeSubTitleLabel.font = [UIFont systemFontOfSize:12.f];
    
    
    
    ///修改
    _emptyView = [SubscibeKeyWordEmptyView new];
    [_yiDingYuView addSubview:_emptyView];
    [_emptyView setHidden:YES];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subscibeTitleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(_yiDingYuView);
    }];
    
    _keyWordSubjectView = [PushKeywordSubjectView new];
    [_yiDingYuView addSubview:_keyWordSubjectView];
    _keyWordSubjectView.delegate = self;
    [_keyWordSubjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subscibeTitleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(_yiDingYuView);
        make.height.offset(0);
    }];
    
}

- (void)respondsBtnToEvent:(id)sender{
    if ([_keyTextField.text isEqualToString:@""]) return;
    [self endEditing:YES];
    [self.keywords addObject:_keyTextField.text];
    _keyTextField.text = nil;
    _keyWordSubjectView.dataHistorySource = self.keywords.mutableCopy;
}

- (void)bindDataWithPushKeys:(NSString *)keys{
    if ([keys isEqualToString:@""]) return;
    NSArray *keywords = [keys componentsSeparatedByString:@","];
    for(NSString *strkeys in keywords)
    {
        BOOL isyou = NO;
        for(NSString *strkeys1 in self.keywords)
        {
            if([[NSString nullToString:strkeys] isEqualToString:[NSString nullToString:strkeys1]])
            {
                isyou = YES;
                break;
            }
        }
        if(isyou==NO)
        {
            [self.keywords addObject:strkeys];
        }
        
        
    }
    
    
    _keyWordSubjectView.dataHistorySource = self.keywords.mutableCopy;
}

-(void)bindHotKeys:(NSArray *)arrkeys
{
    if([arrkeys isKindOfClass:[NSArray class]])
    {
//        NSMutableArray *arrtemp = [NSMutableArray new];
//        for(NSString *str in arrkeys)
//        {
//            NSMutableDictionary *dictemp = [NSMutableDictionary new];
//            [dictemp setObject:str forKey:@"name"];
//            [arrtemp addObject:dictemp];
//        }
//        [_flagView flag:arrtemp];
        
        [_flagView bindkeys:arrkeys];
        
    }
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

#pragma mark - PushSubscibeHotKeysViewDelegate
- (void)PushSubscibeHotKeysViewItemAction:(NSString *)value
{
    [self bindDataWithPushKeys:value];
    
}
#pragma mark - PushKeywordSubjectViewDelegate
- (void)updateViewHeight:(CGFloat)height{
    [_keyWordSubjectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height);
    }];
    
    if(height>0&&self.keywords.count>0)
    {
        [_yiDingYuView setHidden:NO];
        [_yiDingYuView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(addKeyButton.mas_bottom).offset(45);
//            make.left.right.equalTo(_contairView);
            make.bottom.equalTo(_keyWordSubjectView.mas_bottom).offset(20);
        }];
    }
    else
    {
        [_keyWordSubjectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [_yiDingYuView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(addKeyButton.mas_bottom).offset(1);
//            make.left.right.equalTo(_contairView);
            make.bottom.equalTo(_keyWordSubjectView.mas_bottom).offset(1);
        }];
    }
}

- (void)keywordSubjectView:(PushKeywordSubjectView *)subjectView
         didChangeKeywords:(NSArray *)keys{
    self.keywords = keys.mutableCopy;
    if (self.keywords.count==0) {
        _emptyView.hidden = NO;
    }else{
        _emptyView.hidden = YES;
    }
    _emptyView.hidden = YES;
    
    if(keys.count>0)
    {
        [_yiDingYuView setHidden:NO];
//        [_yiDingYuView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(addKeyButton.mas_bottom).offset(45);
//            make.left.right.equalTo(_contairView);
//            make.bottom.equalTo(_keyWordSubjectView.mas_bottom).offset(20);
//        }];
    }
    else
    {
        [_yiDingYuView setHidden:YES];
    }
    
    
    [_contairView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView.mas_width);
//        if (self.keywords.count==0) {
//            make.bottom.equalTo(_emptyView.mas_bottom).offset(10);
//        }else{
//            make.bottom.equalTo(_keyWordSubjectView.mas_bottom).offset(10);
//        }
        make.bottom.equalTo(_yiDingYuView.mas_bottom).offset(10);
    }];
    
    if ([self.delegate respondsToSelector:@selector(subscibeSubjectView:addPushKeywords:)]) {
        [self.delegate subscibeSubjectView:self addPushKeywords:self.keywords];
    }
}


#pragma mark - setters and getters
- (NSMutableArray *)keywords{
    if (!_keywords) {
        _keywords = [NSMutableArray array];
    }
    return _keywords;
}
@end


@implementation SubscibeKeyWordEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    imageView.image = [UIImage imageNamed:@"img_no_reading"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:12.f];
    contentLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"你暂时还没有订阅关键词，赶快添加吧，\n\n让购物随心所欲！";
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentLabel.mas_bottom).offset(20);
    }];
}

@end
