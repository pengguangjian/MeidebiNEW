//
//  OneUserHeadTopView.m
//  Meidebi
//
//  Created by fishmi on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OneUserHeadTopView.h"
#import "MDB_UserDefault.h"
#import "SignInViewController.h"
#import "VKLoginViewController.h"
#import "ConversionViewController.h"
#import "FollowViewController.h"
#import "FansViewController.h"
#import "PersonalInfoViewController.h"
#import "PersonalInfoIndexViewController.h"
#import <UMAnalytics/MobClick.h>

#import "DailyLottoViewController.h"

@interface OneUserHeadTopView ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIView *userInfoView;
@end

@implementation OneUserHeadTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubView];
    }
    return self;
}

- (void)setUpheadViewData{
    if ([MDB_UserDefault getIsLogin]) {
        [_view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset((343-160)+90*kScale);
        }];
        [_userInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset((200-160)+90*kScale);
        }];
//        _personalHomeButton.hidden = NO;
        _userInfoView.hidden = NO;
        _loginBtn.hidden = YES;
        [self layoutView];
    }else{
        [_view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset((230-150)*kScale+120*kScale);
        }];
        _picV.image = [UIImage imageNamed:@"noavatar.png"];
        _loginBtn.hidden = NO;
        _personalHomeButton.hidden = YES;
        _userInfoView.hidden = YES;
    }
}

- (void)layoutView{
    MDB_UserDefault *_userDefault=[MDB_UserDefault defaultInstance];
    if ([[MDB_UserDefault defaultInstance].userphoto isEqualToString:@"http://img.meidebi.com/meidebiavatar/noavatar_middle.jpg"]) {
        _photoV.hidden = NO;
    }
    [[MDB_UserDefault defaultInstance]setViewImageWithURL:[NSURL URLWithString:[MDB_UserDefault defaultInstance].userphoto] placeholder:[UIImage imageNamed:@"noavatar.png"] UIimageview:_picV];
    if ([_userDefault.nickName isEqualToString:@""] || [_userDefault.nickName isEqualToString:@"(null)"]) {
        
        if (!_userDefault.userName ||_userDefault.userName.length == 0) {
            _nameLabel.text=@"";
        }else{
            _nameLabel.text = _userDefault.userName;
        }
    }else{
        _nameLabel.text=_userDefault.nickName;
    }
    
    if (_nameLabel.text.length <= 10) {
        CGRect titleSize = [_nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(titleSize.size.width + 5);
        }];
    }
    else
    {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(100);
        }];
    }
    _integralLabel.text = [NSString stringWithFormat:@"积分 %@",_userDefault.userjifen];
    _copperLabel.text = [NSString stringWithFormat:@"铜币 %@",_userDefault.usercoper];
    if ([_userDefault.userlevel isEqualToString:@""]) {
        _levNumLabel.text = @"0";
    }else{
        _levNumLabel.text = _userDefault.userlevel;
    }
    
    _contributionLabel.text = [NSString stringWithFormat:@"贡献值 %@",_userDefault.ueserContribution];
    
    [_fansBtn setTitle:[NSString stringWithFormat:@"粉丝 %@",_userDefault.userFans] forState:UIControlStateNormal];
    if ([_userDefault.userFollow isEqualToString:@"(null)"] ||[_userDefault.userFollow isEqualToString:@""]) {
        [_concernBtn setTitle:@"关注 0" forState:UIControlStateNormal];
    }else{
        [_concernBtn setTitle:[NSString stringWithFormat:@"关注 %@",_userDefault.userFollow] forState:UIControlStateNormal];
    }
}

- (void)setUpSubView{
    UIView *view =  [[UIView alloc ] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
    }];
    _view = view;
    
    UIImageView *picV = [[UIImageView alloc] init];
    picV.image = [UIImage imageNamed:@"noavatar.png"];
    picV.layer.cornerRadius = 80*kScale/2.0;
    picV.clipsToBounds = YES;
    picV.backgroundColor = [UIColor redColor];
    picV.userInteractionEnabled = YES;

    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picViewClicked)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [picV addGestureRecognizer:tapGesture];
    
    [view addSubview:picV];
    [picV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(25);
        make.size.mas_equalTo(CGSizeMake(80*kScale, 80*kScale));
    }];
    _picV = picV;
    
    _personalHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_view addSubview:_personalHomeButton];
    [_personalHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_view.mas_right).offset(-19);
        make.top.equalTo(_view.mas_top).offset(19);
        make.size.mas_equalTo(CGSizeMake(81, 26));
    }];
    _personalHomeButton.tag = 1000;
    _personalHomeButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_personalHomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_personalHomeButton setTitle:@"个人主页" forState:UIControlStateNormal];
    _personalHomeButton.backgroundColor = [UIColor colorWithHexString:@"#FF925D"];
    _personalHomeButton.layer.masksToBounds = YES;
    _personalHomeButton.layer.cornerRadius = 26.0/2;
    [_personalHomeButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _personalHomeButton.hidden = YES;
    
    UIImageView *photoV = [[UIImageView alloc] init];
    photoV.image = [UIImage imageNamed:@"camera"];
    [_view addSubview:photoV];
    [photoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_picV.mas_right);
        make.bottom.equalTo(_picV.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(17, 14));
    }];
    _photoV = photoV;
    photoV.hidden = YES;

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_view.mas_bottom);
    }];
    [self setUpLabel];
    [self setUpLoginBtn];
    [self setUpheadViewData];
    
    
    
    
}

- (void)setUpLabel{
    _userInfoView = [UIView new];
    [_view addSubview:_userInfoView];
    [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_picV.mas_bottom).offset(15);
        make.left.right.equalTo(_view);
        make.height.offset(200-25*kScale-5);
    }];
    _userInfoView.hidden = YES;
    _userInfoView.backgroundColor = [UIColor whiteColor];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(343-25*kScale-5);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor colorWithHexString:@"#454545"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [_userInfoView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userInfoView.mas_top);
        make.centerX.equalTo(_userInfoView.mas_centerX);
        make.width.offset(100);
    }];
    _nameLabel = nameLabel;
    
    UIImageView *levImgeV = [[UIImageView alloc] init];
    levImgeV.image = [UIImage imageNamed:@"dengji.jpg"];
    [_userInfoView addSubview:levImgeV];
    [levImgeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userInfoView.mas_top);
        make.left.equalTo(nameLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    _levImgeV = levImgeV;
    
    UILabel *levNumLabel = [[UILabel alloc] init];
    levNumLabel.text = @"0";
    levNumLabel.textColor = [UIColor whiteColor];
    levNumLabel.textAlignment = NSTextAlignmentRight;
    levNumLabel.font = [UIFont systemFontOfSize:9];
    [levImgeV addSubview:levNumLabel];
    [levNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(levImgeV);
        make.width.offset(8);
    }];
    _levNumLabel = levNumLabel;

    _levelNickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userInfoView addSubview:_levelNickButton];
    [_levelNickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levImgeV.mas_right).offset(4);
        make.centerY.equalTo(levImgeV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(61, 18));
    }];
    _levelNickButton.userInteractionEnabled = NO;
    _levelNickButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [_levelNickButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_levelNickButton setTitle:@"时尚达人" forState:UIControlStateNormal];
    [_levelNickButton setBackgroundImage:[UIImage imageNamed:@"open_url_btn_normal"] forState:UIControlStateNormal];
    [_levelNickButton setBackgroundImage:[UIImage imageNamed:@"open_url_btn_normal"] forState:UIControlStateHighlighted];
    _levelNickButton.hidden = YES;
    
    UILabel *copperLabel = [[UILabel alloc] init];
    copperLabel.text = @"铜币";
    copperLabel.textAlignment = NSTextAlignmentCenter;
    copperLabel.font = [UIFont systemFontOfSize:14];
    copperLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [_userInfoView addSubview:copperLabel];
    [copperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_userInfoView.mas_centerX);
        make.top.equalTo(nameLabel.mas_bottom).offset(20);
        make.width.equalTo(@100);
    }];
    _copperLabel = copperLabel;

    UIView *leftLineV = [[UIView alloc] init];
    leftLineV.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [_userInfoView addSubview:leftLineV];
    [leftLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(copperLabel.mas_left).offset(-15);
        make.size.mas_equalTo(CGSizeMake(1, 14));
        make.centerY.equalTo(copperLabel.mas_centerY);
    }];
    
    UILabel *integralLabel = [[UILabel alloc] init];
    integralLabel.text = @"积分";
    integralLabel.textAlignment = NSTextAlignmentCenter;
    integralLabel.font = [UIFont systemFontOfSize:14];
    integralLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [_userInfoView addSubview:integralLabel];
    [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copperLabel.mas_centerY);
        make.width.equalTo(@75);
        make.right.equalTo(leftLineV.mas_left).offset(-15);
    }];
    _integralLabel = integralLabel;
    
    UIView *rightLineV = [[UIView alloc] init];
    rightLineV.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [_userInfoView addSubview:rightLineV];
    [rightLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(copperLabel.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(1, 14));
        make.centerY.equalTo(copperLabel.mas_centerY);
    }];
    
    UILabel *contributionLabel = [[UILabel alloc] init];
    contributionLabel.text = @"贡献值";
    contributionLabel.textAlignment = NSTextAlignmentCenter;
    contributionLabel.font = [UIFont systemFontOfSize:14];
    contributionLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [_userInfoView addSubview:contributionLabel];
    [contributionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copperLabel.mas_centerY);
        make.width.equalTo(@75);
        make.left.equalTo(rightLineV.mas_right).offset(15);
    }];
    _contributionLabel = contributionLabel;
    
    /*
    UIView *centerLineV = [[UIView alloc] init];
    centerLineV.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [_userInfoView addSubview:centerLineV];
    [centerLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_view);
        make.size.mas_equalTo(CGSizeMake(1, 14));
        make.top.equalTo(copperLabel.mas_bottom).offset(18);
    }];
    
    
    
    UIButton *fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fansBtn.tag = 20;
    [fansBtn setTitle:@"粉丝" forState:UIControlStateNormal];
    fansBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fansBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [fansBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_userInfoView addSubview:fansBtn];
    [fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(centerLineV.mas_centerY);
        make.width.offset(75 *kScale);
        make.height.offset(14);
        make.right.equalTo(centerLineV.mas_left).offset(-15);
    }];
    _fansBtn = fansBtn;
    
    UIButton *concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    concernBtn.tag = 21;
    [concernBtn setTitle:@"关注" forState:UIControlStateNormal];
    concernBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [concernBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [concernBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_userInfoView addSubview:concernBtn];
    [concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(centerLineV.mas_centerY);
        make.width.offset(75 *kScale);
        make.height.offset(14);
        make.left.equalTo(centerLineV.mas_right).offset(15);
    }];
    _concernBtn = concernBtn;
    */
    
    CGSize sizetemp = CGSizeMake((BOUNDS_WIDTH-60)/4.0, 35*kScale);
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.tag = 10;
    [signBtn.layer setMasksToBounds:YES];
    [signBtn.layer setCornerRadius:5];
    [signBtn setImage:[UIImage imageNamed:@"home_user_qiandao"] forState:UIControlStateNormal];
    [signBtn setImage:[UIImage imageNamed:@"home_user_qiandao"] forState:UIControlStateHighlighted];
    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [signBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD7B0D"]];
    [signBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [signBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_userInfoView addSubview:signBtn];
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userInfoView).offset(19);
        make.top.equalTo(_contributionLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(sizetemp);
    }];
    _signBtn = signBtn;
    
    
    
    UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeBtn.tag = 11;
    [exchangeBtn.layer setMasksToBounds:YES];
    [exchangeBtn.layer setCornerRadius:5];
    [exchangeBtn setImage:[UIImage imageNamed:@"home_user_duihuan"] forState:UIControlStateNormal];
    [exchangeBtn setImage:[UIImage imageNamed:@"home_user_duihuan"] forState:UIControlStateHighlighted];
    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exchangeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [exchangeBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD7B0D"]];
    [exchangeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [exchangeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_userInfoView addSubview:exchangeBtn];
    [exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signBtn.mas_right).offset(8);
        make.centerY.equalTo(signBtn.mas_centerY);
        make.size.mas_equalTo(sizetemp);
    }];
    _exchangeBtn = exchangeBtn;
    
    
    
    UIButton *choujiangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    choujiangBtn.tag = 13;
    [choujiangBtn.layer setMasksToBounds:YES];
    [choujiangBtn.layer setCornerRadius:5];
    [choujiangBtn setImage:[UIImage imageNamed:@"home_user_choujiang"] forState:UIControlStateNormal];
    [choujiangBtn setImage:[UIImage imageNamed:@"home_user_choujiang"] forState:UIControlStateHighlighted];
    [choujiangBtn setTitle:@"抽奖" forState:UIControlStateNormal];
    [choujiangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [choujiangBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [choujiangBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD7B0D"]];
    [choujiangBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [choujiangBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_userInfoView addSubview:choujiangBtn];
    [choujiangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(exchangeBtn.mas_right).offset(8);
        make.centerY.equalTo(signBtn.mas_centerY);
        make.size.mas_equalTo(sizetemp);
    }];
    _chouJiangBtn = choujiangBtn;
    
    UIButton *gerenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gerenBtn.tag = 14;
    [gerenBtn.layer setMasksToBounds:YES];
    [gerenBtn.layer setCornerRadius:5];
    [gerenBtn setTitle:@"个人主页" forState:UIControlStateNormal];
    [gerenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gerenBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [gerenBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD7B0D"]];
    [gerenBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_userInfoView addSubview:gerenBtn];
    [gerenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(choujiangBtn.mas_right).offset(8);
        make.centerY.equalTo(signBtn.mas_centerY);
        make.size.mas_equalTo(sizetemp);
    }];
    _userinfoBtn = gerenBtn;

//    [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_picV.mas_bottom).offset(15);
//        make.left.right.equalTo(_view);
//        make.height.offset(200);
//    }];
//    [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(200-25*kScale-5);
//    }];
//    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(343);
//    }];
    
}

- (void)setUpLoginBtn{
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.tag = 12;
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setBackgroundColor:RadMenuColor];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:(45.0)/2]; //设置矩形四个圆角半径
    [_view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_view.mas_centerX);
        make.top.equalTo(_picV.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(157 *kScale, 45));
    }];
     _loginBtn = loginBtn;
    
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(230);
    }];
}

- (void)btnClicked: (UIButton *)sender{
    if (sender.tag == 10) {
        SignInViewController *vc = [[SignInViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [MobClick event:@"wode_qiandao"];
            [self.delegate clickToViewController:vc];
        }
    }else if(sender.tag == 12){
        VKLoginViewController *vc = [[VKLoginViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [self.delegate clickToViewController:vc];
        }
    }else if (sender.tag == 11){
        ConversionViewController *conversionVc = [[ConversionViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [MobClick event:@"wode_duihuan"];
            [self.delegate clickToViewController:conversionVc];
        }
    }else if (sender.tag == 13){///抽奖
        
        DailyLottoViewController *conversionVc = [[DailyLottoViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [MobClick event:@"zhuye_choujiang"];
            [self.delegate clickToViewController:conversionVc];
        }
    }else if (sender.tag == 14){///个人主页
        PersonalInfoIndexViewController *personalInfoIndexVc = [[PersonalInfoIndexViewController alloc] initWithUserID:@""];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [self.delegate clickToViewController:personalInfoIndexVc];
        }
    }else if (sender.tag == 20){
        FansViewController *fansVC = [[FansViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [MobClick event:@"wode_fensi"];
            [self.delegate clickToViewController:fansVC];
        }
    }else if (sender.tag ==21){
        FollowViewController *followVC = [[FollowViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [MobClick event:@"wode_guanzhu"];
            [self.delegate clickToViewController:followVC];
        }
    }else if (sender.tag == 1000){
        PersonalInfoIndexViewController *personalInfoIndexVc = [[PersonalInfoIndexViewController alloc] initWithUserID:@""];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [self.delegate clickToViewController:personalInfoIndexVc];
        }
    }
}

- (void)picViewClicked{
    if ([MDB_UserDefault getIsLogin]) {
        PersonalInfoViewController *personalVc = [[PersonalInfoViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [self.delegate clickToViewController:personalVc];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
    }


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
        if (buttonIndex == 0) {
            VKLoginViewController *vc = [[VKLoginViewController alloc] init];
            if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
                [self.delegate clickToViewController:vc];
            }
        }

    }
}


@end
