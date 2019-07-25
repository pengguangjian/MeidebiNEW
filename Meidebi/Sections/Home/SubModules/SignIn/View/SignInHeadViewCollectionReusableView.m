//
//  SignInHeadViewCollectionReusableView.m
//  Meidebi
//
//  Created by fishmi on 2017/6/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SignInHeadViewCollectionReusableView.h"
#import "SignInHeadModel.h"
#import "SignInHeadDoSignModel.h"
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"


@interface SignInHeadViewCollectionReusableView ()
@property (nonatomic ,weak) UIView *signInV;
@property (nonatomic ,weak) UIView *view;
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,weak) UIView *backgV;
@property (nonatomic ,weak) UILabel *lukyLabel;
@property (nonatomic ,weak) UIButton *atOnceSignInBtn;
@property (nonatomic ,weak) UILabel *signInDateNumLabel;
@property (nonatomic ,weak) UILabel *copperNumLabel;
@property (nonatomic ,assign) NSInteger signDateNum;
@property (nonatomic ,assign) NSInteger copperNum;
@property (nonatomic ,weak) UIView *ruleV;
@property (nonatomic ,weak) UILabel *likeLabel;
@property (nonatomic ,weak) UIView *likeBackgV;
@property (nonatomic ,weak) UILabel *ruleDetailLabel;
@property (nonatomic ,weak) UILabel *ruleLabel;
@property (nonatomic ,assign) CGFloat ruleVheight;
@property (nonatomic ,assign) BOOL isClicked;
@end

@implementation SignInHeadViewCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubView];
        _isClicked = NO;

        self.backgroundColor = [UIColor colorWithHexString:@"#fcf4f1"];
    }
    return self;
}


- (void)setSubView{
    
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
    }];
    _view = view;
    
    UIView *signInV = [[UIView alloc] init];
    [view addSubview:signInV];
    [signInV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(view);

    }];
    _signInV = signInV;
    [self setSignView];
    [signInV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_copperNumLabel.mas_bottom).offset(20);
    }];

    
    UIView *ruleV = [[UIView alloc] init];
    [view addSubview:ruleV];
    [ruleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(_signInV.mas_bottom);
    }];
    _ruleV = ruleV;
//    ruleV.backgroundColor = [UIColor redColor];
    
    UILabel *ruleLabel = [[UILabel alloc] init];
    ruleLabel.text = @"签到规则";
    ruleLabel.font = [UIFont systemFontOfSize:12];
    ruleLabel.textAlignment = NSTextAlignmentCenter;
    ruleLabel.textColor = [UIColor colorWithHexString:@"#C38D66"];
    [ruleV addSubview:ruleLabel];
    [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ruleV);
        make.top.equalTo(ruleV).offset(23*kScale);
        make.width.offset(50);
    }];
    _ruleLabel = ruleLabel;
    
    UIImageView *leftRuleLineV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    [ruleV addSubview:leftRuleLineV];
    [leftRuleLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ruleV).offset(24);
        make.centerY.equalTo(ruleLabel.mas_centerY);
        make.right.equalTo(ruleLabel.mas_left).offset(-10);
        make.height.equalTo(@1);
        
    }];
    
    UIImageView *rightRuleLineV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    [ruleV addSubview:rightRuleLineV];
    [rightRuleLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ruleV).offset(-24);
        make.centerY.equalTo(ruleLabel.mas_centerY);
        make.left.equalTo(ruleLabel.mas_right).offset(10);
        make.height.equalTo(@1);
        
    }];
    
    UILabel *ruleDetailLabel = [[UILabel alloc] init];
    ruleDetailLabel.text = @"1、每天登录没得比，赚取积分、铜币，每天签到获取1个积分、1个铜币；\n2、连续签到7天额外奖励7个铜币、连续签到14天额外奖励14个铜币、连续签到22天额外奖励21个铜币、连续签到30天额外奖励30个铜币。\n3、2017.10.25-2017.11.11 期间签到双倍积分、双倍铜币！\n4、双11期间更有10元话费、爱奇艺周卡、Q币等你来兑换！（请前往“我的-兑换”）";
    ruleDetailLabel.font = [UIFont systemFontOfSize:12];
    ruleDetailLabel.attributedText = [self getAttributedStringWithString:ruleDetailLabel.text lineSpace:10];
    ruleDetailLabel.textAlignment = NSTextAlignmentLeft;
    ruleDetailLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [ruleV addSubview:ruleDetailLabel];
    [ruleDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ruleV).offset(24 *kScale);
        make.top.equalTo(ruleLabel.mas_bottom).offset(20*kScale);
        make.right.equalTo(ruleV).offset(-24*kScale);
    }];
    _ruleDetailLabel = ruleDetailLabel;
    ruleDetailLabel.numberOfLines = 0;
    ruleDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [ruleDetailLabel sizeThatFits:CGSizeMake(kMainScreenW-48*kScale,MAXFLOAT)];
    [ruleDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(size.height);
    }];
    
    
    [ruleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ruleDetailLabel.mas_bottom);
//        make.height.offset(50);
    }];
    
    UIView *likeBackgV = [[UIView alloc] init];
    likeBackgV.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [view addSubview:likeBackgV];
    [likeBackgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(ruleV.mas_bottom).offset(30);
        make.height.equalTo(@50);
    }];
    _likeBackgV = likeBackgV;
    
    
    UILabel *likeLabel = [[UILabel alloc] init];
    likeLabel.text = @"—— 猜你喜欢 ——";
    likeLabel.font = [UIFont systemFontOfSize:14];
    likeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    likeLabel.textAlignment = NSTextAlignmentCenter;
    [_likeBackgV addSubview:likeLabel];
    [likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(likeBackgV);
    }];
    _likeLabel = likeLabel;
//    likeLabel.hidden = YES;

    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_likeBackgV.mas_bottom);
    }];
//    [self layoutIfNeeded];
//
//    self.height = view.bottom;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom);
    }];
    [self layoutIfNeeded];
    CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame =frame;

    if (_isClicked) {
        _view.height = _view.height;
        self.height = self.height;
    }else{
        _view.height = _view.height + 50;
        self.height = self.height + 50;
    }
    
    if ([self.delegate respondsToSelector:@selector(calculateSignInVHeight:)]) {
        [self.delegate calculateSignInVHeight:self.height];
    }
}


- (void)setSignView{
    
    UIImageView *datebackgroundImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"datebackground"]];
    [_signInV addSubview:datebackgroundImageV];
    [datebackgroundImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_signInV);
        make.top.equalTo(_signInV).offset(31);
        make.size.mas_equalTo(CGSizeMake(214, 35));
    }];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init]; //初始化格式器。
    [formatter setDateFormat:@"YYYY年MM月dd日"];//定义时间为这种格式： YYYY-MM-dd hh:mm:ss 。
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];//将NSDate  ＊对象 转化为 NSString ＊对象
    NSString *weekStr = [self weekdayStringFromDate:[formatter dateFromString:currentTime]];
    
    dateLabel.text = [NSString stringWithFormat:@"%@ %@",currentTime,weekStr];
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor colorWithHexString:@"#BE6E34"];
    [_signInV addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_signInV);
        make.top.equalTo(datebackgroundImageV.mas_top).offset(8);
        make.size.mas_equalTo(CGSizeMake(180, 13));
    }];
    
    UIButton *atOnceSignInBtn = [[UIButton alloc] init];
    atOnceSignInBtn.layer.cornerRadius = 69;
    [atOnceSignInBtn setTitle:@"立即签到" forState:UIControlStateNormal];
//    [atOnceSignInBtn setTitle:@"已签到" forState:UIControlStateNormal];
    [atOnceSignInBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [atOnceSignInBtn setBackgroundImage:[UIImage imageNamed:@"atoncesignin"] forState:UIControlStateNormal];
    [atOnceSignInBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:atOnceSignInBtn];
    
    [atOnceSignInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_signInV.mas_centerX);
        make.top.equalTo(datebackgroundImageV.mas_bottom).offset(10*kScale);
        make.size.mas_equalTo(CGSizeMake(138*kScale, 138*kScale));
    }];
    _atOnceSignInBtn = atOnceSignInBtn;
    
    UIImageView *signInDateNumV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin"]];
    [_signInV addSubview:signInDateNumV];
    [signInDateNumV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_signInV).offset(kMainScreenW * 56 /375);
        make.top.equalTo(_signInV).offset(240*kScale);
        make.size.mas_equalTo(CGSizeMake(13, 14));
    }];
    
    UILabel *signInDateNumLabel = [[UILabel alloc] init];
    signInDateNumLabel.text = @"连续签到：0天";
    signInDateNumLabel.font = [UIFont systemFontOfSize:12];
    signInDateNumLabel.textAlignment = NSTextAlignmentLeft;
    signInDateNumLabel.textColor = [UIColor colorWithHexString:@"#BE6E34"];
    [_signInV addSubview:signInDateNumLabel];
    [signInDateNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signInDateNumV.mas_right).offset(6);
        make.centerY.equalTo(signInDateNumV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 12));
    }];
    _signInDateNumLabel = signInDateNumLabel;
    
    UIImageView *copperNumV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"copper"]];
    [_signInV addSubview:copperNumV];
//    CGFloat copperSpace = 217 / 375 * screenWidth;
    [copperNumV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_signInV).offset(kMainScreenW * 217 / 375);
        make.top.equalTo(_signInV).offset(240*kScale);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    UILabel *copperNumLabel = [[UILabel alloc] init];
    copperNumLabel.text = @"累计铜币：0个";
    copperNumLabel.font = [UIFont systemFontOfSize:12];
    copperNumLabel.textAlignment = NSTextAlignmentLeft;
    copperNumLabel.textColor = [UIColor colorWithHexString:@"#BE6E34"];
    [_signInV addSubview:copperNumLabel];
    [copperNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(copperNumV.mas_right).offset(6);
        make.centerY.equalTo(copperNumV.mas_centerY);
        make.right.equalTo(_signInV).offset(-10);
    }];
    
    _copperNumLabel = copperNumLabel;
    
}


- (void)respondEvent:(UIButton *)sender{

    if ([MDB_UserDefault getIsLogin]){
        
        
        if ([self.delegate respondsToSelector:@selector(signInBtnClick)]) {
            [self.delegate signInBtnClick];
//            _atOnceSignInBtn.userInteractionEnabled = NO;
//            _atOnceSignInBtn.selected = YES;
//            [_atOnceSignInBtn setTitle:@"已签到" forState:UIControlStateNormal];
            
        }
        _isClicked = YES;
        
//        _backgV.hidden = NO;
//        _ruleV.hidden = YES;
//        _likeBackgV.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
//        _likeLabel.hidden = NO;
//        _lukyLabel.hidden = YES;
        
//        [_view mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_backgV.mas_bottom);
//        }];
//        [self layoutIfNeeded];
//        self.height = _view.bottom;
//        if ([self.delegate respondsToSelector:@selector(calculateSignInVHeight:)]) {
//            [self.delegate calculateSignInVHeight:self.height];
//        }
        
    }else{
        [self showAlertView];
        
    }
}

- (void)showAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请登录后再试"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"登录",@"取消", nil];
    [alertView show];
    
}

//string转换成AttributedString
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二 ", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (void)setModel:(SignInHeadModel *)model{
    _model = model;
//    _copperNum = [model.copper integerValue];
//    _signDateNum = [model.signtimes integerValue];
    _signInDateNumLabel.text = [NSString stringWithFormat:@"连续签到：%@天",model.signtimes];
    _copperNumLabel.text = [NSString stringWithFormat:@"累计签到：%@个",model.copper];

    if ([model.conductstep isEqualToString:@"1"]){
        _atOnceSignInBtn.userInteractionEnabled = NO;
//        _atOnceSignInBtn.selected = YES;
        [_atOnceSignInBtn setTitle:@"已签到" forState:UIControlStateNormal];
    }
    else
    {
        _atOnceSignInBtn.userInteractionEnabled = YES;
        [_atOnceSignInBtn setTitle:@"立即签到" forState:UIControlStateNormal];
    }
    [self updateLukyLabelWithText:model.luckyuser];
    
}

- (void)updateLukyLabelWithText: (NSString *)text{
    UIView *backgV = [[UIView alloc] init];
    backgV.backgroundColor = [UIColor colorWithHexString:@"#d2b49f"];
    [self addSubview:backgV];
    [backgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_signInV.mas_bottom);
        make.height.offset(50);
    }];
    _backgV = backgV;
    
    UILabel *lukyLabel = [[UILabel alloc] init];
    lukyLabel.text = text;
    lukyLabel.font = [UIFont systemFontOfSize:14];
    lukyLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    lukyLabel.textAlignment = NSTextAlignmentCenter;
    [_backgV addSubview:lukyLabel];
    [lukyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backgV);
    }];
    _lukyLabel = lukyLabel;
    
    [_ruleV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgV.mas_bottom);
    }];
    if (_isClicked) {
        _view.height = _view.height;
        self.height = self.height;
    }else{
        _view.height = _view.height + 50;
        self.height = self.height + 50;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(calculateSignInVHeight:)]) {
        [self.delegate calculateSignInVHeight:self.height];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(ClickToVKLoginViewController:)]) {
            [self.delegate ClickToVKLoginViewController:theViewController];
        }
    }
}



@end
