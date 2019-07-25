//
//  InviteFriendSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "InviteFriendSubjectView.h"
#import "MDB_UserDefault.h"
@interface InviteFriendSubjectView ()
{
    UILabel *lbyouhuiquan;
    UILabel *lbtext;
    UILabel *lbliucmoney;
    
    UIImageView *imagevitem;
}
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *inviteQRCodeImageView;
@property (nonatomic, strong) UILabel *integralNumLabel;
@property (nonatomic, strong) UILabel *regisNumLabel;
@property (nonatomic, strong) UILabel *inviteCodeLabel;

@end

@implementation InviteFriendSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    
    UIScrollView *scvback =[[UIScrollView alloc] init];
    [self addSubview:scvback];
    [scvback setBackgroundColor:[UIColor whiteColor]];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    
    UIImageView *imgvtopback = [[UIImageView alloc] init];
    [scvback addSubview:imgvtopback];
    UIImage *imagetopback = [UIImage imageNamed:@"yaoqinghaoyoutopback_top"];
    [imgvtopback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.width.offset(kMainScreenW);
        make.height.offset(220);
    }];
    [imgvtopback setImage:imagetopback];

    UILabel *lbyaoqingtitle = [[UILabel alloc] init];
    [imgvtopback addSubview:lbyaoqingtitle];
    [lbyaoqingtitle mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.offset(30);
        make.left.right.equalTo(imgvtopback);
        make.height.offset(35);
    }];
    [lbyaoqingtitle setText:@"邀请好友送"];
    [lbyaoqingtitle setTextColor:[UIColor whiteColor]];
    [lbyaoqingtitle setTextAlignment:NSTextAlignmentCenter];
    [lbyaoqingtitle setFont:[UIFont boldSystemFontOfSize:30]];
    
    
    imagevitem = [[UIImageView alloc] init];
    [imgvtopback addSubview:imagevitem];
    UIImage *imageitem = [UIImage imageNamed:@"yaoqinghaoyoutopitemback_item"];
    [imagevitem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgvtopback.mas_centerX);
        make.top.equalTo(lbyaoqingtitle.mas_bottom).offset(30);
        make.width.offset(kMainScreenW*0.55);
        make.height.offset(imageitem.size.height*(kMainScreenW*0.55)/imageitem.size.width);
    }];
    [imagevitem setImage:imageitem];
    
    
    ////
    lbyouhuiquan = [[UILabel alloc] init];
    [imagevitem addSubview:lbyouhuiquan];
    [lbyouhuiquan mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(0);
        make.right.equalTo(imagevitem.mas_right);
        make.top.offset(0);
        make.height.equalTo(imagevitem.mas_height);
        
    }];
    NSString *strstring = @"￥7.00 商品券";
    [lbyouhuiquan setTextAlignment:NSTextAlignmentCenter];
    [lbyouhuiquan setTextColor:RGB(87, 87, 87)];
    [lbyouhuiquan setText:strstring];
    [lbyouhuiquan setFont:[UIFont systemFontOfSize:14]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strstring];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(246, 76, 43) range:NSMakeRange(0,strstring.length-3)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:35] range:NSMakeRange(1,strstring.length-4)];
    [lbyouhuiquan setAttributedText:str];
    
    
    ///
    UIView *viewliuc = [[UIView alloc] init];
    [scvback addSubview:viewliuc];
    [viewliuc mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(imgvtopback.mas_bottom);
        make.left.offset(0);
        make.right.equalTo(imgvtopback);
        make.height.offset(100);
        
    }];
    [viewliuc setBackgroundColor:[UIColor whiteColor]];
    [self drawliucheng:viewliuc];
    
    
    ////
    UIView *viewyqm =[[UIView alloc] init];
    [scvback addSubview:viewyqm];
    [viewyqm mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(viewliuc.mas_bottom);
        make.left.offset(0);
        make.right.equalTo(imgvtopback);
        make.height.offset(100);
        
    }];
    [viewyqm setBackgroundColor:RGB(255, 236, 228)];
    [self drawyaoqingm:viewyqm];
    
    ///
    UIView *viewgzsm =[[UIView alloc] init];
    [scvback addSubview:viewgzsm];
    [viewgzsm mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(viewyqm.mas_bottom);
        make.left.offset(0);
        make.right.equalTo(imgvtopback);
        
    }];
    [viewgzsm setBackgroundColor:RGB(255, 255, 255)];
    [self drawguizhesm:viewgzsm];
    
    [scvback mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(viewgzsm.mas_bottom);
    }];
    
    
}
///获取流程
-(void)drawliucheng:(UIView *)view
{
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(51, 51, 51)];
    [view addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(1);
        make.centerX.equalTo(view.mas_centerX);
        make.top.offset(35);
    }];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.offset(80);
        make.centerX.equalTo(viewline.mas_centerX);
        make.centerY.equalTo(viewline.mas_centerY);
        
    }];
    [lbtitle setText:@"获取流程"];
    [lbtitle setTextColor:RGB(51, 51, 51)];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setBackgroundColor:[UIColor whiteColor]];
    
    
    NSArray *arrimage = @[@"yaoqinghaoyouitem_01",@"yaoqinghaoyouitem_02",@"yaoqinghaoyouitem_03"];
    NSArray *arrtitle = @[@"邀请好友",@"好友注册成功",@"获得¥7.00商品券 "];
    NSArray *arrcontent = @[@"下载没得比app",@"并成功下单(代购订单）",@"（限代购订单使用）"];
    
    
    for(int i = 0 ; i < arrimage.count;i++)
    {
        UIImageView *imgv = [[UIImageView alloc] init];
        [view addSubview:imgv];
        if(i==0)
        {
            [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(30*kScale);
                make.top.equalTo(lbtitle.mas_bottom).offset(20);
                make.width.height.offset(80*kScale);
            }];
        }
        else if (i==1)
        {
            [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view.mas_centerX);
                make.top.equalTo(lbtitle.mas_bottom).offset(20);
                make.width.height.offset(80*kScale);
            }];
        }
        else
        {
            [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.mas_right).offset(-30*kScale);
                make.top.equalTo(lbtitle.mas_bottom).offset(20);
                make.width.height.offset(80*kScale);
            }];
        }
        [imgv setImage:[UIImage imageNamed:arrimage[i]]];
        
        
        
        UILabel *lbtit = [[UILabel alloc] init];
        [view addSubview:lbtit];
        [lbtit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgv.mas_bottom).offset(5);
            make.centerX.equalTo(imgv.mas_centerX);
        }];
        [lbtit setTextAlignment:NSTextAlignmentCenter];
        [lbtit setTextColor:RGB(51, 51, 51)];
        [lbtit setText:arrtitle[i]];
        [lbtit setFont:[UIFont systemFontOfSize:12]];
        if(i==arrimage.count-1)
        {
            lbliucmoney = lbtit;
            
        }
        
        UILabel *lbcont = [[UILabel alloc] init];
        [view addSubview:lbcont];
        [lbcont mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbtit.mas_bottom).offset(2);
            make.centerX.equalTo(imgv.mas_centerX);
            make.height.offset(15);
        }];
        [lbcont setTextAlignment:NSTextAlignmentCenter];
        [lbcont setTextColor:RGB(153, 153, 153)];
        [lbcont setText:arrcontent[i]];
        [lbcont setFont:[UIFont systemFontOfSize:10]];
        
        
    }
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(80*kScale+67+49);
    }];

}

-(void)drawyaoqingm:(UIView *)view
{
    
    UILabel *inviteCodeTitleLabel = [[UILabel alloc] init];
    [view addSubview:inviteCodeTitleLabel];
    [inviteCodeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(0);
        make.width.equalTo(view);
        make.height.offset(50);
    }];
    inviteCodeTitleLabel.textColor = RGB(225, 125, 0);
    inviteCodeTitleLabel.font = [UIFont systemFontOfSize:16.f];
    inviteCodeTitleLabel.text = @"您的专属邀请码（点击复制）";
    inviteCodeTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *inviteCodeLabel = [[UILabel alloc] init];
    [view addSubview:inviteCodeLabel];
    [inviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(10);
//        make.right.equalTo(view.mas_right).offset(-10);
        make.top.equalTo(inviteCodeTitleLabel.mas_bottom);
        make.height.offset(30);
        make.centerX.equalTo(view.mas_centerX);
        make.width.offset(150);
        
    }];
    [inviteCodeLabel.layer setMasksToBounds:YES];
    [inviteCodeLabel.layer setCornerRadius:2];
    [inviteCodeLabel setBackgroundColor:[UIColor whiteColor]];
    inviteCodeLabel.textColor = RGB(246, 76, 43);
    inviteCodeLabel.font = [UIFont boldSystemFontOfSize:17.f];
    inviteCodeLabel.textAlignment = NSTextAlignmentCenter;
    _inviteCodeLabel = inviteCodeLabel;
    [_inviteCodeLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *taplb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeCopyAction)];
    [_inviteCodeLabel addGestureRecognizer:taplb];
    
    ///完
    
    UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:inviteBtn];
    [inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35);
        make.right.equalTo(view.mas_right).offset(-35);
        make.top.equalTo(inviteCodeLabel.mas_bottom).offset(20);
        make.height.offset(60);
    }];
    inviteBtn.backgroundColor = [UIColor colorWithHexString:@"#F95C4F"];
    inviteBtn.layer.masksToBounds = YES;
    inviteBtn.layer.cornerRadius = 4.f;
    inviteBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inviteBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
    [inviteBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(205);
    }];
}
////规则说明
-(void)drawguizhesm:(UIView *)view
{
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(51, 51, 51)];
    [view addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(1);
        make.centerX.equalTo(view.mas_centerX);
        make.top.offset(35);
    }];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.offset(80);
        make.centerX.equalTo(viewline.mas_centerX);
        make.centerY.equalTo(viewline.mas_centerY);
        
    }];
    [lbtitle setText:@"规则说明"];
    [lbtitle setTextColor:RGB(51, 51, 51)];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setBackgroundColor:[UIColor whiteColor]];
    
    lbtext = [[UILabel alloc] init];
    [view addSubview:lbtext];
    [lbtext mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(lbtitle.mas_bottom).offset(20);
        make.height.offset(20);
    }];
    
    [lbtext setNumberOfLines:0];
    [lbtext setTextColor:RGB(153, 153, 153)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:12]];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(lbtext.mas_bottom).offset(20);
    }];
    
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(inviteFriendSubjectViewDidClickInviteBtn)]) {
        [self.delegate inviteFriendSubjectViewDidClickInviteBtn];
    }
}

- (void)bindDataWithModel:(NSDictionary *)dict{
    if (!dict) return;
    _regisNumLabel.text = [NSString stringWithFormat:@"%@",[NSString nullToString:dict[@"invitation_num"]]];
    _integralNumLabel.text = [NSString stringWithFormat:@"%@",[NSString nullToString:dict[@"integral"]]];
    _inviteCodeLabel.text = [NSString stringWithFormat:@"%@",[NSString nullToString:dict[@"invitation_code"]]];
    [[MDB_UserDefault defaultInstance] setViewWithImage:_inviteQRCodeImageView url:[NSString nullToString:dict[@"img_url"]]];
    
    
    
    NSString *stryq = @"";
    NSString *stryqxz = @"";
    
    NSString *strzc = @"";
    NSString *strzcxz = @"";
    if([[dict objectForKey:@"invitecoupon"] isKindOfClass:[NSDictionary class]])
    {
        stryq = [NSString nullToString:[[dict objectForKey:@"invitecoupon"] objectForKey:@"denomination"]];
        stryqxz = [NSString nullToString:[[dict objectForKey:@"invitecoupon"] objectForKey:@"usecondition"]];
    }
    
    
    if([[dict objectForKey:@"registercoupon"] isKindOfClass:[NSDictionary class]])
    {
        strzc = [NSString nullToString:[[dict objectForKey:@"registercoupon"] objectForKey:@"denomination"]];
        strzcxz = [NSString nullToString:[[dict objectForKey:@"registercoupon"] objectForKey:@"usecondition"]];
    }
    
    
    
    NSString *strstring = [NSString stringWithFormat:@"￥%@ 商品券",stryq];
    _stryaoqingmoney = strzc;
    
    [lbyouhuiquan setTextAlignment:NSTextAlignmentCenter];
    [lbyouhuiquan setTextColor:RGB(87, 87, 87)];
    [lbyouhuiquan setText:strstring];
    [lbyouhuiquan setFont:[UIFont systemFontOfSize:14]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strstring];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(246, 76, 43) range:NSMakeRange(0,strstring.length-3)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:35] range:NSMakeRange(1,strstring.length-4)];
    [lbyouhuiquan setAttributedText:str];
    
//    float f1 = [MDB_UserDefault countTextSize:CGSizeMake(kMainScreenW*0.45, 30) andtextfont:[UIFont systemFontOfSize:35] andtext:[str.string substringWithRange:NSMakeRange(1,strstring.length-4)]].width;
//    float f2 = [MDB_UserDefault countTextSize:CGSizeMake(kMainScreenW*0.35, 30) andtextfont:[UIFont systemFontOfSize:14] andtext:@"￥ 商品券"].width;
//    [imagevitem mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.width.offset(f1+f2+20);
//        make.centerX.equalTo(self.mas_centerX);
//    }];
    
    NSString *strtext1 = @"无门槛";
    NSString *stryqxztext = strtext1;
    if(stryqxz.floatValue>0)
    {
        stryqxztext = [NSString stringWithFormat:@"满%@可用",stryqxz];
    }
    NSString *strzcxztext = strtext1;
    if(strzcxz.floatValue>0)
    {
        strzcxztext = [NSString stringWithFormat:@"满%@可用",strzcxz];
    }
    
    NSString *strtext = [NSString stringWithFormat:@"1、邀请好友，好友下载app，并用分享者的邀请码注册，注册后成功下单代购商品（代购商品不限金额），下单后分享者获得¥%@商品券（%@）\n\n2、被邀请的好友首次注册即可获得¥%@商品券（%@）\n\n3、商品券适用于所有代购订单，满足条件即可使用\n\n4、邀请好友送贡献值的机制还保留，每邀请一个好友获得20贡献值，每日邀请人数不限；每邀请满10个额外赠送100铜币 ",stryq,stryqxztext,strzc,strzcxztext];
    float fh = [MDB_UserDefault countTextSize:CGSizeMake(kMainScreenW-30, 1000) andtextfont:[UIFont systemFontOfSize:12] andtext:strtext].height+10 ;
    [lbtext mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(fh);
    }];
    [lbtext setText:strtext];
//    获得¥7.00商品券
    [lbliucmoney setText:[NSString stringWithFormat:@" 获得¥%@商品券",stryq]];
    
    
}

#pragma mark - 复制
-(void)codeCopyAction
{
    if(_inviteCodeLabel.text.length<1)
    {
        return;
    }
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    
    pastboard.string = _inviteCodeLabel.text;
    [MDB_UserDefault showNotifyHUDwithtext:@"复制成功" inView:self];
}

@end
