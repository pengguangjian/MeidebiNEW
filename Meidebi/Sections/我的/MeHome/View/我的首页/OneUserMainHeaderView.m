//
//  OneUserMainHeaderView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/5.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "OneUserMainHeaderView.h"
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
#import <UMAnalytics/MobClick.h>

#import "FansViewController.h"

#import "FollowViewController.h"

#import "PersonalInfoIndexViewController.h"

#import "SignInViewController.h"

#import "MyInformViewController.h"

#import "PersonalInfoViewController.h"

@interface OneUserMainHeaderView ()<UIAlertViewDelegate>
{
    UIImageView *imgvhead;
    
    UIView *viewinfo;
    
    UIButton *btdenglu;
    
    ///昵称
    UILabel *lbname;
    ///等级
    UILabel *levNumLabel;
    ///粉丝关注
    UIButton *fansBtn;
    UIButton *concernBtn;
    ////消息红点
    UIView *viewxxRed;
    
    
}

@end

@implementation OneUserMainHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self drawUI];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)drawUI
{
    ///渐变背景
    UIImageView *imgvback = [[UIImageView alloc] init];
    [self addSubview:imgvback];
    [imgvback  setImage:[UIImage imageNamed:@"oneusermain_userhead_back"]];
    [imgvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    ///头像
    imgvhead = [[UIImageView alloc] init];
    [self addSubview:imgvhead];
    [imgvhead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80*kScale);
        make.height.offset(80*kScale);
        make.left.offset(20);
        make.top.offset(40);
    }];
    [imgvhead setImage:[UIImage imageNamed:@"camera"]];
    [imgvhead.layer setMasksToBounds:YES];
    [imgvhead.layer setCornerRadius:80*kScale/2.0];
    [imgvhead setUserInteractionEnabled:YES];
    UITapGestureRecognizer *taphead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headAction)];
    [imgvhead addGestureRecognizer:taphead];
    
    
    [self drawmessage];
    
    btdenglu = [[UIButton alloc] init];
    [btdenglu setTitle:@"登录/注册" forState:UIControlStateNormal];
    [btdenglu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btdenglu.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:btdenglu];
    [btdenglu setHidden:YES];
    [btdenglu addTarget:self action:@selector(dengluAction) forControlEvents:UIControlEventTouchUpInside];
    [btdenglu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgvhead.mas_right).offset(20);
        make.centerY.equalTo(imgvhead);
        make.width.offset(80);
        make.height.offset(45);
    }];
    
}

-(void)drawmessage
{
    viewinfo = [[UIView alloc] init];
    [viewinfo setBackgroundColor:[UIColor clearColor]];
    [self addSubview:viewinfo];
    [viewinfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgvhead.mas_right).offset(20);
        make.top.bottom.right.equalTo(self);
    }];
    
    
    ///昵称
    lbname = [[UILabel alloc] init];
    [lbname setTextColor:[UIColor whiteColor]];
    lbname.text = @"昵称";
    lbname.textAlignment = NSTextAlignmentLeft;
    lbname.font = [UIFont systemFontOfSize:16];
    [viewinfo addSubview:lbname];
    [lbname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgvhead.mas_top);
        make.left.equalTo(viewinfo);
        //        make.width.offset(100);
    }];
    
    /////等级
    UIImageView *levImgeV = [[UIImageView alloc] init];
    levImgeV.image = [UIImage imageNamed:@"dengji.jpg"];
    [viewinfo addSubview:levImgeV];
    [levImgeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbname.mas_top);
        make.left.equalTo(lbname.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    levNumLabel = [[UILabel alloc] init];
    levNumLabel.text = @"0";
    levNumLabel.textColor = [UIColor whiteColor];
    levNumLabel.textAlignment = NSTextAlignmentRight;
    levNumLabel.font = [UIFont systemFontOfSize:9];
    [levImgeV addSubview:levNumLabel];
    [levNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(levImgeV);
        make.width.offset(8);
    }];
    
    
    
    
    ///粉丝关注
    fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fansBtn.tag = 20;
    [fansBtn setTitle:@"粉丝0" forState:UIControlStateNormal];
    fansBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fansBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [fansBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewinfo addSubview:fansBtn];
    [fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgvhead.mas_centerY);
        make.width.offset(70 *kScale);
        make.height.offset(14);
        make.left.equalTo(lbname.mas_left);
    }];
    fansBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [fansBtn setTag:1];
    [fansBtn addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *centerLineV = [[UIView alloc] init];
    centerLineV.backgroundColor = RGB(251, 161, 40);
    [viewinfo addSubview:centerLineV];
    [centerLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 14));
        make.centerY.equalTo(imgvhead.mas_centerY);
        make.left.equalTo(fansBtn.mas_right).offset(10);
    }];
    
    
    concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    concernBtn.tag = 21;
    [concernBtn setTitle:@"关注0" forState:UIControlStateNormal];
    concernBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [concernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [concernBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewinfo addSubview:concernBtn];
    [concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(centerLineV.mas_centerY);
        make.width.offset(70 *kScale);
        make.height.offset(14);
        make.left.equalTo(centerLineV.mas_right).offset(15);
    }];
    concernBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [concernBtn setTag:2];
    [concernBtn addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    ///个人主页
    UIButton *btgrzy = [[UIButton alloc] init];
    [btgrzy setTitle:@"个人主页" forState:UIControlStateNormal];
    [btgrzy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btgrzy.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btgrzy.layer setMasksToBounds:YES];
    [btgrzy.layer setCornerRadius:2];
    [btgrzy.layer setBorderColor:[UIColor whiteColor].CGColor];
    [btgrzy.layer setBorderWidth:1];
    [viewinfo addSubview:btgrzy];
    [btgrzy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbname);
        make.top.equalTo(concernBtn.mas_bottom).offset(15);
        make.height.offset(25);
        make.width.offset(70);
    }];
    [btgrzy setTag:3];
    [btgrzy addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btmessage = [[UIButton alloc] init];
    [btmessage setTitle:@"消息" forState:UIControlStateNormal];
    [btmessage setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btmessage.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [viewinfo addSubview:btmessage];
    [btmessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(90);
        make.top.equalTo(imgvhead);
        make.right.equalTo(viewinfo).offset(15);
    }];
    [btmessage.layer setMasksToBounds:YES];
    [btmessage.layer setCornerRadius:15];
    [btmessage setBackgroundColor:[UIColor whiteColor]];
    [btmessage setTag:4];
    [btmessage addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
    viewxxRed = [[UIView alloc] init];
    [viewxxRed setBackgroundColor:[UIColor redColor]];
    [btmessage addSubview:viewxxRed];
    [viewxxRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.height.offset(8);
        make.width.offset(8);
        make.centerY.equalTo(btmessage);
    }];
    [viewxxRed.layer setMasksToBounds:YES];
    [viewxxRed.layer setCornerRadius:4];
    [viewxxRed setHidden:YES];
    ///
    
    
    
    UIButton *btqiandao = [[UIButton alloc] init];
    [btqiandao setTitle:@"每日签到" forState:UIControlStateNormal];
    [btqiandao setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btqiandao.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [viewinfo addSubview:btqiandao];
    [btqiandao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(btmessage);
        make.width.equalTo(btmessage);
        make.top.equalTo(btmessage.mas_bottom).offset(20);
        make.right.equalTo(btmessage);
    }];
    [btqiandao.layer setMasksToBounds:YES];
    [btqiandao.layer setCornerRadius:15];
    [btqiandao setBackgroundColor:[UIColor whiteColor]];
    [btqiandao setTag:5];
    [btqiandao addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)loadViewUI
{
    if ([MDB_UserDefault getIsLogin])
    {
        [btdenglu setHidden:YES];
        [viewinfo setHidden:NO];
    }
    else
    {
        [btdenglu setHidden:NO];
        [viewinfo setHidden:YES];
    }
    
    
    
    
    ///更新信息
    [self layoutSubviews];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    MDB_UserDefault *_userDefault=[MDB_UserDefault defaultInstance];
    [[MDB_UserDefault defaultInstance]setViewImageWithURL:[NSURL URLWithString:[MDB_UserDefault defaultInstance].userphoto] placeholder:[UIImage imageNamed:@"noavatar.png"] UIimageview:imgvhead];
    if ([_userDefault.nickName isEqualToString:@""] || [_userDefault.nickName isEqualToString:@"(null)"]) {
        
        if (!_userDefault.userName ||_userDefault.userName.length == 0) {
            lbname.text=@"";
        }else{
            lbname.text = _userDefault.userName;
        }
    }else{
        lbname.text=_userDefault.nickName;
    }
    
    if (lbname.text.length <= 10) {
        CGRect titleSize = [lbname.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        [lbname mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(titleSize.size.width + 5);
        }];
    }
    else
    {
        [lbname mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(100);
        }];
    }
    if ([_userDefault.userlevel isEqualToString:@""]) {
        levNumLabel.text = @"0";
    }else{
        levNumLabel.text = _userDefault.userlevel;
    }
    
    NSString *strfs = [NSString stringWithFormat:@"粉丝 %@",[NSString nullToString:_userDefault.userFans]];
    float fwidth = [MDB_UserDefault countTextSize:CGSizeMake(90, 20) andtextfont:[UIFont systemFontOfSize:15] andtext:strfs].width+5;
    [fansBtn setTitle:strfs forState:UIControlStateNormal];
    [fansBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(fwidth);
    }];
    
    
    if ([_userDefault.userFollow isEqualToString:@"(null)"] ||[_userDefault.userFollow isEqualToString:@""]) {
        [concernBtn setTitle:@"关注 0" forState:UIControlStateNormal];
    }else{
        [concernBtn setTitle:[NSString stringWithFormat:@"关注 %@",_userDefault.userFollow] forState:UIControlStateNormal];
    }
    ///所有的未读消息
    /*
     [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_commentnum] forKey:@"commentnum"];
     [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_zannum] forKey:@"votenum"];
     [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_ordernum] forKey:@"ordernum"];
     */
    ///
    
    NSString *_commentnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"commentnum"];
    NSString *_zannum = [[NSUserDefaults standardUserDefaults] objectForKey:@"votenum"];
    NSString *_orderunm = [[NSUserDefaults standardUserDefaults] objectForKey:@"ordernum"];
    if(_commentnum.integerValue+_zannum.integerValue+_orderunm.integerValue>0)
    {
        [viewxxRed setHidden:NO];
    }
    else
    {
        [viewxxRed setHidden:YES];
    }
    
    
}

-(void)headAction
{
    if ([MDB_UserDefault getIsLogin] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    
    PersonalInfoViewController *personalVc = [[PersonalInfoViewController alloc] init];
    [self.viewController.navigationController pushViewController:personalVc animated:YES];
    
    
}

-(void)headerAction:(UIButton *)sender
{
    if ([MDB_UserDefault getIsLogin] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    
    switch (sender.tag) {
        case 1:
        {///粉丝
            [MobClick event:@"wode_fensi"];
            FansViewController *fansVC = [[FansViewController alloc] init];
            [self.viewController.navigationController pushViewController:fansVC animated:YES];
                
        }
            break;
        case 2:
        {///关注
            [MobClick event:@"wode_guanzhu"];
            FollowViewController *followVC = [[FollowViewController alloc] init];
            [self.viewController.navigationController pushViewController:followVC animated:YES];
                
        }
            break;
        case 3:
        {///个人主页
            PersonalInfoIndexViewController *personalInfoIndexVc = [[PersonalInfoIndexViewController alloc] initWithUserID:@""];
            [self.viewController.navigationController pushViewController:personalInfoIndexVc animated:YES];
        }
            break;
        case 4:
        {///消息
            [MobClick event:@"wode_xiaoxi"];
            NSString *_commentnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"commentnum"];
            NSString *_zannum = [[NSUserDefaults standardUserDefaults] objectForKey:@"votenum"];
            NSString *_orderunm = [[NSUserDefaults standardUserDefaults] objectForKey:@"ordernum"];
            
            UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
            MyInformViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyInformViewC"];
            mybrokenews.commentnum = _commentnum;
            mybrokenews.zannum = _zannum;
            mybrokenews.orderunm = _orderunm;
            [self.viewController.navigationController pushViewController:mybrokenews animated:YES];
        }
            break;
        case 5:
        {///签到
            [MobClick event:@"wode_qiandao"];
            SignInViewController *vc = [[SignInViewController alloc] init];
            [self.viewController.navigationController pushViewController:vc animated:YES];
                
        }
            break;
        default:
            break;
    }
}


-(void)dengluAction
{
    VKLoginViewController *vc = [[VKLoginViewController alloc] init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
        if (buttonIndex == 0) {
            VKLoginViewController *vc = [[VKLoginViewController alloc] init];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        
    }
}


@end
